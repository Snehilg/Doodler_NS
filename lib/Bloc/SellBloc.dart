import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodler/Bloc/SellEvent.dart';
import 'package:doodler/Model/buyandsell.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ProductBloc extends Bloc {
  String? downloadUrl;
  String? id;

  List<Products>? _allProducts;
  List<Products>? get allProduct => _allProducts;

  List<Comment>? _allComments;
  List<Comment>? get allCommenst => _allComments;

  StreamController<ProductsEvent> _productEventController =
      StreamController<ProductsEvent>.broadcast();

  StreamSink<ProductsEvent> get productEventSink =>
      _productEventController.sink;

  Stream<ProductsEvent> get _forumEventStream => _productEventController.stream;
  StreamController<List<Products>?> _allProductController =
      StreamController<List<Products>?>.broadcast();
  StreamSink<List<Products>?> get allProductSink => _allProductController.sink;
  Stream<List<Products>?> get allProductStream => _allProductController.stream;

  StreamController<List<Comment>> _commentsDataController =
      StreamController<List<Comment>>.broadcast();
  StreamSink<List<Comment>> get commentsDataSink =>
      _commentsDataController.sink;

  Stream<List<Comment>> get commentsDataStream =>
      _commentsDataController.stream;

  ProductBloc() {
    _forumEventStream.listen(mapEventToState);
  }

  Future<void> mapEventToState(ProductsEvent event) async {
    if (event is AddProducts) {
      if (event.file != null) {
        Reference storageReference = FirebaseStorage.instance.ref();
        Reference ref = storageReference.child("products/");
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
          downloadUrl = await (storageTaskSnapshot.ref.getDownloadURL()
              as FutureOr<String?>);
          print("Download URL " + downloadUrl.toString());
        }*/
      } else {
        print("hello");
      }
      //Catch any cases here that might come up like canceled, interrupted

      DocumentReference docRef =
          FirebaseFirestore.instance.collection("products").doc();
      docRef.set({
        "docId": docRef.id,
        "url": downloadUrl == null ? null : downloadUrl
      });
      FirebaseFirestore.instance
          .collection("products")
          .doc(docRef.id)
          .update(event.products.toJson());
    } else if (event is UpdateProduct) {
      if (event.file != null) {
        Reference storageReference = FirebaseStorage.instance.ref();
        Reference ref = storageReference.child("products/");
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

      FirebaseFirestore.instance
          .collection("products")
          .doc(event.docId!)
          .update({
        "url": downloadUrl == null ? null : downloadUrl,
        "note": event.note,
        "price": event.price
      });
    } else if (event is FetchProducts) {
      FirebaseFirestore.instance
          .collection("products")
          .snapshots()
          .listen((snapshot) {
        _allProducts = <Products>[];
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allProducts!.add(Products.fromMap(snapshot.docs[i].data()));
        }
        allProductSink.add(_allProducts);
      });
    } else if (event is DeleteProduct) {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(event.docId!)
          .update({"delete": event.delete});
    } else if (event is UpdateStatus) {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(event.docId!)
          .update({"status": event.status});
    } else if (event is AddComments) {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(event.docId!)
          .update({
        "comments": FieldValue.arrayUnion([event.comment.toJson()])
      });
    } else if (event is FetchComments) {
      FirebaseFirestore.instance
          .collection("products")
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
          .collection("products")
          .doc(event.docId!)
          .update({
        "comments": FieldValue.arrayRemove([event.comment!.toJson()])
      });
    }
  }

  @override
  void dispose() {
    _productEventController.close();
    _allProductController.close();
    _commentsDataController.close();
  }
}
