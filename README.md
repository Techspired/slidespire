# slidespire

A Highly Configurable Infinite Horizontal Slider Package for Flutter

## Features

Slides can be any widget
Show dots, next/previous buttons, both or just swipe
Auto-play or still. Infinite scrolling forwards or backwards
Supports callbacks

## Example

Just referenec the package and add the widget.
The only required parameter is a list of widgets to show as slides

    Slidespire(
                slides: List<Widget>[],
              ),


    SizedBox(
            //the slider can adapt to the parent container or have its height and width set directly
            width: 400,
            child: Slidespire(
              /// Setting the height of the Slidespire widget.
              height: 300,
              activePageViewportFraction: 1,
              autoSlide: true, // the slider is not animated by default
              showDots: true,
              showNextPreviousButtons: false,
              dotPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              inactiveSlideOpacity: 1,
              slideMargin: EdgeInsets.zero,
              width: MediaQuery.of(context).size.width * .8,
              slides: getWallpapers(),
            ),
          ),

## Defaults

    initialPage : 0, // the first page
    activePageViewportFraction : .8, // a value above 0, up to and including 1 indicating the size of the slider the active slide takes up. If less than 100, the slider shows the edges of the previous and next pages.
    slideMargin : const EdgeInsets.all(16),
    activeSlideMargin : const EdgeInsets.symmetric(horizontal: 10), //having a smaller margin for the active slide makes it appear larger than the inactive slides
    inactiveSlideOpacity : .6, //how transparent should the next and previous slides be
    showDots : false, //controlls whether to show the dot controllers on the bottom of the slider
    dotColor : Colors.black26,
    dotActiveColor : Colors.black,
    dotSize : 20,
    dotPadding : const EdgeInsets.symmetric(vertical: 10),
    showNextPreviousButtons : true,
    previousIcon : const Icon(Icons.chevron_left_rounded),
    nextIcon : const Icon(Icons.chevron_right_rounded),
    nextPreviousIconSize : 36,
    slideChangedCallback [nothing] //if you specify this callback, it will be called on swipe, previous button or next button press, AND dot press.
    previousButtonCallback [nothing] // this is if you want finer control of events. slideChangedCallback will also be called
    nextButtonCallback [nothing] // this is if you want finer control of events. slideChangedCallback will also be called
    dotCallback[nothing] // this is if you want finer control of events. slideChangedCallback will also be called
    height : [The media query height - 2* kAppBarHeight] The height also adapts to the parent container
    width : double.infinity,
    pageAnimationDuration : const Duration(milliseconds: 500),
    pageAnimationCurve : Curves.easeInOutCubic,
    autoSlide : false, // if true, the slides will animate
    autoSlideDuration : const Duration(seconds: 5), // the amount of time the slide stays still

## Supported platforms

- iOS
- Android
- Web
- MacOS
- Windows
- Linux
