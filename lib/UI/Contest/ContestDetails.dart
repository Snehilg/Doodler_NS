import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:doodler/Model/User.dart';
import 'package:doodler/Model/contest.dart';
import 'package:doodler/UI/Contest/ContestForm.dart';
import 'package:flutter/material.dart';

class ContestDetails extends StatefulWidget {
  final User? user;
  final Contest? contest;
  ContestDetails({this.contest, this.user});
  @override
  _ContestDetailsState createState() => _ContestDetailsState();
}

class _ContestDetailsState extends State<ContestDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contest Details'),
        ),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors
                        .greenAccent, //                   <--- border color
                    width: 5.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Card(
                    color: Colors.white70,
                    child: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Column(children: [
                          Container(
                              padding: EdgeInsets.only(top: 6.0),
                              width: MediaQuery.of(context).size.width,
                              height: 40.0,
                              color: Colors.deepPurple,
                              child: Text(
                                "${widget.contest!.title![0].toUpperCase()}${widget.contest!.title!.substring(1)}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              )),
                          Container(
                              padding: EdgeInsets.all(10.0),
                              color: Colors.pinkAccent[100],
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.info_outline),
                                    Text(
                                      "About the Contest",
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      widget.contest!.note!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    )),
                              ])),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Spacer(),
                                Text(
                                  "Starting Date :",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                                Text(widget.contest!.startDate!),
                                Spacer()
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Spacer(),
                                Text(
                                  "Ending Date :",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                                Text(widget.contest!.endDate!),
                                Spacer()
                              ]),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                              padding: EdgeInsets.all(5.0),
                              color: Colors.orangeAccent,
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.card_giftcard),
                                    Text(
                                      "Winning Prize",
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      widget.contest!.prize!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    )),
                              ])),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.indigoAccent[200],
                            padding: EdgeInsets.all(10.0),
                            child: Column(children: [
                              Text(
                                "Rules for the contest",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.contest!.rules!.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Text(widget.contest!.rules![i]!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white));
                                  }),
                            ]),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Text(
                                  "Registration open till  :",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                                Text(widget.contest!.regEndDate!),
                                Spacer(),
                              ]),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 50.0, right: 50.0),
                            height: 40.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.greenAccent,
                              color: Colors.lightBlue[700],
                              elevation: 7.0,
                              child: GestureDetector(
                                onTap: () {
                                  /* if(widget.co
                                ntest.nominations.contains({"nominations":auth.FirebaseAuth.instance.currentUser.uid})!=null){
                                    return displayDialog();
                                  }
                                else {*/

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ContestForms(
                                                docId: widget.contest!.docId,
                                                user: widget.user,
                                              )));
                                },
                                child: Center(
                                  child: Text(
                                    'Register Now',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]))))));
  }

  displayDialog() async {
    AwesomeDialog(
      context: context,
      animType: AnimType.BOTTOMSLIDE,
      dialogType: DialogType.INFO,
      body: Center(
        child: Text(
          """sorry!
        You can't register twice.. """,
          style: TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ),
      btnOkOnPress: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    )..show();
  }
}
