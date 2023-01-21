import 'package:doodler/Bloc/ContestBloc.dart';
import 'package:doodler/Bloc/ContestEvent.dart';
import 'package:doodler/Model/User.dart';
import 'package:doodler/Model/contest.dart';
import 'package:doodler/UI/Authentication/welcomePage.dart';
import 'package:doodler/UI/Contest/ContestCommentPage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
//import 'package:getflutter/components/button/gf_button.dart';
//import 'package:getflutter/shape/gf_button_shape.dart';
import 'package:intl/intl.dart';

class PrivateContest extends StatefulWidget {
  final User? userData;
  PrivateContest({this.userData});
  @override
  _PrivateContestState createState() => _PrivateContestState();
}

class _PrivateContestState extends State<PrivateContest> {
  late ContestBloc _contestBloc;
  void didChangeDependencies() {
    _contestBloc = BlocProvider.of<ContestBloc>(context);
    _contestBloc.contestEventSink.add(GetPrivateContest(
        userId: widget.userData != null
            ? auth.FirebaseAuth.instance.currentUser!.uid
            : null));
    super.didChangeDependencies();
  }

  int index = 0;
  List<bool> _likes = [true, false];

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.userData != null
          ? Container(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<List<ContestForm>>(
                stream: _contestBloc.allContestFormfilterStream,
                initialData: _contestBloc.filterContestForm,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error"),
                      );
                    } else {
                      return Scrollbar(
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, i) {
                                return Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.amber,
                                            backgroundImage: NetworkImage(
                                                snapshot.data![i].userPhoto ==
                                                        null
                                                    ? ""
                                                    : snapshot
                                                        .data![i].userPhoto!),

                                            // backgroundImage:NetworkImage(widget.userData.photoPath),
                                            // backgroundColor: Colors.blue,
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                            snapshot.data![i].userName == null
                                                ? ""
                                                : "${snapshot.data![i].userName![0].toUpperCase()}${snapshot.data![i].userName!.substring(1)}",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Spacer(),
                                          Text(DateFormat.yMMMEd()
                                              .format(DateTime.now())
                                              .toString()),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.network(
                                        snapshot.data![i].url == null
                                            ? ""
                                            : snapshot.data![i].url!,
                                        height: 300,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 15.0, top: 10.0),
                                      child: Row(children: [
                                        GestureDetector(
                                          child: Icon(
                                            Icons.favorite,
                                            size: 30.0,
                                            color: _likes[index]
                                                ? Colors.red
                                                : Colors.red,
                                          ),
                                          onTap: () {
                                            ContestLikes likes = ContestLikes(
                                                userId: auth.FirebaseAuth
                                                    .instance.currentUser!.uid);
                                            _contestBloc.contestEventSink.add(
                                                AddLikes(
                                                    docId:
                                                        snapshot.data![i].docId,
                                                    likes: likes));
                                            setState(() {
                                              _likes[index] = true;
                                            });
                                          },
                                          onDoubleTap: () {
                                            setState(() {
                                              _likes[index] = false;
                                            });
                                            ContestLikes likes = ContestLikes(
                                                userId: auth.FirebaseAuth
                                                    .instance.currentUser!.uid);
                                            _contestBloc.contestEventSink.add(
                                                RemoveLikes(
                                                    docId:
                                                        snapshot.data![i].docId,
                                                    likes: likes));
                                          },
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        GestureDetector(
                                          child: Icon(
                                            Icons.chat_bubble_outline,
                                            size: 25.0,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ContestCommentPage(
                                                          user: widget.userData,
                                                          contestForm:
                                                              snapshot.data![i],
                                                        )));
                                          },
                                        ),
                                        SizedBox(
                                          width: 160.0,
                                        ),
                                      ]),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: Text(
                                        snapshot.data![i].likes!.length
                                                    .toString() ==
                                                null
                                            ? 0 as String
                                            : snapshot.data![i].likes!.length
                                                    .toString() +
                                                "likes",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: Row(
                                        children: [
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  snapshot.data![i].userName ==
                                                          null
                                                      ? ""
                                                      : "${snapshot.data![i].userName![0].toUpperCase()}${snapshot.data![i].userName!.substring(1)}",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ]),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Column(children: [
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                child: Text(
                                                  snapshot.data![i].note == null
                                                      ? ""
                                                      : snapshot.data![i].note!,
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ))
                                          ])
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    )
                                  ],
                                ));
                              }));
                    }
                  } else {
                    return Center(
                      child: Text(
                        " your contest will be displayed here (: !!!",
                        style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                      ),
                    );
                  }
                },
              ))
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      // elevation: 5,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomePage()));
                      },
                      child: Text("Sign up with us Today !"),
                      /*shape: GFButtonShape.pills,
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
            ),
    );
  }
}
