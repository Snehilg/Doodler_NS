import 'dart:io';

import 'package:doodler/Model/Forum.dart';
import 'package:flutter/material.dart';

abstract class ForumEvent {}

class FetchForum extends ForumEvent {}
class FetchFilteredForum extends ForumEvent {
  final String? note;
  FetchFilteredForum({this.note});
}

class AddForum extends ForumEvent {
  final File? file;
  final Forum forum;

  AddForum({this.file, required this.forum});
}
class UpdateForum extends ForumEvent {
  final String? docId;
  final File? file;
  final String? note;
  UpdateForum({this.docId,this.file, this.note});
}
class DeleteForum extends ForumEvent {
  final String? docId;
  final String? delete;
  DeleteForum({this.docId, this.delete});
}

class AddLikes extends ForumEvent {
  final String? docId;
  final Likes? likes;
  AddLikes({this.likes, this.docId});
}

class RemoveLikes extends ForumEvent {
  final String? docId;
  final Likes? likes;
  RemoveLikes({this.likes, this.docId});
}

class AddComments extends ForumEvent {
  final String? docId;
  final Comment comment;

  AddComments({required this.docId, required this.comment});
}

class FetchComments extends ForumEvent {
  final String? docId;
  FetchComments({this.docId});
}

class DeleteComments extends ForumEvent {
  final String? docId;
  final Comment? comment;

  DeleteComments({this.docId, this.comment});
}
class UpdateStatus extends ForumEvent{
final  String? docId;
final String? status;
UpdateStatus({this.docId,this.status});



  

}