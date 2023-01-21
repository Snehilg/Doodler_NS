import 'package:doodler/Animals.dart';
import 'package:doodler/Bloc/ContestBloc.dart';
import 'package:doodler/Bloc/ParentingTipsBloc.dart';
import 'package:doodler/Bloc/SellBloc.dart';
import 'package:doodler/Bloc/SketchBloc.dart';
import 'package:doodler/Bloc/forumBloc.dart';
import 'package:doodler/Model/Sketch.dart';
import 'package:doodler/UI/CardGame/Card_Home.dart';
import 'package:doodler/UI/ColorMatching.dart';
import 'package:doodler/UI/Musical/Xylophone.dart';
import 'package:doodler/UI/Quiz/screens/input_screen.dart';
import 'package:doodler/UI/Screens/AllCountries.dart';
import 'package:doodler/UI/Screens/Dashboard.dart';
import 'package:doodler/UI/Screens/Dice.dart';
import 'package:doodler/UI/Screens/NumberQuiz.dart';
import 'package:doodler/UI/Screens/Numbers.dart';
import 'package:doodler/globals.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:splashscreen/splashscreen.dart';

import 'Bloc/dataBloc.dart';
import 'Bloc/userBloc.dart';
import 'Services/firebaseCrashlytics.dart';
import 'UI/BMI_Calculator/input_page.dart';
import 'UI/Musical/DrumPad.dart';
import 'UI/Screens/Country.dart';
import 'UI/Screens/countryMap.dart';
import 'UI/Screens/superheromainscreen.dart';
import 'UI/SketchBoard.dart';
//import 'UI/Tetris/app.dart';
import 'UI/TicTakToe/HomePage.dart';

int? buildNumber;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '6LdV08kjAAAAAFQKoHMinV8enGMg2Xp6_3Nsm2Yn',
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. debug provider
    // 2. safety net provider
    // 3. play integrity provider
    androidProvider: AndroidProvider.debug,
  );
  /*var remoteConfigService = await RemoteConfigService.getInstance();
  await remoteConfigService!.initialize();*/
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  /*var remoteConfigService = await (RemoteConfigService.getInstance()
      as FutureOr<RemoteConfigService>);
  await remoteConfigService.initialize();*/
  FirebaseCrashlytics.initialize();

  /* PushNotificationsManager pushNotificationManager =
      new PushNotificationsManager();
  pushNotificationManager.init();*/

  /*await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    buildNumber = int.parse(packageInfo.buildNumber);
  });*/

  runApp(
    Splash(),
  );
}

class Splash extends StatelessWidget {
  //final remoteConfigService;
  Splash();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new EasySplashScreen(
        durationInSeconds: 4,
        navigator: new MyAppLaunch(),
        title: new Text(
          'Doodler - eLearning',
          style: GoogleFonts.arizonia(
            fontSize: 32,
            letterSpacing: 5,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        logo: Image(
          image: AssetImage("images/logo.png"),
        ),
        backgroundColor: Colors.white,
        //photoSize: 150.0,
        gradientBackground: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amber[300]!, Colors.deepOrange]),
      ),
    );
  }
}

class MyAppLaunch extends StatelessWidget {
  final Sketch? sketch;
  //final remoteConfigService;
  MyAppLaunch({this.sketch});
  @override
  Widget build(BuildContext context) {
    // if (remoteConfigService.forceUpdateRequiredStore) {
    //  if (remoteConfigService.forceUpdateCurrentVersionStore > buildNumber) {
    // print('Update Required');
    return MaterialApp(
      title: 'Doodler',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.black54,
        ),
        primaryIconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      home: resume(),
      /* home: UpdateScreen(
            playStoreUrl: remoteConfigService.forceUpdateStoreUrlStore,
          ),*/
    );
    /* } else {
        return resume();
      }
    } else {
      return resume();
    }*/
  }

  resume() {
    return BlocProvider<DataBloc>(
        bloc: DataBloc(),
        child: BlocProvider<UserBloc>(
            bloc: UserBloc(),
            child: BlocProvider<SketchBloc>(
                bloc: SketchBloc(),
                child: BlocProvider<ContestBloc>(
                    bloc: ContestBloc(),
                    child: BlocProvider<ForumBloc>(
                        bloc: ForumBloc(),
                        child: BlocProvider<ProductBloc>(
                          bloc: ProductBloc(),
                          child: BlocProvider<ParentingBloc>(
                            bloc: ParentingBloc(),
                            child: MaterialApp(
                              title: 'Doodler e-Learning',
                              theme: ThemeData(
                                primarySwatch: primaryColor as MaterialColor?,
                              ),

//      home: Scaffold(appBar: AppBar(), body: ImageCard()),
                              home: FutureBuilder(
                                // Initialize FlutterFire
                                future: Firebase.initializeApp(),
                                builder: (context, snapshot) {
                                  // Check for errors
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text("Error:" +
                                          (snapshot.error as String)),
                                    );
                                  }

                                  // Once complete, show your application
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    //return RouteScreen();
                                    return MyHomePage();
                                  }

                                  // Otherwise, show something whilst waiting for initialization to complete
                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                              routes: {
                                'AnimalsName': (context) => AnimalSound(),
                                'SketchBoard': (context) => SignApp(),
                                'Xylophone': (context) => Xylophone(),
                                'DrumPad': (context) => DrumPad(),
                                'BMI Calculator': (context) => InputPage(),
                                'Tic Tac Toe': (context) => TikTakToe(),
                                'Dice Roll': (context) => MyDice(),
                                //'Tetris': (context) => TetrisApp(),
                                'Quiz': (context) => InputScreen(),
                                'Fun Facts': (context) =>
                                    NumberHomePage(title: 'Fun with Numbers'),
                                "Countries": (context) => AllCountries(),
                                "Numbers": (context) => Numbers(),
                                "Super Hero": (context) => MainScreen(),
                                "Memory Cards": (context) => Card_Home(),
                                "Color Matching": (context) => ColorMatching(),
                                CountryMap.routeName: (ctx) => CountryMap(),
                                Country.routeName: (ctx) => Country(),
                                //"Read Out Loud": (context) => TextMLApp()
                              },
                            ),
                          ),
                        ))))));
  }
}
