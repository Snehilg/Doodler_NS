import 'package:doodler/Model/User.dart';
import 'package:doodler/UI/Screens/LeaderBoard.dart';
import 'package:doodler/UI/SketchPost/PrivatePost.dart';
import 'package:doodler/UI/SketchPost/PublicPost.dart';
import 'package:flutter/material.dart';

class BoardScreen extends StatefulWidget {
  final User? user;
  BoardScreen({this.user});
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white54,
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            bottom: TabBar(
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white54),
                tabs: [
                  Tab(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(color: Colors.white10, width: 2)),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Global Art",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ))),
                  ),
                  Tab(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(color: Colors.white10, width: 2)),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "My Art",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ))),
                  ),
                  Tab(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(color: Colors.white10, width: 2)),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "LeaderBoard",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ))),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            PublicPost(
              userData: widget.user != null ? widget.user : null,
            ),
            PrivatePost(
              userData: widget.user != null ? widget.user : null,
            ),
            LearderBoard()
          ]),
        ));
  }
}
