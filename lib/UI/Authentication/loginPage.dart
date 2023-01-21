import 'package:doodler/Bloc/userBloc.dart';
import 'package:doodler/Bloc/userEvent.dart';
import 'package:doodler/UI/Screens/Dashboard.dart';
import 'package:doodler/UI/Screens/PreDashboardScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as _auth;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Authentication/signup.dart';
import 'Widget/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserBloc _userBloc;
  String? TextData;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _auth.FirebaseAuth _firebaseAuth = _auth.FirebaseAuth.instance;

  @override
  void didChangeDependencies() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.didChangeDependencies();
  }

  void _signIn(BuildContext context) async {
    try {
      final _auth.User? user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (user != null) {
        int count = 0;
        print(_firebaseAuth.currentUser!.uid);
        _userBloc.userEventSink
            .add(FetchUser(userID: _firebaseAuth.currentUser!.uid));
        _userBloc.userDataStream.listen((childUser) {
          if (count == 0) {
            _emailController.text = "";
            _passwordController.text = "";
//            print(childUser);

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
      } else {
//        Scaffold.of(context).showSnackBar(SnackBar(
//          content: Text("Error Occurred."),
//        ));
        setState(() {
          TextData = "Error Occoured !!!";
        });
        //_showToast(context, "Error Occurred.");
        print("LOG Error Occoured");
        Fluttertoast.showToast(
            msg: "Error Occurred.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (err) {
//      Scaffold.of(context).showSnackBar(SnackBar(
//        content: Text(err.toString().split(']')[1]),
//      ));
      setState(() {
        TextData = err.toString().split(']')[1];
      });
      // _showToast(context, err.toString().split(']')[1]);
      print("LOG" + err.toString().split(']')[1]);
      Fluttertoast.showToast(
          msg: err.toString().split(']')[1],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );

    this._showToast(context, text);
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () => _signIn(context),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

//        height: 50,
//        margin: EdgeInsets.symmetric(vertical: 20),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.all(Radius.circular(10)),
//        ),
//        child: Row(
//          children: <Widget>[
//            Expanded(
//              flex: 1,
//              child: Container(
//                decoration: BoxDecoration(
//                  color: Color(0xff1959a9),
//                  borderRadius: BorderRadius.only(
//                      bottomLeft: Radius.circular(5),
//                      topLeft: Radius.circular(5)),
//                ),
//                alignment: Alignment.center,
//                child: Text('g',
//                    style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 25,
//                        fontWeight: FontWeight.w400)),
//              ),
//            ),
//            Expanded(
//              flex: 5,
//              child: Container(
//                decoration: BoxDecoration(
//                  color: Color(0xff2872ba),
//                  borderRadius: BorderRadius.only(
//                      bottomRight: Radius.circular(5),
//                      topRight: Radius.circular(5)),
//                ),
//                alignment: Alignment.center,
//                child: Text('Log in with Facebook',
//                    style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 18,
//                        fontWeight: FontWeight.w400)),
//              ),
//            ),
//          ],
//        ),
//      ),

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Doodler',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.displayMedium!,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: ' eLearn',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'ing',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email id", _emailController),
        _entryField("Password", _passwordController, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  _submitButton(),
//                  Container(
//                    padding: EdgeInsets.symmetric(vertical: 10),
//                    alignment: Alignment.centerRight,
//                    child: Text('Forgot Password ?',
//                        style: TextStyle(
//                            fontSize: 14, fontWeight: FontWeight.w500)),
//                  ),
                  SizedBox(height: height * .055),
                  _createAccountLabel(),
                  SizedBox(height: height * .055),
                  //Text('${TextData}')
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}
