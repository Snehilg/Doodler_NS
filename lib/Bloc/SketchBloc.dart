import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodler/Bloc/SketchEvent.dart';
import 'package:doodler/Model/Sketch.dart';
import 'package:doodler/Model/contest.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SketchBloc extends Bloc {
  String? downloadUrl;
  String? id;
  List<Sketch>? _allSketches;
  List<Sketch>? get allSketches => _allSketches;
  List<Sketch>? _sketches;

  List<Sketch>? get allPrivateSketches => _sketches;
  List<Contest>? _allContests;
  List<Contest>? get allContest => _allContests;
  List<Comment>? _allComments;
  List<Comment>? get allCommenst => _allComments;
  List<Likes>? _allLikes;
  List<Likes>? get allLikes => _allLikes;

  StreamController<SketchEvent> _sketchEventController =
      StreamController<SketchEvent>.broadcast();

  StreamSink<SketchEvent> get sketchEventSink => _sketchEventController.sink;

  Stream<SketchEvent> get _sketchEventStream => _sketchEventController.stream;

  StreamController<List<Sketch>?> _sketchesDataController =
      StreamController<List<Sketch>?>.broadcast();

  StreamSink<List<Sketch>?> get sketchesDataSink =>
      _sketchesDataController.sink;

  Stream<List<Sketch>?> get sketchesDataStream =>
      _sketchesDataController.stream;
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

  SketchBloc() {
    _sketchEventStream.listen(mapEventToState);
  }

  Future<void> mapEventToState(SketchEvent event) async {
    if (event is AddSketch) {
      if (event.file != null) {
        Reference storageReference = FirebaseStorage.instance.ref();
        Reference ref = storageReference.child("sketches/");
        UploadTask storageUploadTask =
            ref.child(event.file!.path).putFile(File(event.file!.path));

        //if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
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
          FirebaseFirestore.instance.collection("Sketches").doc();
      docRef.set({
        "docId": docRef.id,
        "url": downloadUrl == null ? null : downloadUrl
      });
      FirebaseFirestore.instance
          .collection("Sketches")
          .doc(docRef.id)
          .update(event.sketch!.toJson());
    } else if (event is UpdateSketch) {
      if (event.file != null) {
        Reference storageReference = FirebaseStorage.instance.ref();
        Reference ref = storageReference.child("sketches/");
        UploadTask storageUploadTask =
            ref.child(event.file!.path).putFile(File(event.file!.path));

        // if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
        final String url = await (ref.getDownloadURL() as FutureOr<String>);
        print("The download URL is " + url);
        /*} else if (storageUploadTask.isInProgress) {
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
          .collection("Sketches")
          .doc(event.docId!)
          .update({
        "url": downloadUrl == null ? null : downloadUrl,
        "note": event.note
      });
    } else if (event is FetchSketches) {
      FirebaseFirestore.instance
          .collection("Sketches")
          .snapshots()
          .listen((snapshot) {
        _allSketches = <Sketch>[];
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allSketches!.add(Sketch.fromMap(snapshot.docs[i].data()));
        }
        print("All Sketches:${_allSketches!.length}");
        sketchesDataSink.add(_allSketches);
      });
    } else if (event is FetchPrivateSketches) {
      FirebaseFirestore.instance
          .collection("Sketches")
          .where("userId", isEqualTo: event.userId)
          .snapshots()
          .listen((snapshot) {
        _sketches = <Sketch>[];
        for (int i = 0; i < snapshot.docs.length; i++) {
          _sketches!.add(Sketch.fromMap(snapshot.docs[i].data()));
        }
        print("All Sketches:${_allSketches!.length}");
        sketchesDataSink.add(_sketches);
      });
    } else if (event is DeleteSketches) {
      await FirebaseFirestore.instance
          .collection("Sketches")
          .doc(event.docId!)
          .update({"delete": event.delete});
    } else if (event is AddComments) {
      await FirebaseFirestore.instance
          .collection("Sketches")
          .doc(event.docId!)
          .update({
        "comments": FieldValue.arrayUnion([event.comment.toJson()])
      });
    } else if (event is FetchComments) {
      FirebaseFirestore.instance
          .collection("Sketches")
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
          .collection("Sketches")
          .doc(event.docId!)
          .update({
        "comments": FieldValue.arrayRemove([event.comment!.toJson()])
      });
    } else if (event is AddLikes) {
      await FirebaseFirestore.instance
          .collection("Sketches")
          .doc(event.docId!)
          .update({
        "likes": FieldValue.arrayUnion([event.likes!.toJson()])
      });
    } else if (event is RemoveLikes) {
      await FirebaseFirestore.instance
          .collection("Sketches")
          .doc(event.docId!)
          .update({
        "likes": FieldValue.arrayRemove([event.likes!.toJson()])
      });
    }
  }

  @override
  void dispose() {
    _likesDataController.close();
    _sketchEventController.close();
    _sketchesDataController.close();
    _commentsDataController.close();
  }
}
