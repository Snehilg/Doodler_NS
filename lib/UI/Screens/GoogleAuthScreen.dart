import 'package:doodler/Bloc/userBloc.dart';
import 'package:doodler/Bloc/userEvent.dart';
import 'package:doodler/UI/Screens/EmailAuthScreen.dart';
import 'package:doodler/UI/Screens/PreDashboardScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as _auth;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Dashboard.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late UserBloc _userBloc;

  final _auth.FirebaseAuth _firebaseAuth = _auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<_auth.UserCredential> _signInGoogle(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Sign In'),
    ));

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final _auth.AuthCredential authCredential =
        _auth.GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

    _auth.UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(authCredential);

    return userCredential;
  }

  @override
  void didChangeDependencies() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.network(
              "https://images.pexels.com/photos/259915/pexels-photo-259915.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
              fit: BoxFit.fill,
              color: Color.fromRGBO(255, 255, 255, 0.6),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                /*shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),*/
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith((states) {
                  // If the button is pressed, return green, otherwise blue
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.red;
                  }
                  return Colors.yellow;
                })),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.signInAlt),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Email Sign In.",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailSignInPage(),
                      ));
                },
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                /* shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),*/
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith((states) {
                  // If the button is pressed, return green, otherwise blue
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.red;
                  }
                  return Colors.yellow;
                })),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.google),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
                onPressed: () => _signInGoogle(context).then((user) {
                  int count = 0;

                  print(_firebaseAuth.currentUser!.uid);

                  _userBloc.userEventSink
                      .add(FetchUser(userID: _firebaseAuth.currentUser!.uid));

                  _userBloc.userDataStream.listen((childUser) {
//                    print(childUser);
                    if (count == 0) {
                      Navigator.of(context).pop();
                      if (childUser.userId == "None") {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProfileScreen(
                              userID: _firebaseAuth.currentUser!.uid,
                            );
                          },
                        ));
                      } else {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return MyHomePage(
                              user: childUser,
                            );
                          },
                        ));
                      }

                      count = 1;
                    }
                  });
                }).catchError((e) => print(e)),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
