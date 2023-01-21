/*
import 'dart:async';

import 'package:doodler/ml/widget/text_recognition_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextMLApp extends StatelessWidget {
  final String title = 'Read Stories';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.cyan),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

late FlutterTts flutterTts;

void setTts() async {
  flutterTts = FlutterTts();
  List<dynamic>? languages =
      await (flutterTts.getLanguages as FutureOr<List<dynamic>?>);

  await flutterTts.setLanguage("en-US");

  await flutterTts.setSpeechRate(0.8);

  //await flutterTts.setVolume(0.3);

  //await flutterTts.setPitch(0.8);

  //await flutterTts.isLanguageAvailable("en-US");

  //await flutterTts.isLanguageAvailable("en-US");
  //await flutterTts.setSpeechRate(0.7);
}

Future _stop() async {
  var result = await flutterTts.stop();
  //if (result == 1) setState(() => ttsState = TtsState.stopped);
}

Future<bool> _onBackPressed() {
  return _stop().then((value) => value as bool);
  print("Its working....");
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () {
          _onBackPressed();
        } as Future<bool> Function()?,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const SizedBox(height: 25),
                TextRecognitionWidget(),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      );
}
*/
