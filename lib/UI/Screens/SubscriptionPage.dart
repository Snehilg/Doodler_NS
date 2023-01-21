import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("Subscription"),
    ),
    body:
    Center(child: Text("More Elite features yet to come here (: !!!",
    style: TextStyle(color:Colors.grey,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,
    fontSize: 14.0),),)
      
    );
  }
}