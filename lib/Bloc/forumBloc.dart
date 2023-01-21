import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodler/Bloc/forumEvent.dart';
import 'package:doodler/Model/Forum.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ForumBloc extends Bloc {
  String? downloadUrl;
  String? id;

  List<Forum>? _allforums;
  List<Forum>? get allForum => _allforums;
  List<Forum>? _filteredforums;
  List<Forum>? get filteredForum => _filteredforums;

  List<Comment>? _allComments;
  List<Comment>? get allCommenst => _allComments;
  List<Likes>? _allLikes;
  List<Likes>? get allLikes => _allLikes;

  StreamController<ForumEvent> _forumEventController =
      StreamController<ForumEvent>.broadcast();

  StreamSink<ForumEvent> get forumEventSink => _forumEventController.sink;

  Stream<ForumEvent> get _forumEventStream => _forumEventController.stream;
  StreamController<List<Forum>?> _allForumController =
      StreamController<List<Forum>?>.broadcast();
  StreamSink<List<Forum>?> get allForumSink => _allForumController.sink;
  Stream<List<Forum>?> get allForumStream => _allForumController.stream;
  StreamController<List<Forum>> _filteredForumController =
      StreamController<List<Forum>>.broadcast();
  StreamSink<List<Forum>> get filteredForumSink =>
      _filteredForumController.sink;
  Stream<List<Forum>> get filteredForumStream =>
      _filteredForumController.stream;

  StreamController<List<Comment>> _commentsDataController =
      StreamController<List<Comment>>.broadcast();
  StreamSink<List<Comment>> get commentsDataSink =>
      _commentsDataController.sink;

  Stream<List<Comment>> get commentsDataStream =>
      _commentsDataController.stream;
  StreamController<List<Likes>> _likesDataController =
      StreamController<List<Likes>>.broadcast();
  StreamSink<List<Likes>> get likesDataSink => _likesDataController.sink;

  Stream<List<Likes>> get likesDataStream => _likesDataController.stream;

  ForumBloc() {
    _forumEventStream.listen(mapEventToState);
  }

  Future<void> mapEventToState(ForumEvent event) async {
    if (event is AddForum) {
      if (event.file != null) {
        Reference storageReference = FirebaseStorage.instance.ref();
        Reference ref = storageReference.child("Forums/");
        UploadTask storageUploadTask =
            ref.child(event.file!.path).putFile(File(event.file!.path));

        //Todo
        // if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
        final String url = await (ref.getDownloadURL() as FutureOr<String>);
        print("The download URL is " + url);
        //}
        /*else if (storageUploadTask.isInProgress) {
          storageUploadTask.events.listen((event) {
            double percentage = 100 *
                (event.snapshot.bytesTransferred.toDouble() /
                    event.snapshot.totalByteCount.toDouble());
            print("THe percentage " + percentage.toString());
          });

          StorageTaskSnapshot storageTaskSnapshot =
              await storageUploadTask.onComplete;
          downloadUrl = await (storageTaskSnapshot.ref.getDownloadURL()
              as FutureOr<String?>);
          print("Download URL " + downloadUrl.toString());
        }*/
      } else {
        print("Hello");
      }
      //Catch any cases here that might come up like canceled, interrupted

      DocumentReference docRef =
          FirebaseFirestore.instance.collection("forums").doc();
      docRef.set({
        "docId": docRef.id,
        "url": downloadUrl == null ? null : downloadUrl
      });
      FirebaseFirestore.instance
          .collection("forums")
          .doc(docRef.id)
          .update(event.forum.toJson());
    } else if (event is UpdateForum) {
      if (event.file != null) {
        Reference storageReference = FirebaseStorage.instance.ref();
        Reference ref = storageReference.child("forums/");
        UploadTask storageUploadTask =
            ref.child(event.file!.path).putFile(File(event.file!.path));
//Todo
        // if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
        final String url = await (ref.getDownloadURL() as FutureOr<String>);
        print("The download URL is " + url);
        //}
        /*else if (storageUploadTask.isInProgress) {
          storageUploadTask.events.listen((event) {
            double percentage = 100 *
                (event.snapshot.bytesTransferred.toDouble() /
                    event.snapshot.totalByteCount.toDouble());
            print("THe percentage " + percentage.toString());
          });

          StorageTaskSnapshot storageTaskSnapshot =
              await storageUploadTask.onComplete;
          downloadUrl = await (storageTaskSnapshot.ref.getDownloadURL()
              as FutureOr<String?>);
          print("Download URL " + downloadUrl.toString());
        }*/
      } else {
        print("hello");
      }
      //Catch any cases here that might come up like canceled, interrupted

      FirebaseFirestore.instance.collection("forums").doc(event.docId!).update({
        "url": downloadUrl == null ? null : downloadUrl,
        "note": event.note
      });
    } else if (event is FetchForum) {
      FirebaseFirestore.instance
          .collection("forums")
          .snapshots()
          .listen((snapshot) {
        _allforums = <Forum>[];
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allforums!.add(Forum.fromMap(snapshot.docs[i].data()));
        }
        allForumSink.add(_allforums);
      });
    } else if (event is FetchFilteredForum) {
      FirebaseFirestore.instance
          .collection("forums")
          .where("note", isLessThanOrEqualTo: event.note)
          .snapshots()
          .listen((snapshot) {
        _filteredforums = <Forum>[];
        for (int i = 0; i < snapshot.docs.length; i++) {
          _filteredforums!.add(Forum.fromMap(snapshot.docs[i].data()));
        }
        allForumSink.add(_filteredforums);
      });
    } else if (event is DeleteForum) {
      await FirebaseFirestore.instance
          .collection("forums")
          .doc(event.docId!)
          .update({"delete": event.delete});
    } else if (event is AddComments) {
      await FirebaseFirestore.instance
          .collection("forums")
          .doc(event.docId!)
          .update({
        "comments": FieldValue.arrayUnion([event.comment.toJson()])
      });
    } else if (event is UpdateStatus) {
      await FirebaseFirestore.instance
          .collection("forums")
          .doc(event.docId!)
          .update({"status": event.status});
    } else if (event is AddComments) {
      await FirebaseFirestore.instance
          .collection("forums")
          .doc(event.docId!)
          .update({
        "comments": FieldValue.arrayUnion([event.comment.toJson()])
      });
    } else if (event is FetchComments) {
      FirebaseFirestore.instance
          .collection("forums")
          .doc(event.docId!)
          .snapshots()
          .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        List<Comment> comments = [];
        for (int i = 0; i < snapshot.data()!["comments"].length; i++) {
          comments.add(Comment.fromMap(snapshot.data()!["comments"][i]));
        }
        commentsDataSink.add(comments);
      });
    } else if (event is DeleteComments) {
      await FirebaseFirestore.instance
          .collection("forums")
          .doc(event.docId!)
          .update({
        "comments": FieldValue.arrayRemove([event.comment!.toJson()])
      });
    } else if (event is AddLikes) {
      await FirebaseFirestore.instance
          .collection("forums")
          .doc(event.docId!)
          .update({
        "likes": FieldValue.arrayUnion([event.likes!.toJson()])
      });
    } else if (event is RemoveLikes) {
      await FirebaseFirestore.instance
          .collection("forums")
          .doc(event.docId!)
          .update({
        "likes": FieldValue.arrayRemove([event.likes!.toJson()])
      });
    }
  }

  @override
  void dispose() {
    _likesDataController.close();
    _forumEventController.close();
    _allForumController.close();
    _filteredForumController.close();
    _commentsDataController.close();
  }
}
