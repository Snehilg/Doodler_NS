import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MyDice extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MyDice> {
  late FlutterTts flutterTts;
  String one = "images/one.png";
  String two = "images/two.png";
  String three = "images/three.png";
  String four = "images/four.png";
  String five = "images/five.png";
  String six = "images/six.png";

  String? diceImage;
  void setTts() async {
    flutterTts = FlutterTts();
    await flutterTts.isLanguageAvailable("en-US");
    await flutterTts.setSpeechRate(0.8);
  }

  Future _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    setTts();
    setState(() {
      diceImage = one;
    });
  }

  void rollDice() {
    int random = (1 + Random().nextInt(6));

    String? newImage;
    switch (random) {
      case 1:
        newImage = one;
        setTts();
        _speak("one");
        break;
      case 2:
        newImage = two;
        setTts();
        _speak("two");
        break;
      case 3:
        newImage = three;
        setTts();
        _speak("three");
        break;
      case 4:
        newImage = four;
        setTts();
        _speak("four");
        break;
      case 5:
        newImage = five;
        setTts();
        _speak("five");
        break;
      case 6:
        newImage = six;
        setTts();
        _speak("six");
        break;
    }
    setState(() {
      diceImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dice Roller'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                diceImage.toString(),
                width: 200.0,
                height: 200.0,
              ),
              Container(
                //padding is inside element, margin is outside the element
                margin: EdgeInsets.only(top: 100.0),
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.green;
                    }
                    return Colors.yellow;
                  })),
                  //padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                  child: Text('Roll the dice!'),
                  onPressed: rollDice,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
