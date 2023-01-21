import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodler/Bloc/postEvent.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class PostBloc extends Bloc {
  StreamController<PostEvent> _postEventController =
      StreamController<PostEvent>.broadcast();

  StreamSink<PostEvent> get postEventSink => _postEventController.sink;

  Stream<PostEvent> get _postEventStream => _postEventController.stream;

  PostBloc() {
    _postEventStream.listen(_mapEventToState);
  }

  Future<void> _mapEventToState(PostEvent event) async {
    if (event is AddPost) {
      DocumentReference ref =
          await FirebaseFirestore.instance.collection("posts").add({
        "userId": event.userID,
      });
      await FirebaseFirestore.instance.collection("posts").doc(ref.id).set(
          event.post.toJson(ref.id, event.userID), SetOptions(merge: true));
    }
  }

  @override
  void dispose() {
    _postEventController.close();
  }
}
