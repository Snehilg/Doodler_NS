import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ColorMatching extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ColorMatchingState();
  }
}

class _ColorMatchingState extends State<ColorMatching> {
  var containerOneColor = Colors.red;
  var containerTwoColor = Colors.cyan;
  var container3Color = Colors.orange;
  var container4Color = Colors.yellow;
  var container5Color = Colors.purple;
  var container6Color = Colors.indigo;
  var container7Color = Colors.brown;
  List colorList = [
    Colors.purple,
    Colors.amber,
    Colors.orange,
    Colors.cyan,
    Colors.red,
    Colors.green
  ];
  var random = new Random();
  var assignColor;
  var tapButton = true;
  int seconds = 20;
  bool _gameStart = false;

  updateTimer(bool tapButton) {
    _gameStart = true;
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // print("in timer");

      setState(() {
        tapButton = false;
        seconds = seconds - 1;
        if (seconds < 0) {
          timer.cancel();
          seconds = 20;
          alertBox("Oops.. Game Over", "Better Luck next Time!!!");
          resetColors();
          initState();
          tapButton = true;
          _gameStart = false;
        } else if (assignColor == containerOneColor &&
            assignColor == containerTwoColor &&
            assignColor == container3Color &&
            assignColor == container4Color &&
            assignColor == container5Color &&
            assignColor == container6Color &&
            assignColor == container7Color) {
          alertBox("Wohoooo !!!!", "You Won the Game  :)");
          timer.cancel();
          resetColors();
          initState();
          tapButton = true;
          _gameStart = false;
        }
      });
    });
  }

  alertBox(String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text("${title}"),
        content: Text("${content}"),
        actions: [
          TextButton(
            child: Text("ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  resetColors() {
    containerOneColor = Colors.red;
    containerTwoColor = Colors.cyan;
    container3Color = Colors.orange;
    container4Color = Colors.yellow;
    container5Color = Colors.purple;
    container6Color = Colors.indigo;
    container7Color = Colors.brown;
  }

  @override
  void initState() {
    assignColor = colorList[random.nextInt(colorList.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            headerRow(),
            rowTwo(),
            rowOne(),
            Expanded(
                child: GestureDetector(
              onTap: () {
                setState(() {
                  _gameStart
                      ? container4Color =
                          colorList[random.nextInt(colorList.length)]
                      : alertBox("Start the Game First",
                          "Tap on the Red Play button at the top to start the game.");
                  // container4Color = colorList[random.nextInt(colorList.length)];
                });
              },
              child: Container(
                height: 100.0,
                width: 100.0,
                color: container4Color,
              ),
            )),
            rowThree(),
          ],
        ),
      ),
    );
  }

  Row rowThree() {
    return Row(
      children: <Widget>[
        Expanded(
            child: GestureDetector(
          onTap: () {
            setState(() {
              _gameStart
                  ? container5Color =
                      colorList[random.nextInt(colorList.length)]
                  : alertBox("Start the Game First",
                      "Tap on the Red Play button at the top to start the game.");
              // container5Color = colorList[random.nextInt(colorList.length)];
            });
          },
          child: Container(
            margin: EdgeInsets.all(5),
            height: 100.0,
            width: 100.0,
            color: container5Color,
          ),
        )),
        Expanded(
            child: GestureDetector(
          onTap: () {
            setState(() {
              _gameStart
                  ? container6Color =
                      colorList[random.nextInt(colorList.length)]
                  : alertBox("Start the Game First",
                      "Tap on the Red Play button at the top to start the game.");
              //container6Color = colorList[random.nextInt(colorList.length)];
            });
          },
          child: Container(
            margin: EdgeInsets.all(5),
            height: 100.0,
            width: 100.0,
            color: container6Color,
          ),
        )),
        Expanded(
            child: GestureDetector(
          onTap: () {
            setState(() {
              _gameStart
                  ? container7Color =
                      colorList[random.nextInt(colorList.length)]
                  : alertBox("Start the Game First",
                      "Tap on the Red Play button at the top to start the game.");
              // container7Color = colorList[random.nextInt(colorList.length)];
            });
          },
          child: Container(
            margin: EdgeInsets.all(5),
            height: 100.0,
            width: 100.0,
            color: container7Color,
          ),
        )),
      ],
    );
  }

  Row rowOne() {
    return Row(
      children: <Widget>[
        Expanded(
            child: GestureDetector(
          onTap: () {
            setState(() {
              _gameStart
                  ? containerOneColor =
                      colorList[random.nextInt(colorList.length)]
                  : alertBox("Start the Game First",
                      "Tap on the Red Play button at the top to start the game.");
              // containerOneColor = colorList[random.nextInt(colorList.length)];
            });
          },
          child: Container(
            margin: EdgeInsets.all(5),
            height: 100.0,
            width: 100.0,
            color: containerOneColor,
          ),
        )),
        Expanded(
            child: GestureDetector(
          onTap: () {
            setState(() {
              _gameStart
                  ? containerTwoColor =
                      colorList[random.nextInt(colorList.length)]
                  : alertBox("Start the Game First",
                      "Tap on the Red Play button at the top to start the game.");
              // containerTwoColor = colorList[random.nextInt(colorList.length)];
            });
          },
          child: Container(
            margin: EdgeInsets.all(5),
            height: 100.0,
            width: 100.0,
            color: containerTwoColor,
          ),
        )),
        Expanded(
            child: GestureDetector(
          onTap: () {
            setState(() {
              _gameStart
                  ? container3Color =
                      colorList[random.nextInt(colorList.length)]
                  : alertBox("Start the Game First",
                      "Tap on the Red Play button at the top to start the game.");
              //container3Color = colorList[random.nextInt(colorList.length)];
            });
          },
          child: Container(
            margin: EdgeInsets.all(5),
            height: 100.0,
            width: 100.0,
            color: container3Color,
          ),
        )),
      ],
    );
  }

  Column rowTwo() {
    return Column(
      children: [
        Text("Match the color of all the boxes with above color."),
        Text("Tap on the box to change color")
      ],
    );
  }

  Row headerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          child: Text("Time Left: $seconds"),
        ),
        GestureDetector(
          onTap: tapButton
              ? () {
                  updateTimer(tapButton);
                }
              : alertBox("Start the Game First",
                  "Tap on the Red Play button at the top to start the game."),
          child: Container(
            child: Icon(
              Icons.play_arrow,
              color: Colors.red,
            ),
            margin: EdgeInsets.all(10.0),
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            height: 40.0,
            width: 40.0,
          ),
        ),
        Container(
          decoration:
              BoxDecoration(color: assignColor, shape: BoxShape.rectangle),
          height: 30,
          width: 30,
        ),
      ],
    );
  }
}
