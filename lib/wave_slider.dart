import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveSlider extends StatefulWidget {
  final Widget? barWidget;

  final Widget? labelWidget;

  final double height;

  final double width;

  /// Background color of this widget
  final Color backgroundColor;

  /// Sliding liquid bar color of this widget
  final Color liquidColor;

  /// value is a percentage
  final double initialValue;

  /// height of the wave widget
  final double waveHeight;

  /// borderRadius of the widget
  final double borderRadius;

  /// If non-null, this callback
  /// is called as the button slides around with the
  /// current position of the panel. The position is a double
  /// between value and 1.0
  final void Function(double position)? onChange;

  const WaveSlider({
    Key? key,
    this.labelWidget,
    this.barWidget,
    this.height = 200,
    this.width = 50,
    this.waveHeight = 20,
    this.borderRadius = 10,
    this.initialValue = 1,
    this.onChange,
    required this.backgroundColor,
    required this.liquidColor,
  }) : super(key: key);

  @override
  WaveSliderState createState() => WaveSliderState();
}

class WaveSliderState extends State<WaveSlider> with TickerProviderStateMixin {
  AnimationController? _slideAC;
  late AnimationController _liquidAC;
  late AnimationController _heightLiquidAC;
  // variables to make the wave stop and move
  int animationDurationMilliseconds = 5000;
  double waveSpeed = .25;
  double waveHeight = 20;
  Animation<double>? heightAnimation;

  @override
  void initState() {
    super.initState();

    _slideAC = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        if (widget.onChange != null) widget.onChange!(_slideAC!.value);
      });

    _slideAC!.value = widget.initialValue;

    _liquidAC = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationDurationMilliseconds),
    );

    _liquidAC.repeat();

    _heightLiquidAC = AnimationController(
      vsync: this,
      reverseDuration: const Duration(milliseconds: 3500),
      duration: const Duration(milliseconds: 100),
    );
    heightAnimation = Tween<double>(begin: 0, end: waveHeight).animate(
      CurvedAnimation(parent: _heightLiquidAC, curve: Curves.ease),
    );
    _heightLiquidAC.stop();
  }

  @override
  void dispose() {
    _slideAC!.dispose();
    _liquidAC.dispose();
    _heightLiquidAC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _tap,
      onVerticalDragUpdate: _onDrag,
      onVerticalDragEnd: _onDragEnd,
      child: ClipRRect(
        clipper: _CustomRect(
          waveHeight: widget.waveHeight,
          radius: widget.borderRadius,
        ),
        clipBehavior: Clip.hardEdge,
        child: Container(
          color: widget.backgroundColor,
          width: widget.width,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  widthFactor: 1.0,
                  heightFactor: _slideAC!.value,
                  child: AnimatedBuilder(
                    animation: CurvedAnimation(
                      parent: _liquidAC,
                      curve: Curves.easeInOut,
                    ),
                    builder: (context, child) => Stack(
                      children: [
                        Positioned(
                          top: heightAnimation != null
                              ? waveHeight - heightAnimation!.value + 1
                              : 0,
                          width: widget.width,
                          child: ClipPath(
                            clipper: _WaveClipper(
                              animationValue: _liquidAC.value * -1,
                              waveSpeed: waveSpeed,
                            ),
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              height: heightAnimation != null
                                  ? heightAnimation!.value
                                  : 20,
                              margin: const EdgeInsets.all(0),
                              color: widget.liquidColor,
                            ),
                          ),
                        ),
                        Positioned(
                          top: heightAnimation != null
                              ? waveHeight - heightAnimation!.value + 1
                              : 0,
                          width: widget.width,
                          child: ClipPath(
                            clipper: _WaveClipper(
                              animationValue: _liquidAC.value,
                              waveSpeed: waveSpeed,
                            ),
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              height: heightAnimation != null
                                  ? heightAnimation!.value
                                  : 20,
                              margin: const EdgeInsets.all(0),
                              color: widget.liquidColor.withOpacity(.3),
                            ),
                          ),
                        ),
                        Positioned(
                          top: waveHeight,
                          width: widget.width,
                          child: Container(
                            width: widget.width,
                            padding: const EdgeInsets.all(0),
                            margin: const EdgeInsets.all(0),
                            color: widget.liquidColor,
                            height: MediaQuery.of(context).size.height,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _tap(TapDownDetails details) {
    _slideAC!.value = (1 -
            ((details.localPosition.dy) / (widget.height - waveHeight)) +
            (waveHeight / widget.height))
        .clamp(0, 1);

    _playHeightAnimation(reverse: false).then(
      (value) => _playHeightAnimation(reverse: true),
    );
    if (_slideAC!.isAnimating || _liquidAC.isAnimating) return;
  }

  Future<void> _onDrag(DragUpdateDetails details) async {
    _slideAC!.value = 1 -
        ((details.localPosition.dy) / (widget.height - waveHeight)) +
        (waveHeight / widget.height);

    await turnOnAnimation();
  }

  Future<void> _onDragEnd(DragEndDetails details) async {
    await _playHeightAnimation(reverse: true);
    if (_slideAC!.isAnimating || _liquidAC.isAnimating) return;
  }

  Future<void> turnOnAnimation() async {
    if (!_heightLiquidAC.isAnimating) {
      await _playHeightAnimation();
    }
  }

  Future<void> _playHeightAnimation({bool reverse = false}) async {
    try {
      if (reverse == false) {
        await _heightLiquidAC.forward().orCancel;
      } else {
        {
          await _heightLiquidAC.reverse().orCancel;
        }
      }
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }
}

class _CustomRect extends CustomClipper<RRect> {
  const _CustomRect({required this.waveHeight, required this.radius});
  final double waveHeight;
  final double radius;
  @override
  bool shouldReclip(_CustomRect oldClipper) {
    return false;
  }

  @override
  RRect getClip(Size size) {
    final RRect rect = RRect.fromLTRBR(
      0.0,
      waveHeight,
      size.width,
      size.height,
      Radius.circular(radius),
    );
    return rect;
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double animationValue;
  final double waveSpeed;

  _WaveClipper({
    required this.animationValue,
    required this.waveSpeed,
  });

  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..addPolygon(_generateVerticalWavePath(size), false)
      ..lineTo(size.width * 10, size.height)
      ..lineTo(0.0, size.height)
      ..close();
    return path;
  }

  List<Offset> _generateVerticalWavePath(Size size) {
    final amplitude = size.height / 4;
    final waveList = <Offset>[];
    final waveHeight = size.height / 2;
    for (int i = -2; i <= (size.width).toInt() + 2; i++) {
      final wavyness = waveSpeed > 0 ? math.pi / (180 * waveSpeed) : 0;
      final dy =
          amplitude * math.sin((animationValue * 360 - i) % 360 * wavyness);
      waveList.add(Offset(i.toDouble(), dy));
    }
    final minDy =
        waveList.map((offset) => offset.dy).reduce((a, b) => a < b ? a : b);
    final flattenedWaveList = waveList
        .map(
          (offset) =>
              Offset(offset.dx, offset.dy - minDy - amplitude + waveHeight),
        )
        .toList();
    return flattenedWaveList;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) =>
      animationValue != oldClipper.animationValue;
}
