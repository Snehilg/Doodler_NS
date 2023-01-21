import 'package:doodler/Model/Sketch.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final Sketch? sketch;
  final Widget child;
  //Todo Super Child Text issue
  Provider({this.sketch, required this.child}) : super(child: Text("data"));

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static Sketch? of(BuildContext context) {
    Provider provider =
        context.dependOnInheritedWidgetOfExactType() as Provider;
    return provider.sketch;
  }
}
