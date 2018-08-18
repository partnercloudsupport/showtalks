import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
typedef void _ImageProviderResolverListener();

class _ImageProviderResolver {
  _ImageProviderResolver({
    @required this.state,
    @required this.listener,
  });

  final ParallaxImageState state;
  final _ImageProviderResolverListener listener;

  ParallaxImage get widget => state.widget;

  ImageStream _imageStream;
  ImageInfo _imageInfo;

  void resolve(ImageProvider provider) {
    final ImageStream oldImageStream = _imageStream;
    _imageStream = provider.resolve(createLocalImageConfiguration(
      state.context,
    ));
    assert(_imageStream != null);

    if (_imageStream.key != oldImageStream?.key) {
      oldImageStream?.removeListener(_handleImageChanged);
      _imageStream.addListener(_handleImageChanged);
    }
  }

  void _handleImageChanged(ImageInfo imageInfo, bool synchronousCall) {
    _imageInfo = imageInfo;
    listener();
  }

  void stopListening() {
    _imageStream?.removeListener(_handleImageChanged);
  }
}

class ParallaxImage extends StatefulWidget {
  ParallaxImage({
    Key key,
    @required this.image,
    this.placeHolder,
    @required this.extent,
    this.controller,
    this.color,
    this.child,
    this.fit,
  }) : super(key: key);

  final ImageProvider image;
  final ImageProvider placeHolder;
  final ScrollController controller;
  final double extent;
  final Color color;
  final Widget child;
  final BoxFit fit;
  @override
  ParallaxImageState createState() => new ParallaxImageState();
}

