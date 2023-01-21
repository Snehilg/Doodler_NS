import 'package:doodler/Bloc/forumBloc.dart';
import 'package:doodler/Bloc/forumEvent.dart';
import 'package:doodler/Model/Forum.dart';
import 'package:doodler/Model/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';

class ForumCommentPage extends StatefulWidget {
  final Forum? forum;
  final User? user;
  ForumCommentPage({this.forum, this.user});
  @override
  _ContestCommentPageState createState() => _ContestCommentPageState();
}

class _ContestCommentPageState extends State<ForumCommentPage> {
  TextEditingController commentController = new TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ForumBloc _forumBloc = BlocProvider.of<ForumBloc>(context);
    _forumBloc.forumEventSink.add(FetchComments(
      docId: widget.forum!.docId,
    ));

    return Scaffold(
        appBar: AppBar(title: Text('Comments')),
        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20.0),
            child: ListView(children: [
              StreamBuilder<List<Comment>>(
                  stream: _forumBloc.commentsDataStream,
                  initialData: _forumBloc.allCommenst,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Scrollbar(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, i) {
                                return ListTile(
                                    title: Text(
                                      snapshot.data![i].userName == null
                                          ? ""
                                          : "${snapshot.data![i].userName![0].toUpperCase()}${snapshot.data![i].userName!.substring(1)}" +
                                              ":" +
                                              snapshot.data![i].comment!,
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                    ),
                                    trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          if (snapshot.data![i].userId ==
                                              auth.FirebaseAuth.instance
                                                  .currentUser!.uid) {
                                            _forumBloc.forumEventSink.add(
                                                DeleteComments(
                                                    docId: widget.forum!.docId,
                                                    comment:
                                                        snapshot.data![i]));
                                          } else {
                                            print("Hello");
                                          }
                                        }),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          snapshot.data![i].userPhoto == null
                                              ? ""
                                              : snapshot.data![i].userPhoto!),
                                    ),
                                    subtitle: Text(
                                        snapshot.data![i].commentDate!,
                                        style: TextStyle(color: Colors.black)));
                              }));
                    } else {
                      return Container(child: Text(''));
                    }
                  }),
              ListTile(
                  title: TextFormField(
                    controller: commentController,
                    decoration: InputDecoration(
                        labelText: "Write Comments here....",
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: OutlinedButton(
                      onPressed: () {
                        DateTime date = DateTime.now();
                        String formattedDate =
                            DateFormat('HH:mm \n EEE d MMM').format(date);

                        Comment comment = Comment(
                            comment: commentController.text,
                            commentDate: formattedDate,
                            userId: auth.FirebaseAuth.instance.currentUser!.uid,
                            userName: widget.user!.childName,
                            userPhoto: widget.user!.photoPath);

                        _forumBloc.forumEventSink.add(AddComments(
                            docId: widget.forum!.docId, comment: comment));
                        commentController.clear();
                      },
                      //borderSide: BorderSide.none,
                      child: Text(
                        'Publish',
                        style: TextStyle(color: Colors.black),
                      )))
            ])));
  }
}
