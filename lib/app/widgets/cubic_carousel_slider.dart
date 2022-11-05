import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const _kMaxValue = 200000000000;
const _kMiddleValue = 100000;

typedef CarouselSlideBuilder = Widget Function(int index);

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({
    Key? key,
    required List<Widget> this.children,
    this.slideTransform = const CubeTransform(),
    this.slideIndicator,
    this.viewportFraction = 1,
    this.enableAutoSlider = false,
    this.autoSliderDelay = const Duration(seconds: 5),
    this.autoSliderTransitionTime = const Duration(seconds: 2),
    this.autoSliderTransitionCurve = Curves.easeOutQuad,
    this.keepPage = true,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.scrollDirection = Axis.horizontal,
    this.unlimitedMode = false,
    this.initialPage = 0,
    this.onSlideChanged,
    this.controller,
    this.clipBehavior = Clip.hardEdge,
  })  : slideBuilder = null,
        itemCount = children.length,
        super(key: key);

  const CarouselSlider.builder({
    Key? key,
    required this.slideBuilder,
    this.slideTransform = const CubeTransform(),
    this.slideIndicator,
    required this.itemCount,
    this.viewportFraction = 1,
    this.enableAutoSlider = false,
    this.autoSliderDelay = const Duration(seconds: 5),
    this.autoSliderTransitionTime = const Duration(seconds: 2),
    this.autoSliderTransitionCurve = Curves.easeOutQuad,
    this.keepPage = true,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.scrollDirection = Axis.horizontal,
    this.unlimitedMode = false,
    this.initialPage = 0,
    this.onSlideChanged,
    this.controller,
    this.clipBehavior = Clip.hardEdge,
  })  : children = null,
        super(key: key);

  final CarouselSlideBuilder? slideBuilder;
  final List<Widget>? children;
  final int itemCount;
  final SlideTransform slideTransform;
  final SlideIndicator? slideIndicator;
  final double viewportFraction;
  final bool enableAutoSlider;

  /// Waiting time before starting the auto slider
  final Duration autoSliderDelay;

  final Duration autoSliderTransitionTime;
  final Curve autoSliderTransitionCurve;
  final bool unlimitedMode;
  final bool keepPage;
  final ScrollPhysics scrollPhysics;
  final Axis scrollDirection;
  final int initialPage;
  final ValueChanged<int>? onSlideChanged;
  final Clip clipBehavior;
  final CarouselSliderController? controller;

  @override
  State<StatefulWidget> createState() => _CarouselSliderState();
}

class CarouselSliderController {
  _CarouselSliderState? _state;

  nextPage([Duration? transitionDuration]) {
    if (_state != null && _state!.mounted) {
      _state!._nextPage(transitionDuration);
    }
  }

  previousPage([Duration? transitionDuration]) {
    if (_state != null && _state!.mounted) {
      _state!._previousPage(transitionDuration);
    }
  }

  setAutoSliderEnabled(bool isEnabled) {
    if (_state != null && _state!.mounted) {
      _state!._setAutoSliderEnabled(isEnabled);
    }
  }
}

