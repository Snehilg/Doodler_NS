/*
import 'dart:async';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:doodler/ml/api/firebase_ml_api.dart';
import 'package:doodler/ml/widget/controls_widget_audio.dart';
import 'package:doodler/ml/widget/text_area_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';

import 'controls_widget.dart';

class TextRecognitionWidget extends StatefulWidget {
  const TextRecognitionWidget({
    Key? key,
  }) : super(key: key);

  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  String text = '';
  File? image;

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

  Future _speak(text) async {
    print("text is in speak");
    print(text);
    await flutterTts.speak(text);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    //if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setTts();
  }

  Future<bool>? _onBackPressed() {
    _stop();
    print("Its working....");
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: WillPopScope(
          onWillPop: () {
            _onBackPressed();
            clear();
          } as Future<bool> Function()?,
          child: Column(
            children: [
              Expanded(child: buildImage()),
              const SizedBox(height: 16),
              ControlsWidget(
                onClickedPickImage: pickImage,
                onClickedScanText: scanText,
                // onClickedClear: clear,
                // onClickedRead: read,
              ),
              ControlsWidgetAudio(
                // onClickedPickImage: pickImage,
                // onClickedScanText: scanText,
                onClickedClear: clear,
                onClickedRead: read,
              ),
              const SizedBox(height: 16),
              TextAreaWidget(
                text: text,
                onClickedCopy: copyToClipboard,
              ),
            ],
          ),
        ),
      );

  Widget buildImage() => Container(
        child: image != null
            ? Image.file(image!)
            : Icon(Icons.photo, size: 80, color: Colors.black),
      );

  Future pickImage() async {
    final file = await ImagePicker().getImage(source: ImageSource.gallery);
    setImage(File(file.path));
  }

  Future scanText() async {
    print("In Scan Text");
    // showDialog(
    //     context: context,
    //     child: text.isEmpty
    //         ? Center(
    //             child: CircularProgressIndicator(),
    //           )
    //         : null);

    text = await FirebaseMLApi.recogniseText(image);
    setText(text);

    //Navigator.of(context).pop();
  }

  void clear() {
    setImage(null);
    setText('');
    _stop();
  }

  void read() {
    if (text.isNotEmpty) {
      _speak(text);
    } else {
      _speak(
          "Nothing to read. select an image with text ,then , click on scan for text ,so that i can read it for you .");
    }
  }

  void copyToClipboard() {
    if (text.trim() != '') {
      FlutterClipboard.copy(text);
    }
  }

  void setImage(File? newImage) {
    setState(() {
      image = newImage;
    });
  }

  void setText(String newText) {
    setState(() {
      text = newText;
    });
  }
}
*/
