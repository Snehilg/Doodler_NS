import 'package:flutter/material.dart';

class BottomScrollList extends StatelessWidget {

  final String item;

  BottomScrollList({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.18,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.18,
      child: Card(
        color: Colors.cyan[100],
        shadowColor: Colors.amber,
        elevation: 10.0,
        child: Image.network(
          item,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

