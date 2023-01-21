import 'package:flutter/material.dart';

abstract class DataEvent {}

class FetchCategories extends DataEvent {
  String group;

  FetchCategories({required this.group});
}

class FetchGroups extends DataEvent {
  FetchGroups();
}

class FetchData extends DataEvent {
  String name;

  FetchData({required this.name});
}

class FetchCardData extends DataEvent {}

//class FruitsData extends DataEvent {
//  List<String> names;
//
//  FruitsData({@required this.names});
//
//  FruitsData.fromMap(Map<String, dynamic> map) {
//    this.names = List<String>();
//    for (var i = 0; i < map["Fruits"].length; i++) {
//      this.names.add(map["Fruits"][i]);
//    }
//  }
//}
//
//class FlowersData extends DataEvent {
//  List<String> names;
//
//  FlowersData({@required this.names});
//
//  FlowersData.fromMap(Map<String, dynamic> map) {
//    this.names = List<String>();
//    for (var i = 0; i < map["Flowers"].length; i++) {
//      this.names.add(map["Flowers"][i]);
//    }
//  }
//}
//
//class VegetablesData extends DataEvent {
//  List<String> names;
//
//  VegetablesData({@required this.names});
//
//  VegetablesData.fromMap(Map<String, dynamic> map) {
//    this.names = List<String>();
//    for (var i = 0; i < map["Vegetables"].length; i++) {
//      this.names.add(map["Vegetables"][i]);
//    }
//  }
//}
//
//class AnimalsData extends DataEvent {
//  List<String> names;
//
//  AnimalsData({@required this.names});
//
//  AnimalsData.fromMap(Map<String, dynamic> map) {
//    this.names = List<String>();
//    for (var i = 0; i < map["Animals"].length; i++) {
//      this.names.add(map["Animals"][i]);
//    }
//  }
//}
