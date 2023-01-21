import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodler/Bloc/userEvent.dart';
import 'package:doodler/Model/User.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class UserBloc extends Bloc {
  String? downloadUrl;
  String? id;

  StreamController<UserEvent> _userEventController =
      StreamController<UserEvent>.broadcast();

  StreamSink<UserEvent> get userEventSink => _userEventController.sink;

  Stream<UserEvent> get _userEventStream => _userEventController.stream;

  StreamController<User> _userDataController =
      StreamController<User>.broadcast();

  StreamSink<User> get userDataSink => _userDataController.sink;

  Stream<User> get userDataStream => _userDataController.stream;

  UserBloc() {
    _userEventStream.listen(mapEventToState);
  }

  Future<void> mapEventToState(UserEvent event) async {
    if (event is AddUser) {
      Reference storageReference = FirebaseStorage.instance.ref();
      Reference ref = storageReference.child("users/");
      UploadTask storageUploadTask =
          ref.child(event.file!.path).putFile(File(event.file!.path));

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
        downloadUrl = await (storageTaskSnapshot.ref.getDownloadURL() as FutureOr<String?>);
        print("Download URL " + downloadUrl.toString());
      }*/
      //Catch any cases here that might come up like canceled, interrupted

      FirebaseFirestore.instance
          .collection("users")
          .doc(event.user.userId!)
          .set({"photoPath": downloadUrl});
      FirebaseFirestore.instance
          .collection("users")
          .doc(event.user.userId!)
          .update(event.user.toJson(event.user.userId));

//      DocumentReference ref = await FirebaseFirestore.instance.collection("users").add({
//        "userId": "",
//      });
      /*  await FirebaseFirestore.instance
          .collection("users")
          .doc(event.user.userId)
          .set(event.user.toJson(event.user.userId), SetOptions(merge: true));*/
    } else if (event is FetchUser) {
      final snapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(event.userID)
          .get();

      if (snapShot == null || !snapShot.exists) {
        // Document with id == docId doesn't exist.
        User user = User(userId: "None");
        userDataSink.add(user);
      } else {
        print("UID:" + event.userID);
        userDataSink.add(User.fromMap(snapShot.data() as Map<String, dynamic>));
      }
    }
  }

  @override
  void dispose() {
    _userEventController.close();
    _userDataController.close();
  }
}