class _CarouselSliderState extends State<CarouselSlider> {
  PageController? _pageController;
  Timer? _timer;
  int? _currentPage;
  double _pageDelta = 0;
  late bool _isPlaying;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.itemCount > 0)
          PageView.builder(
            onPageChanged: (val) {
              widget.onSlideChanged?.call(val);
            },
            clipBehavior: widget.clipBehavior,
            scrollBehavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              overscroll: false,
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            ),
            itemCount: widget.unlimitedMode ? _kMaxValue : widget.itemCount,
            controller: _pageController,
            scrollDirection: widget.scrollDirection,
            physics: widget.scrollPhysics,
            itemBuilder: (context, index) {
              final slideIndex = index % widget.itemCount;
              Widget slide = widget.children == null ? widget.slideBuilder!(slideIndex) : widget.children![slideIndex];
              return widget.slideTransform.transform(context, slide, index, _currentPage, _pageDelta, widget.itemCount);
            },
          ),
        if (widget.slideIndicator != null && widget.itemCount > 0)
          widget.slideIndicator!.build(_currentPage! % widget.itemCount, _pageDelta, widget.itemCount),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant CarouselSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enableAutoSlider != widget.enableAutoSlider) {
      _setAutoSliderEnabled(widget.enableAutoSlider);
    }
    if (oldWidget.itemCount != widget.itemCount) {
      _initPageController();
    }
    _initCarouselSliderController();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _pageController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.enableAutoSlider;
    _currentPage = widget.initialPage;
    _initCarouselSliderController();
    _initPageController();
    _setAutoSliderEnabled(_isPlaying);
  }

  void _initCarouselSliderController() {
    if (widget.controller != null) {
      widget.controller!._state = this;
    }
  }

  void _initPageController() {
    _pageController?.dispose();
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      keepPage: widget.keepPage,
      initialPage: widget.unlimitedMode ? _kMiddleValue * widget.itemCount + _currentPage! : _currentPage!,
    );
    _pageController!.addListener(() {
      setState(() {
        _currentPage = _pageController!.page!.floor();
        _pageDelta = _pageController!.page! - _pageController!.page!.floor();
      });
    });
  }

  void _nextPage(Duration? transitionDuration) {
    _pageController!.nextPage(
      duration: transitionDuration ?? widget.autoSliderTransitionTime,
      curve: widget.autoSliderTransitionCurve,
    );
  }

  void _previousPage(Duration? transitionDuration) {
    _pageController!.previousPage(
      duration: transitionDuration ?? widget.autoSliderTransitionTime,
      curve: widget.autoSliderTransitionCurve,
    );
  }

  void _setAutoSliderEnabled(bool isEnabled) {
    if (_timer != null) {
      _timer!.cancel();
    }
    if (isEnabled) {
      _timer = Timer.periodic(widget.autoSliderDelay, (timer) {
        _pageController!.nextPage(
          duration: widget.autoSliderTransitionTime,
          curve: widget.autoSliderTransitionCurve,
        );
      });
    }
  }
}

class CircularSlideIndicator implements SlideIndicator {
  final double itemSpacing;
  final double indicatorRadius;
  final double indicatorBorderWidth;
  final Color? indicatorBorderColor;
  final EdgeInsets? padding;
  final AlignmentGeometry alignment;
  final Color currentIndicatorColor;
  final Color indicatorBackgroundColor;

  CircularSlideIndicator({
    this.itemSpacing = 20,
    this.indicatorRadius = 6,
    this.indicatorBorderWidth = 1,
    this.indicatorBorderColor,
    this.padding,
    this.alignment = Alignment.bottomCenter,
    this.currentIndicatorColor = const Color(0xFF000000),
    this.indicatorBackgroundColor = const Color(0x64000000),
  });

  @override
  Widget build(int currentPage, double pageDelta, int itemCount) {
    return Container(
      alignment: alignment,
      padding: padding,
      child: SizedBox(
        width: itemCount * itemSpacing,
        height: indicatorRadius * 2,
        child: CustomPaint(
          painter: CircularIndicatorPainter(
            currentIndicatorColor: currentIndicatorColor,
            indicatorBackgroundColor: indicatorBackgroundColor,
            currentPage: currentPage,
            pageDelta: pageDelta,
            itemCount: itemCount,
            radius: indicatorRadius,
            indicatorBorderColor: indicatorBorderColor,
            borderWidth: indicatorBorderWidth,
          ),
        ),
      ),
    );
  }
}

class CircularIndicatorPainter extends CustomPainter {
  final int itemCount;
  final double radius;
  final Paint indicatorPaint = Paint();
  final Paint currentIndicatorPaint = Paint();
  final int currentPage;
  final double pageDelta;
  final Paint borderIndicatorPaint = Paint();
  final Color? indicatorBorderColor;