class ParallaxImageState extends State<ParallaxImage> {
  _ImageProviderResolver _imageResolver;
  ImageProvider image;
  @override
  void initState() {
    image = widget.placeHolder;
    _imageResolver = new _ImageProviderResolver(
        state: this,
        listener: () {
          setState(() {
            if (_imageResolver._imageInfo != null) {
              image = widget.image;
            } else {
              image = widget.placeHolder;
            }
          });
        });
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _imageResolver.resolve(widget.image);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(ParallaxImage oldWidget) {
    // TODO: implement didUpdateWidget
    _imageResolver.resolve(widget.image);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    _imageResolver.resolve(widget.image);
    // TODO: implement reassemble
    super.reassemble();
  }

  @override
  void dispose() {
    _imageResolver.stopListening();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scrollPosition = (widget.controller != null)
        ? widget.controller.position
        : Scrollable.of(context).position;
    final constraints = (scrollPosition.axis == Axis.vertical)
        ? new BoxConstraints(minHeight: widget.extent)
        : new BoxConstraints(minWidth: widget.extent);
    return new RepaintBoundary(
      child: new ConstrainedBox(
        constraints: constraints,
        child: new _Parallax(
          image: image,
          scrollPosition: scrollPosition,
          child: widget.child,
          screenSize: media.size,
          fit: widget.fit,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);

    description.add(new DoubleProperty('extent', widget.extent));
    description
        .add(new DiagnosticsProperty<ImageProvider>('image', widget.image));
    description.add(new DiagnosticsProperty<Color>('color', widget.color));
  }
}

class _Parallax extends SingleChildRenderObjectWidget {
  _Parallax({
    Key key,
    @required this.image,
    @required this.scrollPosition,
    @required this.screenSize,
    this.color,
    Widget child,
    this.fit,
  }) : super(key: key, child: child);
  final ImageProvider image;
  final ScrollPosition scrollPosition;
  final Size screenSize;
  final Color color;
  final BoxFit fit;
  @override
  _RenderParallax createRenderObject(BuildContext context) {
    return new _RenderParallax(
      scrollPosition: scrollPosition,
      image: image,
      screenSize: screenSize,
      color: color,
      fit: fit,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderParallax renderObject) {
    renderObject
      ..image = image
      ..scrollPosition = scrollPosition
      ..screenSize = screenSize
      ..color = color;
  }
}

class _RenderParallax extends RenderProxyBox {
  _RenderParallax({
    @required ScrollPosition scrollPosition,
    @required ImageProvider image,
    @required Size screenSize,
    Color color,
    ImageConfiguration configuration: ImageConfiguration.empty,
    RenderBox child,
    BoxFit fit,
  })  : _image = image,
        _scrollPosition = scrollPosition,
        _screenSize = screenSize,
        _color = color,
        _configuration = configuration,
        _fit = fit,
        super(child);

  ImageProvider _image;
  ScrollPosition _scrollPosition;
  Size _screenSize;
  Color _color;
  ImageConfiguration _configuration;
  Offset _position;
  BoxPainter _painter;
  BoxFit _fit;
  set image(ImageProvider value) {
    if (value == _image) return;
    _image = value;
    _painter?.dispose();
    _painter = null;
    _decoration = null;
    markNeedsPaint();
  }

  set scrollPosition(ScrollPosition value) {
    if (value == _scrollPosition) return;
    if (attached) _scrollPosition.removeListener(markNeedsPaint);
    _scrollPosition = value;
    if (attached) _scrollPosition.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  set screenSize(Size value) {
    if (value == _screenSize) return;
    _screenSize = value;
    markNeedsPaint();
  }

  set color(Color value) {
    if (value == _color) return;
    _color = value;
    _painter?.dispose();
    _painter = null;
    _decoration = null;
    markNeedsPaint();
  }

  ImageConfiguration get configuration => _configuration;

  Decoration get decoration {
    if (_decoration != null) return _decoration;
    Alignment alignment;
    if (_scrollPosition.axis == Axis.vertical) {
      double value = (_position.dy / _screenSize.height - 0.5).clamp(-1.0, 1.0);
      alignment = new Alignment(0.0, value);
    } else {
      double value = (_position.dx / _screenSize.width - 0.5).clamp(-1.0, 1.0);
      alignment = new Alignment(value, 0.0);
    }

    _decoration = new BoxDecoration(
      color: _color,
      image: new DecorationImage(
        alignment: alignment,
        image: _image,
        fit: _fit,
      ),
    );
    return _decoration;
  }

  Decoration _decoration;
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scrollPosition.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _painter?.dispose();
    _painter = null;
    _scrollPosition.removeListener(markNeedsPaint);
    super.detach();
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(size.width != null);
    assert(size.height != null);
    // We use center of the widget's render box as a reference point.
    var pos = localToGlobal(new Offset(size.width / 2, size.height / 2));
    if (_position != pos) {
      _painter?.dispose();
      _painter = null;
      _decoration = null;
      _position = pos;
    }
    _painter ??= decoration.createBoxPainter(markNeedsPaint);
    final ImageConfiguration filledConfiguration =
        configuration.copyWith(size: size);
    int debugSaveCount;
    assert(() {
      debugSaveCount = context.canvas.getSaveCount();
      return true;
    }());
    _painter.paint(context.canvas, offset, filledConfiguration);
    assert(() {
      if (debugSaveCount != context.canvas.getSaveCount()) {
        throw new FlutterError(
            '${decoration.runtimeType} painter had mismatching save and restore calls.\n'
            'Before painting the decoration, the canvas save count was $debugSaveCount. '
            'After painting it, the canvas save count was ${context.canvas.getSaveCount()}. '
            'Every call to save() or saveLayer() must be matched by a call to restore().\n'
            'The decoration was:\n'
            '  $decoration\n'
            'The painter was:\n'
            '  $_painter');
      }
      return true;
    }());
    if (decoration.isComplex) context.setIsComplexHint();
    super.paint(context, offset);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);

    description.add(new DiagnosticsProperty<ScrollPosition>(
        'scrollPosition', _scrollPosition));
    description.add(new DiagnosticsProperty<Size>('screenSize', _screenSize));
    description.add(_decoration.toDiagnosticsNode(name: 'decoration'));
    description.add(new DiagnosticsProperty<ImageConfiguration>(
        'configuration', configuration));
  }
}
