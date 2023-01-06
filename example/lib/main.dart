import 'package:flutter/material.dart';
import 'package:slidespire/slidespire.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Slider Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Select a Wallpaper',
              ),
              const SizedBox(height: 10),
              Slidespire(
                slides: getWallpapers(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select a Wallpaper',
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
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
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getWallpapers() {
    List<String> wallpapers = [
      'https://images.unsplash.com/photo-1472152083436-a6eede6efad9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60',
      'https://images.unsplash.com/photo-1483347756197-71ef80e95f73?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8OHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60',
      'https://images.unsplash.com/photo-1431440869543-efaf3388c585?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60',
      'https://images.unsplash.com/photo-1491466424936-e304919aada7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8M3x8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60'
    ];
    return List<Widget>.generate(wallpapers.length, (index) {
      return Image.network(
        wallpapers[index],
        fit: BoxFit.cover,
      );
    });
  }
}
