import 'dart:io';

import 'package:doodler/Model/Sketch.dart';
import 'package:flutter/material.dart';

abstract class SketchEvent{}

class AddSketch extends SketchEvent {
  final File? file;
  final Sketch? sketch;

  AddSketch({this.file,this.sketch});
}
class UpdateSketch extends SketchEvent {
  final String? docId;
  final File? file;
  final String? note;
  UpdateSketch({this.docId,this.file, this.note});
}

class FetchSketches extends SketchEvent {}

class FetchPrivateSketches extends SketchEvent {
  final String? userId;
  FetchPrivateSketches({this.userId});
}

class DeleteSketches extends SketchEvent {
  final String? docId;
  final String? delete;
  DeleteSketches({this.docId,this.delete});
}

class AddLikes extends SketchEvent {
  final String? docId;
  final Likes? likes;
  AddLikes({this.likes, this.docId});
}

class RemoveLikes extends SketchEvent {
  final String? docId;
  final Likes? likes;
  RemoveLikes({this.likes, this.docId});
}

class AddComments extends SketchEvent {
  final String? docId;
  final Comment comment;

  AddComments({required this.docId, required this.comment});
}

class FetchComments extends SketchEvent {
  final String? docId;
  FetchComments({this.docId});
}

class DeleteComments extends SketchEvent {
  final String? docId;
  final Comment? comment;
  //final String comment;

  DeleteComments({this.docId, this.comment});
}
class FetchContest extends SketchEvent{

}
