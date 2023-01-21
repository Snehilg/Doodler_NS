import 'package:flutter/material.dart';

class LearderBoard extends StatefulWidget {
  @override
  _LearderBoardState createState() => _LearderBoardState();
}

class _LearderBoardState extends State<LearderBoard> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Result of contest winner will be displayed here (: !!!",
    style: TextStyle(color:Colors.grey,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,
    fontSize: 14.0),),);
     
  }
}