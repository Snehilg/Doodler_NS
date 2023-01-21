import 'package:doodler/Bloc/userBloc.dart';
import 'package:doodler/Bloc/userEvent.dart';
import 'package:doodler/Model/User.dart';
import 'package:doodler/UI/Authentication/welcomePage.dart';
import 'package:doodler/UI/Screens/PreDashboardScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'Dashboard.dart';

class RouteScreen extends StatefulWidget {
  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  late UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var getUser = auth.FirebaseAuth.instance.currentUser;
    if (getUser != null) {
      _userBloc.mapEventToState(FetchUser(userID: getUser.uid));
      return StreamBuilder<User>(
          stream: _userBloc.userDataStream,
          //                                        initialData: _storeBloc.getInitialRateList,
          builder: (context, snapshot) {
            print("LOG_snapshot" + snapshot.data.toString());
            if (snapshot.hasData) {
              User userData = snapshot.data!;
              if (userData.userId == "None") {
                return ProfileScreen(
                  userID: getUser.uid,
                );
              }
              return MyHomePage(
                user: userData,
              );
            } else {
              return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                  backgroundColor: Colors.white);
            }
          });
    } else {
      print("myUID" + getUser.toString());
      //return SignInPage();
      return WelcomePage();
      // return MyHomePage(
      //   user: null,
      // );
    }
  }
}
