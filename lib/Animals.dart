//import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'UI/Screens/Dashboard.dart';
import 'globals.dart';

//import 'package:firebase_database/firebase_database.dart';
//import 'package:async/async.dart';

class AnimalSound extends StatefulWidget {
  @override
  _AnimalSoundState createState() => _AnimalSoundState();
}

class _AnimalSoundState extends State<AnimalSound> {
  List<String> imgList = [], AnimalName = [], AnimalVoice = [];

  late AudioPlayer advancedPlayer;
  AudioCache? audioCache;

  int lastIndex = 0;

  final CarouselController _controller = CarouselController();

//  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    // r
    super.initState();

    animalImgMap.forEach((k, v) {
      if (!AnimalName.contains(k)) AnimalName.add(k);
      if (!imgList.contains(v)) imgList.add(v);
    });

    animalVoiceMap.forEach((k, v) {
      if (!AnimalVoice.contains(v))
        AnimalVoice.insert(AnimalName.indexOf(k), v);
    });
//    imgList = [
//      'bear.jpg',
//      'cat.jpg',
//      'dog.jpg',
//      'horse.jpg',
//      'monkey.jpg',
//      'peacock.jpg',
//      'rooster.jpg',
//      'tiger.jpg'
//    ];
//    AnimalName = [
//      'Bear',
//      'Cat',
//      'Dog',
//      'Horse',
//      'Monkey',
//      'Peacock',
//      'Rooster',
//      'Tiger'
//    ];
//    AnimalVoice = [
//      'bear.wav',
//      'cat.wav',
//      'dog.wav',
//      'horse.wav',
//      'monkey.wav',
//      'peacock.wav',
//      'rooster.wav',
//      'tiger.wav'
//    ];

    advancedPlayer = AudioPlayer();
    //audioCache = AudioCache(fixedPlayer: advancedPlayer);

//    audioCache.play(AnimalVoice[0]);
    //advancedPlayer.play(AnimalVoice[0], isLocal: false);
  }

  List<Widget> CardsTemplate() {
    return (imgList
        .map((item) => Builder(builder: (context) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Image.network(item),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          AnimalName[imgList.indexOf(item)],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      color: Colors.black87,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.record_voice_over, color: Colors.white),
                      style: ButtonStyle(
                          //Todo
                          // backgroundColor: MaterialStateColor.resolveWith((states) => Color(Colors.black))
                          ),

                      onPressed: () async {
                        advancedPlayer.stop();
                        String voice = AnimalVoice[imgList.indexOf(item)];
//                        advancedPlayer.setUrl(voice);
                        // await advancedPlayer.play(voice, isLocal: false);

                        if (animalsScoreList[imgList.indexOf(item)] != '1') {
                          animalsTotalScore++;
                          animalsScoreList[imgList.indexOf(item)] = '1';
                          animalsScore();
                        }
                      },
                      label: Text(
                        'Voice',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      //  icon: Icon(Icons.record_voice_over),
                      //  backgroundColor: Colors.black87,
                      //shape: RoundedRectangleBorder(),
                    ),
                  ],
                ),
              );
            }))
        .toList());
  }

  List<Widget> ScrollListTemplate() {
    return (imgList
        .map((item) => Builder(
              builder: (context) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      _controller.animateToPage(imgList.indexOf(item));
                      setState(() {
                        lastIndex = imgList.indexOf(item);
                      });
                    },
                    child: Image.network(item, fit: BoxFit.fill, width: 60),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                );
              },
            ))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Animal Voices';
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ));
        } as Future<bool> Function()?,
        child: MaterialApp(
            title: title,
            home: Builder(builder: (context) {
              return Scaffold(
                //drawer: new MainDrawer(),
                appBar: AppBar(
                  title: Text(
                    title,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 30,
                        fontStyle: FontStyle.italic),
                  ),
                  //backgroundColor: Colors.lightGreen,
                  centerTitle: true,
                ),
                body: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.lightBlue, Colors.lightGreen],
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                              height: MediaQuery.of(context).size.height - 161,
                              autoPlay: false,
                              //                          aspectRatio: 0.8,
                              //                      viewportFraction: 1.0,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) async {
                                if (reason !=
                                        CarouselPageChangedReason.controller ||
                                    index == lastIndex) {
//                                      print(index);
                                  advancedPlayer.stop();
                                  String voice = AnimalVoice[index];
                                  /*await advancedPlayer.play(voice,
                                      isLocal: false);*/
//                                      advancedPlayer.setUrl(voice);
                                }
//                                print(index);
//                                print(reason);
                              }),
                          items: CardsTemplate(),
                          carouselController: _controller,
                        ),
                        Container(
                          height: 60,
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: ScrollListTemplate()),
                        )
                      ],
                    ),
                  ),
                ),
                backgroundColor: Colors.lightGreenAccent,
              );
            })));
  }
}
