/*
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {
  final String? playStoreUrl;
  UpdateScreen({required this.playStoreUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: AlertDialog(
            title: Text("Update App to Continue"),
            content: Text(
              "Kindly update the Application from PlayStore to continue using it.\nThank You.",
              textAlign: TextAlign.left,
            ),
            actions: [
              GFButton(
                onPressed: () {
                  launch(playStoreUrl!);
                },
                text: "Update Now",
                shape: GFButtonShape.standard,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
