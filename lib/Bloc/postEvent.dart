import 'package:doodler/Model/Post.dart';
import 'package:flutter/material.dart';

abstract class PostEvent {}

class AddPost extends PostEvent {
  final Post post;
  final String userID;

  AddPost({required this.post, required this.userID});
}
