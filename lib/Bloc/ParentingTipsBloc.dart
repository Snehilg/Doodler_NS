import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodler/Bloc/ParentingTipsEvent.dart';
import 'package:doodler/Model/ParentingTips.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ParentingBloc extends Bloc {
  String? downloadUrl;
  String? id;

  List<ParentingTips>? _allParentingTips;
  List<ParentingTips>? get allParentingTips => _allParentingTips;

  List<Comment>? _allComments;
  List<Comment>? get allCommenst => _allComments;

  StreamController<ParentingEvent> _parentingEventController =
      StreamController<ParentingEvent>.broadcast();

  StreamSink<ParentingEvent> get parentingEventSink =>
      _parentingEventController.sink;

  Stream<ParentingEvent> get _parentingEventStream =>
      _parentingEventController.stream;
  StreamController<List<ParentingTips>?> _allTipsController =
      StreamController<List<ParentingTips>?>.broadcast();
  StreamSink<List<ParentingTips>?> get allTipsSink => _allTipsController.sink;
  Stream<List<ParentingTips>?> get allTipsStream => _allTipsController.stream;

  StreamController<List<Comment>> _commentsDataController =
      StreamController<List<Comment>>.broadcast();
  StreamSink<List<Comment>> get commentsDataSink =>
      _commentsDataController.sink;

  Stream<List<Comment>> get commentsDataStream =>
      _commentsDataController.stream;

  ParentingBloc() {
    _parentingEventStream.listen(mapEventToState);
  }

  Future<void> mapEventToState(ParentingEvent event) async {
    if (event is AddTips) {
      if (event.file != null) {
        Reference storageReference = FirebaseStorage.instance.ref();
        Reference ref = storageReference.child("parentingTips/");
        UploadTask storageUploadTask =
            ref.child(event.file!.path).putFile(File(event.file!.path));
//Todo
        // if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
        final String url = await (ref.getDownloadURL() as FutureOr<String>);
        print("The download URL is " + url);
        /* } else if (storageUploadTask.isInProgress) {
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
          FirebaseFirestore.instance.collection("parentingTips").doc();
      docRef.set({
        "docId": docRef.id,
        "url": downloadUrl == null ? null : downloadUrl
      });
      FirebaseFirestore.instance
          .collection("parentingTips")
          .doc(docRef.id)
          .update(event.tips.toJson());
    } else if (event is FetchTips) {
      FirebaseFirestore.instance
          .collection("parentingTips")
          .snapshots()
          .listen((snapshot) {
        _allParentingTips = <ParentingTips>[];
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allParentingTips!
              .add(ParentingTips.fromMap(snapshot.docs[i].data()));
        }
        allTipsSink.add(_allParentingTips);
      });
    } else if (event is UpdateTips) {
      if (event.file != null) {
        Reference storageReference = FirebaseStorage.instance.ref();
        Reference ref = storageReference.child("parentingTips/");
        UploadTask storageUploadTask =
            ref.child(event.file!.path).putFile(File(event.file!.path));
//Todo
        // if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
        final String url = await (ref.getDownloadURL() as FutureOr<String>);
        print("The download URL is " + url);
        /* } else if (storageUploadTask.isInProgress) {
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

      FirebaseFirestore.instance
          .collection("parentingTips")
          .doc(event.docId!)
          .update({
        "url": downloadUrl == null ? null : downloadUrl,
        "note": event.note
      });
    } else if (event is DeleteTips) {
      await FirebaseFirestore.instance
          .collection("parentingTips")
          .doc(event.docId!)
          .update({"delete": event.delete});
    } else if (event is AddComments) {
      await FirebaseFirestore.instance
          .collection("parentingTips")
          .doc(event.docId!)
          .update({
        "comments": FieldValue.arrayUnion([event.comment.toJson()])
      });
    } else if (event is FetchComments) {
      FirebaseFirestore.instance
          .collection("parentingTips")
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
          .collection("parentingTips")
          .doc(event.docId!)
          .update({
        "comments": FieldValue.arrayRemove([event.comment!.toJson()])
      });
    }
  }

  @override
  void dispose() {
    _parentingEventController.close();
    _allTipsController.close();
    _commentsDataController.close();
  }
}
