import 'dart:io';

import 'package:doodler/Model/buyandsell.dart';
import 'package:flutter/material.dart';

abstract class ProductsEvent {}

class FetchProducts extends ProductsEvent {}

class AddProducts extends ProductsEvent {
  final File? file;
  final Products products;

  AddProducts({this.file, required this.products});
}

class AddComments extends ProductsEvent {
  final String? docId;
  final Comment comment;

  AddComments({required this.docId, required this.comment});
}

class FetchComments extends ProductsEvent {
  final String? docId;
  FetchComments({this.docId});
}

class DeleteComments extends ProductsEvent {
  final String? docId;
  final Comment? comment;

  DeleteComments({this.docId, this.comment});
}

class UpdateStatus extends ProductsEvent {
  final String? docId;
  final String? status;
  UpdateStatus({this.docId, this.status});
}

class UpdateProduct extends ProductsEvent {
  final String? docId;
  final File? file;
  final String? note;
  final String? price;
  UpdateProduct({this.docId,this.file, this.note,this.price});
}
class DeleteProduct extends ProductsEvent {
  final String? docId;
  final String? delete;
  DeleteProduct({this.docId, this.delete});
}
