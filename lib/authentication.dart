import 'objects.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
class AuthenticationSystem{
  User _currentUser;
  FirebaseAnalytics _firebaseAnalytics;
  static AuthenticationSystem _instance;
  bool isInitialised = false;
  FirebaseAuth _firebaseAuth;
  GoogleSignIn _googleSignIn;
  //FacebookLogin _facebookLogin;
  //TwitterLogin _twitterLogin;
  Firestore _firestore;
  CollectionReference _users;
  void _init(){
    if(!isInitialised){
      _firebaseAuth = FirebaseAuth.instance;
     // _facebookLogin = new FacebookLogin();
      _googleSignIn = new GoogleSignIn(scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],);
     /* _twitterLogin = new TwitterLogin(
          consumerKey: "wz0MSNhinMnCN55fXfKbkhWBC",
          consumerSecret: "rYODZrgzPnwhYr44DSX5u9umqNo1PJTKOKptwq748Kd06ju67s"
      );*/
      _firestore = Firestore.instance;
      _firebaseAnalytics = new FirebaseAnalytics();
      _users = _firestore.collection("/Users");
      isInitialised = true;
    }
  }
  static AuthenticationSystem get instance{
    if(_instance != null){
      return _instance;
    }else{
      _instance = new AuthenticationSystem();
      _instance._init();
      return _instance;
    }
  }
  Future<FirebaseUser> get currentFirebaseUser async {
    return await _firebaseAuth.currentUser();
  }
  Firestore get firestoreInstance {
    return _firestore;
  }
  Future<User> initializeUser(FirebaseUser firebaseUser) async{
  var doc = await _users.document(firebaseUser.uid).get();
  if(doc.exists){
    _currentUser = User.fromJson(doc.data);
  }else{
    User user = new User();
    firebaseUser.sendEmailVerification();
    user.email = firebaseUser.email;
    user.uid = firebaseUser.uid;
    user.username = firebaseUser.email.split("@")[0];
    await doc.reference.setData(user.toJson).whenComplete((){
      _currentUser = user;
    });
  }
  return _currentUser;
  }
  CollectionReference  getTopicReference(int showId){
    return _firestore.collection("/Shows/$showId/Topics");
  }
  User get currentUser{
    return _currentUser;
  }
  @override
  String toString() {
      // TODO: implement toString
      if(_currentUser != null){
      return _currentUser.username;
      }else{
        return super.toString();
      }
    }
  Future<FirebaseUser> signInWithGoogle() async {
    FirebaseUser user;
    await _googleSignIn.signIn().then((userAccount){
      userAccount.authentication.then((auth){
        _firebaseAuth.signInWithGoogle(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        ).then((firebaseUser){
          user = firebaseUser;
          _firebaseAnalytics.logLogin();
        });
      });
    });

      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);
      await initializeUser(currentUser);
      return currentUser;
    }
  Future<FirebaseUser> googleSilentSignIn() async{
    FirebaseUser user;
    await _googleSignIn.signInSilently().then((userAccount){
      userAccount.authentication.then((auth){
        _firebaseAuth.signInWithGoogle(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        ).then((firebaseUser){
          user = firebaseUser;
          _firebaseAnalytics.logLogin();
        });
      });
    });
    await initializeUser(user);
    return user;
  }
  Future<FirebaseUser> signInWithEmail(String email,String password) async{
    FirebaseUser user;
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((firebaseUser) async {
      user = firebaseUser;
      _firebaseAnalytics.logLogin();
      await initializeUser(user);
    }).catchError((e){
      print(e);
      if(e.toString().contains("no user record")){
        throw userNotFound();
      }
      if(e.toString().contains("password is invalid")){
        throw userNotFound();
      }
      if(e.toString().contains("account has been disabled")){
        throw accountDisabled();
      }
    });
    return user;
  }
  Future<FirebaseUser> signUpWithEmail(String email,String password)async{
    FirebaseUser user;
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((firebaseUser) async{
      user = firebaseUser;
      _firebaseAnalytics.logLogin();
      await initializeUser(user);
    }).catchError((e){
      print(e);
      if(e.toString().contains("email address is already in use")){
        throw userExists();
      }
      if(e.toString().contains("account has been disabled")){
        throw accountDisabled();
      }
    });
    return user;
  }
  /*Future<FirebaseUser> signInWithFacebook() async{
    FirebaseUser user;
    var result = await _facebookLogin.logInWithReadPermissions(['email','user_friends']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        await _firebaseAuth.signInWithFacebook(accessToken: result.accessToken.token).then((firebaseUser){
          user = firebaseUser;
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        user = null;
        break;
      case FacebookLoginStatus.error:
        throw new Exception("Facebook connection error");
        break;
    }
    return user;
  }*/
  /*Future<FirebaseUser> signInWithTwitter() async{
    FirebaseUser user;
    var result = await _twitterLogin.authorize();
    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        await _firebaseAuth.signInWithTwitter(authToken: result.session.token,authTokenSecret: result.session.secret).then((firebaseUser){
          user = firebaseUser;
        });
        break;
      case TwitterLoginStatus.cancelledByUser:
        user = null;
        break;
      case TwitterLoginStatus.error:
        throw new Exception("Twitter connection error");
        break;
    }
    return user;
  }*/
  static Exception userExists(){
    return new Exception("This email is already in use");
  }
  static Exception userNotFound(){
    return new Exception("Invalid Email or password");
  }
  static Exception accountDisabled(){
    return new Exception("Account has been disabled");
  }
}