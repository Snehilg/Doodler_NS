/*
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/shape/gf_button_shape.dart';

class ControlsWidgetAudio extends StatelessWidget {
  final VoidCallback onClickedClear;
  final VoidCallback onClickedRead;

  const ControlsWidgetAudio({
    required this.onClickedClear,
    required this.onClickedRead,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GFButton(
            shape: GFButtonShape.pills,
            color: Colors.amber,
            onPressed: onClickedClear,
            child: Text('4. Clear'),
          ),
          const SizedBox(width: 12),
          GFButton(
            shape: GFButtonShape.pills,
            color: Colors.amber,
            onPressed: onClickedRead,
            child: Text('3. Read'),
          )
        ],
      );
}
*/
