import 'dart:io';

import 'package:doodler/Model/ParentingTips.dart';
import 'package:flutter/material.dart';

abstract class ParentingEvent {}

class FetchTips extends ParentingEvent {}

class AddTips extends ParentingEvent {
  final File? file;
  final ParentingTips tips;

  AddTips({this.file, required this.tips});
}

class AddComments extends ParentingEvent {
  final String? docId;
  final Comment comment;

  AddComments({required this.docId, required this.comment});
}

class FetchComments extends ParentingEvent {
  final String? docId;
  FetchComments({this.docId});
}

class DeleteComments extends ParentingEvent {
  final String? docId;
  final Comment? comment;

  DeleteComments({this.docId, this.comment});
}

class UpdateTips extends ParentingEvent {
  final String? docId;
  final File? file;
  final String? note;
  UpdateTips({this.docId,this.file, this.note});
}
class DeleteTips extends ParentingEvent {
  final String? docId;
  final String? delete;
  DeleteTips({this.docId, this.delete});
}