  CircularIndicatorPainter({
    required this.currentPage,
    required this.pageDelta,
    required this.itemCount,
    this.radius = 12,
    double borderWidth = 2,
    required Color currentIndicatorColor,
    required Color indicatorBackgroundColor,
    this.indicatorBorderColor,
  }) {
    indicatorPaint.color = indicatorBackgroundColor;
    indicatorPaint.style = PaintingStyle.fill;
    indicatorPaint.isAntiAlias = true;
    currentIndicatorPaint.color = currentIndicatorColor;
    currentIndicatorPaint.style = PaintingStyle.fill;
    currentIndicatorPaint.isAntiAlias = true;

    if (indicatorBorderColor != null) {
      borderIndicatorPaint.color = indicatorBorderColor!;
      borderIndicatorPaint.style = PaintingStyle.stroke;
      borderIndicatorPaint.strokeWidth = borderWidth;
      borderIndicatorPaint.isAntiAlias = true;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dx = itemCount < 2 ? size.width : (size.width - 2 * radius) / (itemCount - 1);
    final y = size.height / 2;
    double x = radius;

    for (int i = 0; i < itemCount; i++) {
      canvas.drawCircle(Offset(x, y), radius, indicatorPaint);
      x += dx;
    }

    canvas.save();
    double midX = radius + dx * currentPage;
    double midY = size.height / 2;
    final path = Path();
    path.addOval(Rect.fromLTRB(midX - radius, midY - radius, midX + radius, midY + radius));
    if (currentPage == itemCount - 1) {
      path.addOval(Rect.fromLTRB(0, midY - radius, 2 * radius, midY + radius));
      canvas.clipPath(path);
      canvas.drawCircle(Offset(2 * radius * pageDelta - radius, midY), radius, currentIndicatorPaint);
      midX += 2 * radius * pageDelta;
    } else {
      midX += dx;
      path.addOval(Rect.fromLTRB(midX - radius, midY - radius, midX + radius, midY + radius));
      midX -= dx;
      canvas.clipPath(path);
      midX += dx * pageDelta;
    }
    canvas.drawCircle(Offset(midX, midY), radius, currentIndicatorPaint);
    canvas.restore();

    if (indicatorBorderColor != null) {
      x = radius;
      for (int i = 0; i < itemCount; i++) {
        canvas.drawCircle(Offset(x, y), radius, borderIndicatorPaint);
        x += dx;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircularWaveSlideIndicator implements SlideIndicator {
  final double itemSpacing;
  final double indicatorRadius;
  final EdgeInsets? padding;
  final AlignmentGeometry alignment;
  final Color currentIndicatorColor;
  final Color indicatorBackgroundColor;
  final double indicatorBorderWidth;
  final Color? indicatorBorderColor;

  CircularWaveSlideIndicator({
    this.itemSpacing = 20,
    this.indicatorRadius = 6,
    this.padding,
    this.alignment = Alignment.bottomCenter,
    this.currentIndicatorColor = const Color(0xFF000000),
    this.indicatorBackgroundColor = const Color(0x64000000),
    this.indicatorBorderWidth = 1,
    this.indicatorBorderColor,
  });

  @override
  Widget build(int currentPage, double pageDelta, int itemCount) {
    return Container(
      alignment: alignment,
      padding: padding,
      child: SizedBox(
        width: itemCount * itemSpacing,
        height: indicatorRadius * 2,
        child: CustomPaint(
          painter: CircularWaveIndicatorPainter(
            currentIndicatorColor: currentIndicatorColor,
            indicatorBackgroundColor: indicatorBackgroundColor,
            currentPage: currentPage,
            pageDelta: pageDelta,
            itemCount: itemCount,
            radius: indicatorRadius,
            indicatorBorderColor: indicatorBorderColor,
            borderWidth: indicatorBorderWidth,
          ),
        ),
      ),
    );
  }
}

class CircularWaveIndicatorPainter extends CustomPainter {
  final int? itemCount;
  final int? currentPage;
  final double? pageDelta;
  final double? radius;
  final Paint indicatorPaint = Paint();
  final Paint currentIndicatorPaint = Paint();

  final Paint borderIndicatorPaint = Paint();
  final Color? indicatorBorderColor;

  CircularWaveIndicatorPainter({
    this.itemCount,
    this.currentPage,
    this.pageDelta,
    this.radius,
    required Color currentIndicatorColor,
    required Color indicatorBackgroundColor,
    this.indicatorBorderColor,
    double borderWidth = 2,
  }) {
    indicatorPaint.color = indicatorBackgroundColor;
    indicatorPaint.style = PaintingStyle.fill;
    indicatorPaint.isAntiAlias = true;
    currentIndicatorPaint.color = currentIndicatorColor;
    currentIndicatorPaint.style = PaintingStyle.fill;
    currentIndicatorPaint.isAntiAlias = true;

    if (indicatorBorderColor != null) {
      borderIndicatorPaint.color = indicatorBorderColor!;
      borderIndicatorPaint.style = PaintingStyle.stroke;
      borderIndicatorPaint.strokeWidth = borderWidth;
      borderIndicatorPaint.isAntiAlias = true;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dx = itemCount! < 2 ? size.width : (size.width - 2 * radius!) / (itemCount! - 1);
    final y = size.height / 2;
    double? x = radius;
    for (int i = 0; i < itemCount!; i++) {
      canvas.drawCircle(Offset(x!, y), radius!, indicatorPaint);
      x += dx;
    }
    double midX = radius! + dx * currentPage!;
    double midY = size.height / 2;
    double r = radius! * ((1.4 * pageDelta! - 0.7).abs() + 0.3);
    if (currentPage == itemCount! - 1) {
      canvas.save();
      final path = Path();
      path.addOval(Rect.fromLTRB(0, midY - radius!, 2 * radius!, midY + radius!));
      path.addOval(Rect.fromLTRB(size.width - 2 * radius!, midY - radius!, size.width, midY + radius!));
      canvas.clipPath(path);
      canvas.drawCircle(Offset(2 * radius! * pageDelta! - radius!, midY), r, currentIndicatorPaint);
      midX += 2 * radius! * pageDelta!;
    } else {
      midX += dx * pageDelta!;
    }
    canvas.drawCircle(Offset(midX, midY), r, currentIndicatorPaint);
    if (currentPage == itemCount! - 1) {
      canvas.restore();
    }
    if (indicatorBorderColor != null) {
      x = radius;
      for (int i = 0; i < itemCount!; i++) {
        canvas.drawCircle(Offset(x!, y), radius!, borderIndicatorPaint);
        x += dx;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircularStaticIndicator extends SlideIndicator {
  final double itemSpacing;
  final double indicatorRadius;
  final EdgeInsets? padding;
  final AlignmentGeometry alignment;
  final Color currentIndicatorColor;
  final Color indicatorBackgroundColor;
  final bool enableAnimation;
  final double indicatorBorderWidth;
  final Color? indicatorBorderColor;

  CircularStaticIndicator({
    this.itemSpacing = 20,
    this.indicatorRadius = 6,
    this.padding,
    this.alignment = Alignment.bottomCenter,
    this.currentIndicatorColor = const Color(0xFF000000),
    this.indicatorBackgroundColor = const Color(0x64000000),
    this.enableAnimation = false,
    this.indicatorBorderWidth = 1,
    this.indicatorBorderColor,
  });

  @override
  Widget build(int currentPage, double pageDelta, int itemCount) {
    return Container(
      alignment: alignment,
      padding: padding,
      child: SizedBox(
        width: itemCount * itemSpacing,
        height: indicatorRadius * 2,
        child: CustomPaint(
          painter: CircularStaticIndicatorPainter(
            currentIndicatorColor: currentIndicatorColor,
            indicatorBackgroundColor: indicatorBackgroundColor,
            currentPage: currentPage,
            pageDelta: pageDelta,
            itemCount: itemCount,
            radius: indicatorRadius,
            enableAnimation: enableAnimation,
            indicatorBorderColor: indicatorBorderColor,
            borderWidth: indicatorBorderWidth,
          ),
        ),
      ),
    );
  }
}

class CircularStaticIndicatorPainter extends CustomPainter {
  final int itemCount;
  final double radius;
  final Paint indicatorPaint = Paint();
  final Paint currentIndicatorPaint = Paint();
  final int currentPage;
  final double pageDelta;
  final bool enableAnimation;

  final Paint borderIndicatorPaint = Paint();
  final Color? indicatorBorderColor;

  CircularStaticIndicatorPainter({
    required this.currentPage,
    required this.pageDelta,
    required this.itemCount,
    this.radius = 12,
    required Color currentIndicatorColor,
    required Color indicatorBackgroundColor,
    this.enableAnimation = false,
    this.indicatorBorderColor,
    double borderWidth = 2,
  }) {
    indicatorPaint.color = indicatorBackgroundColor;
    indicatorPaint.style = PaintingStyle.fill;
    indicatorPaint.isAntiAlias = true;
    currentIndicatorPaint.color = currentIndicatorColor;
    currentIndicatorPaint.style = PaintingStyle.fill;
    currentIndicatorPaint.isAntiAlias = true;

    if (indicatorBorderColor != null) {
      borderIndicatorPaint.color = indicatorBorderColor!;
      borderIndicatorPaint.style = PaintingStyle.stroke;
      borderIndicatorPaint.strokeWidth = borderWidth;
      borderIndicatorPaint.isAntiAlias = true;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dx = itemCount < 2 ? size.width : (size.width - 2 * radius) / (itemCount - 1);
    final y = size.height / 2;
    double x = radius;
    for (int i = 0; i < itemCount; i++) {
      canvas.drawCircle(Offset(x, y), radius, indicatorPaint);
      if (i == currentPage) {
        canvas.drawCircle(Offset(x, y), enableAnimation ? radius - radius * pageDelta : radius, currentIndicatorPaint);
      }
      if (enableAnimation && (i == currentPage + 1 || currentPage == itemCount - 1 && i == 0)) {
        canvas.drawCircle(Offset(x, y), enableAnimation ? radius * pageDelta : radius, currentIndicatorPaint);
      }
      x += dx;
    }
    if (indicatorBorderColor != null) {
      x = radius;
      for (int i = 0; i < itemCount; i++) {
        canvas.drawCircle(Offset(x, y), radius, borderIndicatorPaint);
        x += dx;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SequentialFillIndicator extends SlideIndicator {
  final double itemSpacing;
  final double indicatorRadius;
  final EdgeInsets? padding;
  final AlignmentGeometry alignment;
  final Color currentIndicatorColor;
  final Color indicatorBackgroundColor;
  final bool enableAnimation;
  final double indicatorBorderWidth;
  final Color? indicatorBorderColor;

  SequentialFillIndicator({
    this.itemSpacing = 20,
    this.indicatorRadius = 6,
    this.padding,
    this.alignment = Alignment.bottomCenter,
    this.currentIndicatorColor = const Color(0xFF000000),
    this.indicatorBackgroundColor = const Color(0x64000000),
    this.enableAnimation = false,
    this.indicatorBorderWidth = 1,
    this.indicatorBorderColor,
  });

  @override
  Widget build(int currentPage, double pageDelta, int itemCount) {
    return Container(
      alignment: alignment,
      padding: padding,
      child: SizedBox(
        width: itemCount * itemSpacing,
        height: indicatorRadius * 2,
        child: CustomPaint(
          painter: SequentialFillIndicatorPainter(
            currentIndicatorColor: currentIndicatorColor,
            indicatorBackgroundColor: indicatorBackgroundColor,
            currentPage: currentPage,
            pageDelta: pageDelta,
            itemCount: itemCount,
            radius: indicatorRadius,
            enableAnimation: enableAnimation,
            indicatorBorderColor: indicatorBorderColor,
            borderWidth: indicatorBorderWidth,
          ),
        ),
      ),
    );
  }
}

class SequentialFillIndicatorPainter extends CustomPainter {
  final int itemCount;
  final double radius;
  final Paint indicatorPaint = Paint();
  final Paint currentIndicatorPaint = Paint();
  final int currentPage;
  final double pageDelta;
  final bool enableAnimation;

  final Paint borderIndicatorPaint = Paint();
  final Color? indicatorBorderColor;

  SequentialFillIndicatorPainter({
    required this.currentPage,
    required this.pageDelta,
    required this.itemCount,
    this.radius = 12,
    required Color currentIndicatorColor,
    required Color indicatorBackgroundColor,
    this.enableAnimation = false,
    this.indicatorBorderColor,
    double borderWidth = 2,
  }) {
    indicatorPaint.color = indicatorBackgroundColor;
    indicatorPaint.style = PaintingStyle.fill;
    indicatorPaint.isAntiAlias = true;
    currentIndicatorPaint.color = currentIndicatorColor;
    currentIndicatorPaint.style = PaintingStyle.fill;
    currentIndicatorPaint.isAntiAlias = true;
    currentIndicatorPaint.strokeCap = StrokeCap.round;
    currentIndicatorPaint.strokeWidth = radius * 2;

    if (indicatorBorderColor != null) {
      borderIndicatorPaint.color = indicatorBorderColor!;
      borderIndicatorPaint.style = PaintingStyle.stroke;
      borderIndicatorPaint.strokeWidth = borderWidth;
      borderIndicatorPaint.isAntiAlias = true;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    int currentPage = this.currentPage;
    if (this.currentPage + pageDelta > itemCount - 1) {
      currentPage = 0;
    }
    final dx = itemCount < 2 ? size.width : (size.width - 2 * radius) / (itemCount - 1);
    final y = size.height / 2;
    double x = radius;
    for (int i = 0; i < itemCount; i++) {
      canvas.drawCircle(Offset(x, y), radius, indicatorPaint);
      x += dx;
    }
    canvas.save();
    x = radius;
    final path = Path();
    for (int i = 0; i < itemCount; i++) {
      path.addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));
      x += dx;
    }
    canvas.clipPath(path);
    x = radius;
    if (this.currentPage + pageDelta > itemCount - 1) {
      canvas.drawLine(
          Offset(-radius, y), Offset(dx * currentPage + radius * 2 * pageDelta - radius, y), currentIndicatorPaint);
    } else {
      canvas.drawLine(Offset(-radius, y), Offset(dx * currentPage + dx * pageDelta + radius, y), currentIndicatorPaint);
    }
    canvas.restore();
    if (indicatorBorderColor != null) {
      x = radius;
      for (int i = 0; i < itemCount; i++) {
        canvas.drawCircle(Offset(x, y), radius, borderIndicatorPaint);
        x += dx;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

abstract class SlideIndicator {
  Widget build(int currentPage, double pageDelta, int itemCount);
}


class CubeTransform implements SlideTransform {
  final double perspectiveScale;
  final AlignmentGeometry rightPageAlignment;
  final AlignmentGeometry leftPageAlignment;
  final double rotationAngle;

  const CubeTransform({
    this.perspectiveScale = 0.0014,
    this.rightPageAlignment = Alignment.centerLeft,
    this.leftPageAlignment = Alignment.centerRight,
    double rotationAngle = 90,
  }) : rotationAngle = math.pi / 180 * rotationAngle;


  @override
  Widget transform(BuildContext context, Widget page, int index, int? currentPage, double pageDelta, int itemCount) {
    if (index == currentPage) {
      return Transform(
        alignment: leftPageAlignment,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateY(rotationAngle * pageDelta),
        child: page,
      );
    } else if (index == currentPage! + 1) {
      return Transform(
        alignment: rightPageAlignment,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateY(-rotationAngle * (1 - pageDelta)),
        child: page,
      );
    } else {
      return page;
    }
  }
}

abstract class SlideTransform {
  Widget transform(BuildContext context, Widget page, int index, int? currentPage, double pageDelta, int itemCount);
}
