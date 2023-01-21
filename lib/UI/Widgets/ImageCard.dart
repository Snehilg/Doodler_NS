import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String item;

  ImageCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            color: Colors.cyan[100],
            shadowColor: Colors.amber,
            elevation: 10.0,
            child: Image.network(
              item,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
