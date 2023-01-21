//import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:doodler/Bloc/dataBloc.dart';
import 'package:doodler/Bloc/dataEvent.dart';
import 'package:doodler/Model/User.dart';
import 'package:doodler/UI/Contest/ContestScreen.dart';
import 'package:doodler/UI/Screens/BoardScreen.dart';
import 'package:doodler/UI/Screens/ParentScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../../globals.dart';
import 'CategoryGridScreen.dart';

class MyHomePage extends StatefulWidget {
  final User? user;

  const MyHomePage({Key? key, this.user}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FlutterTts flutterTts;
  late AudioPlayer advancedPlayer;
  AudioCache? audioCache;

  late List<String> images;

  List<Color>? lessonColor;

  late DataBloc dataBloc;
  String levelImg = "images/showpieces/one.svg";
  int currentIndex = 1;
  @override
  void didChangeDependencies() {
    dataBloc = BlocProvider.of<DataBloc>(context);
    dataBloc.mapEventToState(FetchGroups());
    super.didChangeDependencies();
  }

  // List<Widget> getScreens(){
  //   return <Widget>[
  //     ListView(
  //       //                padding: const EdgeInsets.only(top: 8),
  //       children: generateList(groups),
  //     ),
  //
  //   ];
  // }
  void setTts() async {
    flutterTts = FlutterTts();
    await flutterTts.isLanguageAvailable("en-US");
    await flutterTts.setSpeechRate(0.8);
  }

  Future _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    setTts();
    advancedPlayer = AudioPlayer();
    //audioCache = AudioCache(fixedPlayer: advancedPlayer);

    if (widget.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.user!.audioPath != null && widget.user!.audioPath != "") {
          //print(1);
          //advancedPlayer.play(widget.user!.audioPath!, isLocal: true);
        } else if (widget.user!.childName != null &&
            widget.user!.childName != "") {
          //print(2);
          _speak("Welcome " + widget.user!.childName!);
        }
        //print(3);
      });
    } else {
      _speak("Welcome My Dear Friend!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, String>>(
        stream: dataBloc.groupsStream as Stream<Map<String, String>>?,
        //initialData: _storeBloc.getInitialRateList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> groups = snapshot.data!.keys.toList();
            images = snapshot.data!.values.toList();
            return Scaffold(
              backgroundColor: Colors.white,
              body: <Widget>[
                Container(
                    child: ContestScreen(
                  user: widget.user != null ? widget.user : null,
                )),
                Scaffold(
                    backgroundColor: Colors.amber,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      title: Text(
                          'Hiiii !!  ' +
                              (widget.user != null
                                  ? "${widget.user!.childName![0].toUpperCase()}${widget.user!.childName!.substring(1)}"
                                  : " Doodler !!"),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20.0,
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
                              height:
                                  MediaQuery.of(context).size.height - 200.0,
                              width: MediaQuery.of(context).size.width)),
                      GridView.count(
                          childAspectRatio: 1.0,
                          padding: EdgeInsets.all(16),
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          children: groups.map((
                            item,
                          ) {
                            return GestureDetector(
                              onTap: () {
//                          Navigator.of(context).pop();
                                if (staticContent.contains(item)) {
//                            if (item.contains("Musicals")) {
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                    builder: (context) =>
//                                        MyCategories(group: item),
//                                  ));
//                            } else
                                  {
                                    Navigator.pushNamed(context, '${item}');
                                  }
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MyCategories(group: item),
                                      ));
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, bottom: 5, top: 20),
                                child: Card(
                                  //color: data.colors,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    side: BorderSide(color: Colors.purple),
                                  ),

//("Super Hero");("Games");

                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.network(
                                          images[groups.indexOf(item)],
                                          width: 60.0,
                                          height: 60,
                                          fit: BoxFit.fill,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Lesson ${groups.indexOf(item) + 1}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5.0),
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList())
                    ])),
                Container(
                    child: BoardScreen(
                  user: widget.user,
                )),
                Container(
                  child: ParentScreen(
                    user: widget.user,
                  ),
                )
              ][currentIndex],
              bottomNavigationBar: BottomNavyBar(
                selectedIndex: currentIndex,
                showElevation: true,
                itemCornerRadius: 8,
                curve: Curves.easeInBack,
                onItemSelected: (index) => setState(() {
                  currentIndex = index;
                }),
                items: [
                  BottomNavyBarItem(
                    icon: Icon(Icons.event),
                    title: Text('Contests'),
                    activeColor: Colors.deepPurple,
                    textAlign: TextAlign.center,
                  ),
                  BottomNavyBarItem(
                    icon: Icon(Icons.child_care),
                    title: Text('Child'),
                    activeColor: Colors.deepPurple,
                    textAlign: TextAlign.center,
                  ),
                  BottomNavyBarItem(
                    icon: Icon(Icons.photo_library),
                    title: Text(
                      'Gallery',
                    ),
                    activeColor: Colors.deepPurple,
                    textAlign: TextAlign.center,
                  ),
                  BottomNavyBarItem(
                    icon: Icon(Icons.person),
                    title: Text('Parents'),
                    activeColor: Colors.deepPurple,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );

            /*  bottomNavigationBar: CurvedNavigationBar(
                    buttonBackgroundColor: Colors.white54,
                    color:Colors.white,
                    items: <Widget>[
                      Icon(Icons.event, size: 30),
                      Icon(Icons.child_care),
                      Icon(FlutterIcons.photo_library_mdi),
                      Icon(Icons.person, size: 30)
                    ],
                    onTap: (page) {
                      setState(() {
                        index = page;
                      });
                    }));*/
          } else {
            return Scaffold(
                body: Center(child: CircularProgressIndicator()),
                backgroundColor: Colors.white);
          }
        });
  }
}
