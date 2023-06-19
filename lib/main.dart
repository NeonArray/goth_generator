import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:goth_generator/data.dart';

void main() {
  runApp(const GothNameGenerator());
}

enum NameFormat {
  screenName,
  gothName,
  brianifiedName,
}

class AudioCache {
  static play(String src) async {
    final player = AudioPlayer();
    await player.play(AssetSource(src));
  }
}

class GothName {
  const GothName({
    required this.prefix,
    required this.suffix,
    required this.divider,
    required this.fname,
    required this.lname,
  });

  final String prefix;
  final String suffix;
  final String divider;
  final String fname;
  final String lname;

  @override
  String toString() {
    return '$prefix$fname$divider$lname$suffix';
  }
}

class GothNameGenerator extends StatelessWidget {
  const GothNameGenerator({super.key});

  ThemeData _buildTheme() {
    var baseTheme = ThemeData();
    return baseTheme.copyWith(
      textTheme: GoogleFonts.asulTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: Colors.white),
        ),
      ),
      scaffoldBackgroundColor: const Color.fromRGBO(118, 44, 179, 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'No Scene Zines Goth Name Generator',
      theme: _buildTheme(),
      home: const MyHomePage(
        title: 'Goth Name Generator',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late final AnimationController _controller;
  late final AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late final Animation<Offset> _offsetAnimation;
  String name = '';

  @override
  void initState() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _scaleAnimation = Tween<double>(begin: 15, end: 1).animate(_controller);
    _rotationAnimation = Tween<double>(begin: 990, end: 0).animate(_controller);
    _controller.forward();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticIn,
    ));

    Future.delayed(const Duration(milliseconds: 1200), () {
      _slideController.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _slideController.dispose();
    _textController.dispose();
    super.dispose();
  }

  /// Returns a random word from a list of words
  /// @param set List<String> - list of words
  /// @returns String - random word from list
  String _getWord(List<String> set) {
    final name = set[Random().nextInt(set.length - 1)];
    return name[0].toUpperCase() + name.substring(1);
  }

  /// Generates a name based on the format
  /// @param format NameFormat - format of the name
  /// @returns void
  void _generateName(NameFormat format) async {
    final wordSets = WordSets();
    late GothName generatedName;

    switch (format) {
      case NameFormat.screenName:
        generatedName = GothName(
          prefix: 'xX',
          suffix: 'Xx',
          divider: '',
          fname: _getWord(wordSets.adjective),
          lname: _getWord(wordSets.nouns),
        );
        await AudioCache.play('sfx/aol.mp4');
        break;
      case NameFormat.gothName:
        generatedName = GothName(
          prefix: '',
          suffix: '',
          divider: ' ',
          fname: _getWord(wordSets.adjective),
          lname: _getWord(wordSets.nouns),
        );
        break;
      case NameFormat.brianifiedName:
        generatedName = GothName(
          prefix: '',
          suffix: ' lookin ass',
          divider: ' ',
          fname: _getWord(wordSets.adjective),
          lname: _getWord(wordSets.nouns),
        );
        break;
    }

    setState(() {
      name = generatedName.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = name;

    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      textStyle: const TextStyle(
        fontSize: 12,
      ),
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80),
              Image.asset(
                'assets/no-scene-zine.png',
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * (pi / 100),
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  'assets/goth-name-generator.png',
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 40),
              SlideTransition(
                position: _offsetAnimation,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color.fromRGBO(252, 69, 43, 1),
                            width: 1.0,
                          ),
                          bottom: BorderSide(
                            color: Color.fromRGBO(252, 69, 43, 1),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        children: const [
                          Text(
                            'Youre ready to embrace',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(252, 69, 43, 1),
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            'YOUR INNER GOTH',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(252, 69, 43, 1),
                              fontSize: 44,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'After reading issue 4, there is no doubt you’re dying to know what your goth name is. We’ve given you a variety of names to catfish someone as gullible as Titzi by using our goth generator. Have fun and die happy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      style: const TextStyle(color: Colors.black),
                      readOnly: true,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          icon: Image.asset(
                            'assets/aol-guy.png',
                            height: 12,
                          ),
                          onPressed: () {
                            _generateName(NameFormat.screenName);
                          },
                          style: style,
                          label: const Text('Screen Name'),
                        ),
                        ElevatedButton.icon(
                          icon: Image.asset(
                            'assets/bat.png',
                            height: 12,
                          ),
                          onPressed: () {
                            _generateName(NameFormat.gothName);
                          },
                          style: style,
                          label: const Text('Goth Name'),
                        ),
                        ElevatedButton.icon(
                          icon: Image.asset(
                            'assets/star-of-david.png',
                            height: 12,
                          ),
                          onPressed: () {
                            _generateName(NameFormat.brianifiedName);
                          },
                          style: style,
                          label: const Text('Brianified Name'),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
