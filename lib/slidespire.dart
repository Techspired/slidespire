import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:slidespire/app_scroll_behavior.dart';

class Slidespire extends StatefulWidget {
  const Slidespire({
    required this.slides,
    this.initialPage = 0,
    this.activePageViewportFraction = .8,
    this.slideMargin = const EdgeInsets.all(16),
    this.activeSlideMargin = const EdgeInsets.symmetric(horizontal: 10),
    this.inactiveSlideOpacity = .6,
    this.showDots = false,
    this.dotColor = Colors.black26,
    this.dotActiveColor = Colors.black,
    this.dotSize = 20,
    this.dotPadding = const EdgeInsets.symmetric(vertical: 10),
    this.showNextPreviousButtons = true,
    this.previousIcon = const Icon(Icons.chevron_left_rounded),
    this.nextIcon = const Icon(Icons.chevron_right_rounded),
    this.nextPreviousIconSize = 36,
    this.slideChangedCallback,
    this.previousButtonCallback,
    this.nextButtonCallback,
    this.dotCallback,
    this.height,
    this.width = double.infinity,
    this.pageAnimationDuration = const Duration(milliseconds: 500),
    this.pageAnimationCurve = Curves.easeInOutCubic,
    this.autoSlide = false,
    this.autoSlideDuration = const Duration(seconds: 5),
    Key? key,
  })  : assert(
          activePageViewportFraction <= 1 && activePageViewportFraction > 0,
        ),
        assert(
          inactiveSlideOpacity <= 1 && inactiveSlideOpacity > 0,
        ),
        super(key: key);

  final List<Widget> slides;
  final int initialPage;
  final double activePageViewportFraction;
  final EdgeInsets slideMargin;
  final EdgeInsets activeSlideMargin;
  final bool showDots;
  final double dotSize;
  final EdgeInsets dotPadding;
  final Color dotColor;
  final Color dotActiveColor;
  final double inactiveSlideOpacity;
  final bool showNextPreviousButtons;
  final Widget previousIcon;
  final Widget nextIcon;

  final ValueChanged<int>? previousButtonCallback;
  final ValueChanged<int>? nextButtonCallback;
  final ValueChanged<int>? slideChangedCallback;
  final ValueChanged<int>? dotCallback;

  final double? height;
  final double? width;
  final double nextPreviousIconSize;
  final Duration pageAnimationDuration;
  final Curve pageAnimationCurve;
  final bool autoSlide;
  final Duration autoSlideDuration;
  @override
  State<Slidespire> createState() => _SlidespireState();
}

class _SlidespireState extends State<Slidespire> {
  late PageController _pageController;
  late Timer? _timer;

  late int activePage;

  @override
  void initState() {
    super.initState();

    activePage = widget.initialPage;
    if (activePage == -1) {
      activePage = 0;
    }
    activePage = activePage + (widget.slides.length * 200);
    _pageController = PageController(
      viewportFraction: widget.activePageViewportFraction,
      initialPage: activePage,
    );
    if (widget.autoSlide) {
      _timer = Timer.periodic(widget.autoSlideDuration, (Timer timer) {
        nextPage();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.height ??
          MediaQuery.of(context).size.height - kToolbarHeight * 2,
      width: widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.showNextPreviousButtons) ...[
                  Container(
                    alignment: Alignment.center,
                    child: IconButton(
                      iconSize: 32,
                      onPressed: () {
                        previousPage();
                        if (widget.slideChangedCallback != null) {
                          widget.slideChangedCallback!(
                            activePage % widget.slides.length,
                          );
                        }
                        if (widget.previousButtonCallback != null) {
                          widget.previousButtonCallback!(
                            activePage % widget.slides.length,
                          );
                        }
                      },
                      icon: widget.previousIcon,
                    ),
                  ),
                ],
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: PageView.builder(
                    scrollBehavior: AppScrollBehavior(),
                    pageSnapping: true,
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        activePage = page;
                      });
                    },
                    itemBuilder: (context, pagePosition) {
                      final bool active = pagePosition == activePage;

                      return AnimatedContainer(
                        duration: widget.pageAnimationDuration,
                        curve: widget.pageAnimationCurve,
                        margin: active
                            ? widget.activeSlideMargin
                            : widget.slideMargin,
                        child: Opacity(
                          opacity: activePage == pagePosition
                              ? 1
                              : widget.inactiveSlideOpacity,
                          child: widget
                              .slides[pagePosition % widget.slides.length],
                        ),
                      );
                    },
                  ),
                ),
                if (widget.showNextPreviousButtons) ...[
                  IconButton(
                    iconSize: 32,
                    onPressed: () {
                      nextPage();
                      if (widget.slideChangedCallback != null) {
                        widget.slideChangedCallback!(
                          activePage % widget.slides.length,
                        );
                      }
                      if (widget.nextButtonCallback != null) {
                        widget.nextButtonCallback!(
                          activePage % widget.slides.length,
                        );
                      }
                    },
                    icon: widget.nextIcon,
                  ),
                ],
              ],
            ),
          ),
          if (widget.showDots) ...[
            Container(
              height: widget.dotSize + widget.dotPadding.vertical,
              padding: widget.dotPadding,
              child: Wrap(
                spacing: widget.dotPadding.horizontal,
                children: widget.slides
                    .mapIndexed(
                      (i, e) => GestureDetector(
                        onTap: () {
                          final currentPage = activePage % widget.slides.length;
                          final tappedPage = i % widget.slides.length;
                          if (currentPage != tappedPage) {
                            if (tappedPage > currentPage) {
                              goToPage(activePage + (tappedPage - currentPage));
                            } else if (tappedPage < currentPage) {
                              goToPage(activePage - (currentPage - tappedPage));
                            }
                          }
                          if (widget.slideChangedCallback != null) {
                            widget.slideChangedCallback!(
                              activePage % widget.slides.length,
                            );
                          }
                          if (widget.dotCallback != null) {
                            widget.dotCallback!(
                              activePage % widget.slides.length,
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: widget.pageAnimationDuration,
                          curve: widget.pageAnimationCurve,
                          height: widget.dotSize,
                          width: widget.dotSize,
                          decoration: BoxDecoration(
                            color: i == activePage % widget.slides.length
                                ? widget.dotActiveColor
                                : widget.dotColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(36)),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ]
        ],
      ),
    );
  }

  void nextPage() {
    goToPage(activePage + 1);
  }

  void previousPage() {
    goToPage(activePage - 1);
  }

  void goToPage(int page) {
    setState(() {
      activePage = page;
      _pageController.animateToPage(
        page,
        duration: widget.pageAnimationDuration,
        curve: widget.pageAnimationCurve,
      );
    });
  }
}
