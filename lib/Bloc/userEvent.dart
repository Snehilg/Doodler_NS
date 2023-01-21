import 'dart:io';

import 'package:doodler/Model/Sketch.dart';
import 'package:doodler/Model/User.dart';
import 'package:flutter/material.dart';

abstract class UserEvent {}

class AddUser extends UserEvent {
  final User user;
  final File? file;

  AddUser({required this.user,this.file});
}

class FetchUser extends UserEvent {
  final String userID;

  FetchUser({required this.userID});
}
