import 'dart:async';

import 'package:doodler/UI/CardGame/card_board.dart';
import 'package:flutter/material.dart';

class Card_Home extends StatefulWidget {
  Card_HomeState createState() => new Card_HomeState();
}

class Card_HomeState extends State<Card_Home> {
  int score = 0;
  int time = 0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), runTimer);
  }

  void runTimer() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        this.time += 1;
        runTimer();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.orange,
                Colors.orangeAccent,
                Colors.greenAccent,
                Colors.yellowAccent,
                Colors.yellowAccent
              ])),
          child: Column(
            children: <Widget>[
              SizedBox(height: 24.0),
              buildScore(),
              buildBoard()
            ],
          ),
        ));
  }

  Widget buildScore() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(time.toString() + "s",
              style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.yellowAccent,
                  fontFamily: 'GamjaFlower')),
          Text(score.toString(),
              style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.yellowAccent,
                  fontFamily: 'GamjaFlower'))
        ],
      ),
    );
  }

  Widget buildBoard() {
    return Stack(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(8.0), child: CardBoard(onWin: onWin)),
        buildGradientView()
      ],
    );
  }

  Widget buildGradientView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 32.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.black, Colors.transparent])),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 32.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black, Colors.black])),
        )
      ],
    );
  }

  void onWin() {
    setState(() => this.score += 200);
  }
}
