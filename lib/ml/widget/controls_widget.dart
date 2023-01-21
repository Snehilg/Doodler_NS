/*
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';

class ControlsWidget extends StatelessWidget {
  final VoidCallback onClickedPickImage;
  final VoidCallback onClickedScanText;
  //final VoidCallback onClickedClear;
  //final VoidCallback onClickedRead;

  const ControlsWidget({
    required this.onClickedPickImage,
    required this.onClickedScanText,
    // @required this.onClickedClear,
    // @required this.onClickedRead,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GFButton(
            shape: GFButtonShape.pills,
            color: Colors.amber,
            onPressed: onClickedPickImage,
            child: Text('1. Pick Image'),
          ),
          const SizedBox(width: 12),
          GFButton(
            shape: GFButtonShape.pills,
            color: Colors.amber,
            onPressed: onClickedScanText,
            child: Text('2. Scan For Text'),
          ),
          // const SizedBox(width: 12),
          // RaisedButton(
          //   onPressed: onClickedClear,
          //   child: Text('Clear'),
          // ),
          // const SizedBox(width: 12),
          // RaisedButton(
          //   onPressed: onClickedRead,
          //   child: Text('Read'),
          // )
        ],
      );
}
*/
