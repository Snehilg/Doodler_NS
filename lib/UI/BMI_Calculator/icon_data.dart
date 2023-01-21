import 'package:flutter/material.dart';

const labelTextStyle =  TextStyle(
            fontSize: 20.0,
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          );



class ReusableChildWidget extends StatelessWidget {
  ReusableChildWidget({required this.icon, required this.text});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          text,
          style: labelTextStyle,
        ),
      ],
    );
  }
}
