import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' show ImageFilter;
import 'authentication.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'mainpage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StartPage extends StatefulWidget {
  StartPage({key, this.title}) : super(key: key);
  final String title;
  @override
  _StartPageState createState() => new _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.topCenter,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/images/got.gif"),
            fit: BoxFit.fitHeight,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
          ),
          new Center(
              child: new ClipRect(
            child: new BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.black.withAlpha(1)),
              ),
            ),
          )),
          new Container(
            margin: const EdgeInsets.only(top: 100.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new FlutterLogo(
                          size: 50.0,
                        ),
                        new Text(
                          widget.title,
                          style: new TextStyle(
                              color: Colors.white, fontSize: 30.0),
                        ),
                      ],
                    )),
               /* new Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 80.0, horizontal: 8.0),
                  child: new Center(
                    child: new Text(
                      "\"This is Some Big Quote which you might not like.\"",
                       maxLines:3,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),*/
               /* new Flexible(
                  child: new Wrap(
                    runSpacing: 10.0,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      new Center(
                        child: new Container(
                          width: 300.0,
                          height: 40.0,
                          child: new RaisedButton(
                              color: Colors.red.shade400,
                              onPressed: () => print("Signed into google"),
                              child: new ListTile(
                                  title: new Text(
                                    "Sign In with Google",
                                    style: new TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  leading: new Icon(
                                    FontAwesomeIcons.google,
                                  ))),
                        ),
                      ),
                      new Center(
                        child: new Container(
                          width: 300.0,
                          height: 40.0,
                          child: new RaisedButton(
                            color: Colors.blue.shade900,
                            onPressed: () => print("Signed into google"),
                            child: new ListTile(
                              title: new Text(
                                "Sign In with Facebook",
                                style: new TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              leading: new Icon(FontAwesomeIcons.facebook),
                            ),
                          ),
                        ),
                      ),
                      new Center(
                        child: new Container(
                          width: 300.0,
                          height: 40.0,
                          child: new RaisedButton(
                            color: Colors.blue,
                            onPressed: () => print("Signed into google"),
                            child: new ListTile(
                              title: new Text(
                                "Sign In with Twitter",
                                style: new TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              leading: new Icon(FontAwesomeIcons.twitter),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )*/
              
              new Expanded(
                child: new Container(
              ),),
              new Container(
                margin: const EdgeInsets.only(bottom: 30.0),
                child: new Wrap(
                  direction: Axis.vertical,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    new Container(
                        child: new Center(
                          child: new MaterialButton(
                          elevation: 4.0,
                          color: Colors.blue,
                          onPressed: ()=>Navigator.push(context, new PageRouteBuilder(
                            pageBuilder: (_,__,___)=>new SignUpPage(),
                            transitionsBuilder: (context,animation,sAnimation,child)=>
                                new FadeTransition(opacity: animation,child: child,)
                          )),
                          child:new Container(
                            width: 250.0,
                            height: 60.0,
                            child:  new Center(child: new Text("Get Started",style: new TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                            ),)),
                          ),
                      ),
                        ),
                    ),
                    new FlatButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: ()=>Navigator.push(context, new PageRouteBuilder(
                          pageBuilder: (_,__,___)=>new LoginPage(),
                          transitionsBuilder: (context,animation,sAnimation,child)=>
                          new FadeTransition(opacity: animation,child: child,)
                      )),
                      child: new Center(child: new Text("Already Have Account? Sign In",style: new TextStyle(
                        color: Colors.white,
                      ),)),
                    )
                  ]
                ),
              )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget{
  @override
  LoginPageState createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  bool hidepassword = true;

  TextEditingController emailController;
  TextEditingController passwordController;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String error = "";
  void onPasswordVisibilityChanged(){
    hidepassword = !hidepassword;
    setState(() {

        });
  }
  @override
  void initState() {
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    // TODO: implement initState
    super.initState();
  }
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          centerTitle: true,
          elevation: 0.5,
          title: new  Text("Log In"),
          actions: <Widget>[
            new FlatButton(onPressed: ()=>Navigator.pushReplacement(context, new PageRouteBuilder(
              pageBuilder: (_,__,___)=>new SignUpPage(),
              transitionsBuilder:(context,animation,sAnimation,child)=> new FadeTransition(
                opacity: animation ,child: child,)
            )), child: new Text("Sign Up",
              style:new TextStyle(color: Colors.blue),
      ),highlightColor: Colors.transparent,splashColor: Colors.transparent,),
          ],
        ),
        body: new Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 8.0),
          child: new Form(
            key: formKey,
            child: new Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                //Email
                new Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2.0
                      )
                    ],
                  ),
                  child: new TextFormField(
                    controller: emailController,
                    validator: (val)=> emailController.text.contains("@")?null:"Invalid Email",
                    decoration:new InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      border: InputBorder.none,
                      prefixIcon: new Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: new Icon(Icons.email,size:30.0,color: Colors.black26,),
                      ),
                      hintText: "Email"
                    ),
                  ),
                ),
                //Password
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2.0
                      )
                    ],
                  ),
                  child: new TextFormField(
                    controller: passwordController,
                    obscureText: hidepassword,
                    decoration:new InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      border: InputBorder.none,
                      prefixIcon: new Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: new Icon(Icons.lock,size:30.0,color: Colors.black26,),
                      ),
                      suffixIcon: new GestureDetector(
                        child: new Icon(hidepassword == true?Icons.visibility:Icons.visibility_off,color: Colors.black26,),
                        onTap: ()=> onPasswordVisibilityChanged(),
                      ),
                      hintText: "Password"
                    ),
                  ),
                ),
               new Center(
                 child:error == ""?
                 new Container():
                     new Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
                     child: new Row(
                       children: <Widget>[
                         new Icon(Icons.error,color: Colors.red,),
                         new Text(error),
                       ],
                     ),)
                 ,
               ),
               //Log In Button
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  constraints: new BoxConstraints.loose(new Size.fromHeight(50.0)),
                  child: new MaterialButton(
                    height: 50.0,
                    onPressed: (){
                      if(formKey.currentState.validate()){
                        scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(
                            "Loggin In"
                        )));
                        AuthenticationSystem.instance.signInWithEmail(emailController.text,passwordController.text).then((u){
                          if(u?.uid != null){
                          Navigator.pushReplacement(context, new PageRouteBuilder(
                              pageBuilder: (_,__,___)=> new MainPage(title: "Show Talks",),
                              transitionsBuilder:
                                  (context,animation,sAnimation,child)
                              =>new FadeTransition(opacity: animation,child: child,)
                          )); 
                          setState((){
                            error = "";
                          });

                          }else{
                            setState(() {
                               error = "User does not exist"   ;                        
                                                        });
                          }
                        }).catchError((e){
                          setState(() {
                            error = e.toString().substring(10,e.toString().length);
                          });
                        });
                      }
                    },
                    color: Colors.blue,
                    child: new Text(
                      "Log In",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 30.0
                      ),
                    ),
                  ),
                ),
                //Or Text
                new Container(
                  margin: const EdgeInsets.all(10.0),
                  child: new Stack(
                    children: <Widget>[
                      new Center(
                    child: new Text("OR"),
                  ),
                  new Positioned(
                    right: 4.0,
                    child: new GestureDetector(
                      onTap: ()=> print("Forgot Password"),
                      child: new Text("Forgot password?"),
                    )
                  ),
                    ],
                  )
                ),
                //Google
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  constraints: new BoxConstraints.loose(new Size.fromHeight(50.0)),
                  child: new MaterialButton(
                    height: 50.0,
                    onPressed: (){
                      AuthenticationSystem.instance.signInWithGoogle();
                    },
                    color: Colors.red.shade700,
                    child: new Text(
                      "Google Sign In",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0
                      ),
                    ),
                  ),
                ),
               /* //Facebook
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  constraints: new BoxConstraints.loose(new Size.fromHeight(50.0)),
                  child: new MaterialButton(
                    height: 50.0,
                    onPressed: ()=>print("Sign In With Facebook"),
                    color: Colors.blue.shade900,
                    child: new Text(
                      "Facebook Sign In",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0
                      ),
                    ),
                  ),
                ),
                //Twitter
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  constraints: new BoxConstraints.loose(new Size.fromHeight(50.0)),
                  child: new MaterialButton(
                    height: 50.0,
                    onPressed: ()=>print("Sign In With Twitter"),
                    color: Colors.blue,
                    child: new Text(
                      "Twitter Sign In",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0
                      ),
                    ),
                  ),
                ),*/
                //Copyright
                new Container(
                  margin: const EdgeInsets.all(15.0),
                  child: new Center(
                    child: new Text("©Cryvis 2018"),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
}

class SignUpPage extends StatefulWidget{
  @override
  SignUpPageState createState() {
    return new SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  bool hidepassword = true;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController rePasswordController;
  final formkey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String error = "";
  void onPasswordVisibilityChanged(){
    setState(() {
          hidepassword = !hidepassword;
        });
  }
  @override
  void initState() {
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    rePasswordController = new TextEditingController();
    // TODO: implement initState
    super.initState();
  }
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          centerTitle: true,
          elevation: 0.5,
          title: new  Text("Sign Up"),
          actions: <Widget>[
            new FlatButton(onPressed:()=>Navigator.pushReplacement(context, new PageRouteBuilder(
        pageBuilder: (_,__,___)=>new LoginPage(),
              transitionsBuilder: (context,animation,secondaryAnimation,child)=>
                  new FadeTransition(opacity:animation,child: child,),
         )), child: new Text("Sign In",
              style:new TextStyle(color: Colors.blue),
            ),highlightColor: Colors.transparent,splashColor: Colors.transparent,),
          ],
        ),
        body: new Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 8.0),
          child: new Form(
            key: formkey,
            child: new Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                //Email
                new Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2.0
                      )
                    ],
                  ),
                  child: new TextFormField(
                    controller: emailController,
                    autocorrect: false,
                    validator: (val)=>emailController.text.contains("@")?null:"Invalid Email",
                    decoration:new InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      border: InputBorder.none,
                      prefixIcon: new Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: new Icon(Icons.email,size:30.0,color: Colors.black26,),
                      ),
                      hintText: "Email"
                    ),
                  ),
                ),
                // password
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2.0
                      )
                    ],
                  ),
                  child: new TextFormField(
                    controller: passwordController,
                    validator: (val)=> passwordController.text.length> 6?passwordController.text == ""?"Password cannot be empty":null:"Password should be atleast 6 character long",
                    obscureText: hidepassword,
                    decoration:new InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      border: InputBorder.none,
                      suffixIcon: new GestureDetector(
                        onTap: ()=> onPasswordVisibilityChanged(),
                        child: new Icon(hidepassword?Icons.visibility:Icons.visibility_off,color: Colors.black26,),
                      ),
                      prefixIcon: new Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: new Icon(Icons.lock,size:30.0,color: Colors.black26,),
                      ),
                      hintText: "Password"
                    ),
                  ),
                ),
                //re type password
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2.0
                      )
                    ],
                  ),
                  child: new TextFormField(
                    controller: rePasswordController,
                    validator: (val)=> rePasswordController.text == passwordController.text?null:"Passwords dont match",
                    obscureText: true,
                    decoration:new InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      border: InputBorder.none,
                      prefixIcon: new Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: new Icon(Icons.lock_open,size:30.0,color: Colors.black26,),
                      ),
                      hintText: "Re-type Password"
                    ),
                  ),
                ),
                new Center(
                  child:error == ""?
                  new Container():
                  new Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.error,color: Colors.red,),
                        new Text(error),
                      ],
                    ),)
                  ,
                ),
                // Sign Up button
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  constraints: new BoxConstraints.loose(new Size.fromHeight(50.0)),
                  child: new MaterialButton(
                    height: 50.0,
                    onPressed: (){
                      if(formkey.currentState.validate()){
                        scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(
                          "Loggin In"
                        )));
                        AuthenticationSystem.instance.signUpWithEmail(emailController.text, passwordController.text).then((u){
                          if(u?.uid != null){
                          Navigator.pushReplacement(context, new PageRouteBuilder(
                              pageBuilder: (_,__,___)=> new MainPage(title: "Show Talks",),
                            transitionsBuilder:
                                (context,animation,sAnimation,child)
                            =>new FadeTransition(opacity: animation,child: child,)
                          ));
                          }
                          setState((){
                            error = "";
                          });
                        }).catchError((e){
                          setState(() {
                            error = e.toString().substring(10,e.toString().length);
                          });
                        });
                      }
                    },
                    color: Colors.blue,
                    child: new Text(
                      "Sign Up",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 30.0
                      ),
                    ),
                  ),
                ),
                //Or Text
                new Container(
                  margin: const EdgeInsets.all(10.0),
                  child: new Center(
                    child: new Text("OR"),
                  ),
                ),
                //Google
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  constraints: new BoxConstraints.loose(new Size.fromHeight(50.0)),
                  child: new MaterialButton(
                    height: 50.0,
                    onPressed: (){
                      AuthenticationSystem.instance.signInWithGoogle();
                    },
                    color: Colors.red.shade700,
                    child: new Text(
                      "Google Sign Up",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0
                      ),
                    ),
                  ),
                ),
               /* //Facebook
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  constraints: new BoxConstraints.loose(new Size.fromHeight(50.0)),
                  child: new MaterialButton(
                    height: 50.0,
                    onPressed: ()=>print("Sign Up With Facebook"),
                    color: Colors.blue.shade900,
                    child: new Text(
                      "Facebook Sign Up",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0
                      ),
                    ),
                  ),
                ),
                //Twitter
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  constraints: new BoxConstraints.loose(new Size.fromHeight(50.0)),
                  child: new MaterialButton(
                    height: 50.0,
                    onPressed: ()=>print("Sign Up With Twitter"),
                    color: Colors.blue,
                    child: new Text(
                      "Twitter Sign Up",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0
                      ),
                    ),
                  ),
                ),*/
                //Copyright
                new Container(
                   margin: const EdgeInsets.all(15.0),
                  child: new Center(
                    child: new Text("©Cryvis 2018",textAlign: TextAlign.center,),
                  ),
                ),
                new Center(
                  child: new Text("When you Sign Up you agree to our Terms and Privacy Policy",textAlign: TextAlign.center,),
                ),
                new GestureDetector(
                  child: new Center(
                    child: new Text("Read Our Terms and Privacy Policy",
                    style: new TextStyle(
                      color: Colors.blue,
                    ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
}