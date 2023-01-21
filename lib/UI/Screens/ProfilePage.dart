import 'package:doodler/Model/User.dart';
import 'package:doodler/UI/Authentication/welcomePage.dart';
import 'package:flutter/material.dart';
//import 'package:getflutter/components/button/gf_button.dart';
//import 'package:getflutter/shape/gf_button_shape.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePage({this.user});
  final User? user;
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double circleRadius = 120.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.cyan[200],
        child: Column(
          children: [
            Stack(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: circleRadius / 2.0,
                      ),

                      ///here we create space for the circle avatar to get ut of the box
                      child: Container(
                        height: 300.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        child: Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: circleRadius / 2,
                                ),
                                Text(
                                  widget.user != null
                                      ? "${widget.user!.childName![0].toUpperCase()}${widget.user!.childName!.substring(1)}"
                                      : "Guest",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0,
                                      color: Colors.blueGrey),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Age',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            widget.user != null
                                                ? widget.user!.childAge
                                                    .toString()
                                                : "Not Known",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'GuardianName',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.black54),
                                          ),
                                          Spacer(),
                                          Text(
                                            widget.user != null
                                                ? widget.user!.guardianName!
                                                : "Not Known",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Gender',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.black54),
                                          ),
                                          Spacer(),
                                          Text(
                                            widget.user != null
                                                ? widget.user!.gender!
                                                : "Not Known",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),

                    ///Image Avatar
                    Container(
                      width: circleRadius,
                      height: circleRadius,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8.0,
                            offset: Offset(0.0, 5.0),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Center(
                          child: Container(
                            child: ClipOval(
                              child: Image.network(
                                widget.user != null
                                    ? widget.user!.photoPath != null
                                        ? widget.user!.photoPath!
                                        : "https://firebasestorage.googleapis.com/v0/b/doodler-6fab7.appspot.com/o/dashboardImage%2FUntitled.jpg?alt=media&token=8f817f78-8b34-4a15-b015-298573598725"
                                    : "https://firebasestorage.googleapis.com/v0/b/doodler-6fab7.appspot.com/o/dashboardImage%2FUntitled.jpg?alt=media&token=8f817f78-8b34-4a15-b015-298573598725",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            SizedBox(
              height: 20,
            ),
            Visibility(
              visible: widget.user == null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      //elevation: 5,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomePage()));
                      },
                      child: Text("Sign up with us Today !"),
                      /* shape: GFButtonShape.pills,
                      blockButton: true,
                      color: Colors.amber,
                      textColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 30),*/
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Participate in Contests .",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Publish your SketchBoard to the world.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Post your articles in forums and tips.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Make New Friends .",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "All that for free !!!!",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
