import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodler/Bloc/ContestEvent.dart';
import 'package:doodler/Model/contest.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ContestBloc extends Bloc {
  String? downloadUrl;
  String? id;

  List<Contest>? _allContests;
  List<Contest>? get allContest => _allContests;
  List<ContestForm>? _contestForm;
  List<ContestForm>? get contestForm => _contestForm;
  List<ContestForm> _filterContestForm = <ContestForm>[];
  List<ContestForm> get filterContestForm => this._filterContestForm;
  List<ContestComment>? _allComments;
  List<ContestComment>? get allCommenst => _allComments;
  List<ContestLikes>? _allLikes;
  List<ContestLikes>? get allLikes => _allLikes;

  StreamController<ContestEvent> _contestEventController =
      StreamController<ContestEvent>.broadcast();

  StreamSink<ContestEvent> get contestEventSink => _contestEventController.sink;

  Stream<ContestEvent> get _contestEventStream =>
      _contestEventController.stream;
  StreamController<List<Contest>?> _allContestController =
      StreamController<List<Contest>?>.broadcast();
  StreamSink<List<Contest>?> get allContestSink => _allContestController.sink;
  Stream<List<Contest>?> get allContestStream => _allContestController.stream;
  StreamController<List<ContestForm>?> _contestFormController =
      StreamController<List<ContestForm>?>.broadcast();
  StreamSink<List<ContestForm>?> get allContestFormSink =>
      _contestFormController.sink;
  Stream<List<ContestForm>?> get allContestFormStream =>
      _contestFormController.stream;
  StreamController<List<ContestForm>> _contestFormfilterController =
      StreamController<List<ContestForm>>.broadcast();
  StreamSink<List<ContestForm>> get allContestFormfilterSink =>
      _contestFormfilterController.sink;
  Stream<List<ContestForm>> get allContestFormfilterStream =>
      _contestFormfilterController.stream;

  StreamController<List<ContestComment>> _commentsDataController =
      StreamController<List<ContestComment>>.broadcast();
  StreamSink<List<ContestComment>> get commentsDataSink =>
      _commentsDataController.sink;

  Stream<List<ContestComment>> get commentsDataStream =>
      _commentsDataController.stream;
  StreamController<List<ContestLikes>> _likesDataController =
      StreamController<List<ContestLikes>>.broadcast();
  StreamSink<List<ContestLikes>> get likesDataSink => _likesDataController.sink;

  Stream<List<ContestLikes>> get likesDataStream => _likesDataController.stream;

  ContestBloc() {
    _contestEventStream.listen(mapEventToState);
  }

  Future<void> mapEventToState(ContestEvent event) async {
    if (event is AddContest) {
      Reference storageReference = FirebaseStorage.instance.ref();
      Reference ref = storageReference.child("contests/");
      UploadTask storageUploadTask =
          ref.child(event.file!.path).putFile(File(event.file!.path));

      // if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
      final String url = await (ref.getDownloadURL() as FutureOr<String>);
      print("The download URL is " + url);
      //}
      //Todo
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
      //Catch any cases here that might come up like canceled, interrupted

      DocumentReference docRef =
          FirebaseFirestore.instance.collection("usercontests").doc();
      docRef.set({"docId": docRef.id, "url": downloadUrl});
      FirebaseFirestore.instance
          .collection("usercontests")
          .doc(docRef.id)
          .update(event.contest.toJson());
    } else if (event is GetContest) {
      FirebaseFirestore.instance
          .collection("usercontests")
          .snapshots()
          .listen((snapshot) {
        _contestForm = <ContestForm>[];
        for (int i = 0; i < snapshot.docs.length; i++) {
          _contestForm!.add(ContestForm.fromMap(snapshot.docs[i].data()));
        }
        allContestFormSink.add(_contestForm);
      });
    } else if (event is GetPrivateContest) {
      _filterContestForm = <ContestForm>[];

      _contestForm!.forEach((contest) {
        if (contest.userId == event.userId) {
          filterContestForm.add(contest);
        }
      });
    }
    /* else if (event is GetPrivateContest) {
      FirebaseFirestore.instance
          .collection("usercontests")
          .where("userId", isEqualTo: event.userId)
          .snapshots()
          .listen((snapshot) {
        _form = List<ContestForm>();
        for (int i = 0; i < snapshot.docs.length; i++) {
          _form.add(ContestForm.fromMap(snapshot.docs[i].data()));
        }
        allContestFormSink.add(_form);
      });
    }*/
    else if (event is AddComments) {
      await FirebaseFirestore.instance
          .collection("usercontests")
          .doc(event.docId!)
          .update({
        "comments": FieldValue.arrayUnion([event.comment.toJson()])
      });
    } else if (event is FetchComments) {
      FirebaseFirestore.instance
          .collection("usercontests")
          .doc(event.docId!)
          .snapshots()
          .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        List<ContestComment> comments = [];
        for (int i = 0; i < snapshot.data()!["comments"].length; i++) {
          comments.add(ContestComment.fromMap(snapshot.data()!["comments"][i]));
        }
        commentsDataSink.add(comments);
      });
    } else if (event is DeleteComments) {
      await FirebaseFirestore.instance
          .collection("usercontests")
          .doc(event.docId!)
          .update({
        "comments": FieldValue.arrayRemove([event.comment!.toJson()])
      });
    } else if (event is AddLikes) {
      await FirebaseFirestore.instance
          .collection("usercontests")
          .doc(event.docId!)
          .update({
        "likes": FieldValue.arrayUnion([event.likes!.toJson()])
      });
    } else if (event is RemoveLikes) {
      await FirebaseFirestore.instance
          .collection("usercontests")
          .doc(event.docId!)
          .update({
        "likes": FieldValue.arrayRemove([event.likes!.toJson()])
      });
    } else if (event is FetchContest) {
      FirebaseFirestore.instance.collection("contests").snapshots().listen(
        (snapshot) {
          _allContests = <Contest>[];
          for (int i = 0; i < snapshot.docs.length; i++) {
            _allContests!.add(Contest.fromMap(snapshot.docs[i].data()));
          }
          allContestSink.add(_allContests);
        },
      );
    } else if (event is AddParticipants) {
      await FirebaseFirestore.instance
          .collection("contests")
          .doc(event.docId!)
          .update({
        "nominations": FieldValue.arrayUnion([event.nominations!.toJson()])
      });
    }
  }

  @override
  void dispose() {
    _likesDataController.close();
    _contestEventController.close();
    _allContestController.close();
    _contestFormController.close();
    _commentsDataController.close();
    _contestFormfilterController.close();
  }
}
