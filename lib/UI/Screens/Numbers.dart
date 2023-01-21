import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
//import 'package:getflutter/components/button/gf_button.dart';
//import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Numbers extends StatefulWidget {
  @override
  _NumbersState createState() => _NumbersState();
}

class _NumbersState extends State<Numbers> {
  int _index = 0;

  Map<String, String> numbersImgMap = {};

//  int _colorindex = 0;

  late FlutterTts flutterTts;

  List<String> numeric = [];
  List<String> word = [];

  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.yellow,
  ];

  List<Color?> colors2 = [
    Colors.yellow[50],
    Colors.pink[50],
    Colors.green[50],
    Colors.cyanAccent[100],
    Colors.red[50]
  ];

  List<Color> colors3 = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  void createNumbers() {
    List<String> oneDigit = [
      "one",
      "two",
      "three",
      "four",
      "five",
      "six",
      "seven",
      "eight",
      "nine"
    ];

    List<String> twoDigit = [
      "eleven",
      "twelve",
      "thirteen",
      "fourteen",
      "fifteen",
      "sixteen",
      "seventeen",
      "eighteen",
      "nineteen"
    ];

    List<String> tensDigit = [
      "ten",
      "twenty",
      "thirty",
      "forty",
      "fifty",
      "sixty",
      "seventy",
      "eighty",
      "ninety",
      "hundred"
    ];
    for (int j = 1; j <= 10; j++) {
      if (j == 1) {
        int i;
        for (i = 0; i < 9; i++) numbersImgMap[(i + 1).toString()] = oneDigit[i];
        numbersImgMap[(i + 1).toString()] = tensDigit[0];
      } else if (j == 2) {
        int i;
        for (i = 0; i < 9; i++)
          numbersImgMap[((i + 1) + ((j - 1) * 10)).toString()] = twoDigit[i];
        numbersImgMap[((i + 1) + ((j - 1) * 10)).toString()] = tensDigit[1];
      } else if (j <= 10 && j > 0) {
        int i;
        for (i = 0; i < 9; i++)
          numbersImgMap[((i + 1) + ((j - 1) * 10)).toString()] =
              tensDigit[j - 2] + " " + oneDigit[i];
        numbersImgMap[((i + 1) + ((j - 1) * 10)).toString()] = tensDigit[j - 1];
      }
    }
  }

  void setTts() async {
    flutterTts = FlutterTts();
    await flutterTts.isLanguageAvailable("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  @override
  void initState() {
    super.initState();

    createNumbers();

    numbersImgMap.forEach((k, v) {
      if (!numeric.contains(k)) numeric.add(k);
      if (!word.contains(v)) word.add(v);
    });

    setTts();
    _speak("1");
  }

  Future _speak(text) async {
    await flutterTts.speak(text);
  }

  Future _stop() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: new MainDrawer(),
//      backgroundColor: colors[_index],

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              colors[Random().nextInt(5)],
              colors2[Random().nextInt(5)]!,
              colors3[Random().nextInt(5)]
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Text(
                  numeric[_index],
                  style: GoogleFonts.portLligatSans(
                    textStyle: Theme.of(context).textTheme.headline4!,
                    fontSize: 180,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 100),
            Expanded(
              flex: 2,
              child: Text(
                word[_index],
                style: GoogleFonts.portLligatSans(
                  textStyle: Theme.of(context).textTheme.headline4!,
                  fontSize: 60,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      _stop();

                      setState(() {
                        _index++;
                        _index %= 100;
                        int number = _index + 1;
//                      print(number);
//                      print(_index);
                        _speak(number.toString());
                      });
                    },
                    /*shape: GFButtonShape.pills,
                    color: Colors.amber,*/
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    /*shape: GFButtonShape.pills,
                    color: Colors.amber,*/
                    onPressed: () {
                      _stop();

                      setState(() {
                        _index = Random().nextInt(100);
                        int number = _index + 1;
                        _speak(number.toString());
                      });
                    },
                    child: Text(
                      'Random',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
