import 'dart:io';

import 'package:doodler/Model/contest.dart';
import 'package:flutter/material.dart';

abstract class ContestEvent {}

class FetchContest extends ContestEvent {}

class AddContest extends ContestEvent {
  final File? file;
  final ContestForm contest;

  AddContest({this.file, required this.contest});
}

class AddParticipants extends ContestEvent {
  final String? docId;
  final Nominations? nominations;
  AddParticipants({this.docId, this.nominations});
}

class GetContest extends ContestEvent {}

class GetPrivateContest extends ContestEvent {
  final String? userId;
  GetPrivateContest({this.userId});
}

class AddLikes extends ContestEvent {
  final String? docId;
  final ContestLikes? likes;
  AddLikes({this.likes, this.docId});
}

class RemoveLikes extends ContestEvent {
  final String? docId;
  final ContestLikes? likes;
  RemoveLikes({this.likes, this.docId});
}

class AddComments extends ContestEvent {
  final String? docId;
  final ContestComment comment;

  AddComments({required this.docId, required this.comment});
}

class FetchComments extends ContestEvent {
  final String? docId;
  FetchComments({this.docId});
}

class DeleteComments extends ContestEvent {
  final String? docId;
  final ContestComment? comment;

  DeleteComments({this.docId, this.comment});
}
