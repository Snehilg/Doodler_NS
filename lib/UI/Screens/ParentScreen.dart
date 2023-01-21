import 'package:doodler/Model/User.dart';
import 'package:doodler/UI/Authentication/welcomePage.dart';
import 'package:doodler/UI/Buy&Sell/ProductHome.dart';
import 'package:doodler/UI/ParentingTips/TipsHome.dart';
import 'package:doodler/UI/Screens/Forum.dart';
import 'package:doodler/UI/Screens/ProfilePage.dart';
import 'package:doodler/UI/Screens/SubscriptionPage.dart';
import 'package:firebase_auth/firebase_auth.dart' as _auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ParentScreen extends StatefulWidget {
  final User? user;
  ParentScreen({this.user});
  @override
  _ParentScreenState createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _auth.FirebaseAuth _firebaseAuth = _auth.FirebaseAuth.instance;

  Items item1 = new Items(
      title: "Forum", img: "assets/group-chat.png", colors: Colors.cyan);

  Items item2 = new Items(
      title: "Buy & Sell",
      img: "assets/bag.png",
      colors: Colors.deepPurple[300]);
  Items item3 = new Items(
      title: "Parenting tips",
      img: "assets/family.png",
      colors: Colors.orange[300]);
  Items item4 = new Items(
      title: "Subscription Plans",
      img: "assets/premium.png",
      colors: Colors.pinkAccent);
  Items item5 = new Items(
      title: "My Profile", img: "assets/user.png", colors: Colors.green);
  Items item6 =
      new Items(title: "Logout", img: "assets/logout.png", colors: Colors.blue);

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6];

    return Scaffold(
        backgroundColor: Color(0xFF7A9BEE),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("Hey ! " + "What are you  looking for ?",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  color: Colors.white)),
          centerTitle: true,
        ),
        body: Stack(children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent),
          Positioned(
              top: 75.0,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45.0),
                        topRight: Radius.circular(45.0),
                      ),
                      color: Colors.white),
                  height: MediaQuery.of(context).size.height - 200.0,
                  width: MediaQuery.of(context).size.width)),
          GridView.count(
              childAspectRatio: 1.0,
              padding: EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              children: myList.map((
                data,
              ) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, bottom: 5, top: 20),
                  child: Card(
                    color: data.colors,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(color: Colors.white),
                    ),
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        // ignore: unrelated_type_equality_checks
                        if (myList.indexOf(data) == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForumScreen(
                                        user: widget.user,
                                      )));
                        } else if (myList.indexOf(data) == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductHome(
                                        user: widget.user,
                                      )));
                        } else if (myList.indexOf(data) == 2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TipsHome(
                                        user: widget.user,
                                      )));
                        } else if (myList.indexOf(data) == 3) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubscriptionPage()));
                        } else if (myList.indexOf(data) == 4) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                        user: widget.user,
                                      )));
                        } else if (myList.indexOf(data) == 5) {
                          alert(context);
                        }
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              data.img!,
                              width: 50.0,
                              height: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data.title!,
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList())
        ]));
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomePage(),
          ));
    } catch (e) {
      print('Failed to signOut' + e.toString());
    }
  }

  Future<void> alert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              """
    Are you sure you want to logout ?""",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0),
            ),
            actions: [
              TextButton(
                child: Text("cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("done"),
                onPressed: () {
                  logout();
                },
              )
            ],
          );
        });
  }
}

class Items {
  String? title;
  String? img;
  Color? colors;
  Items({this.title, this.img, this.colors});
}
