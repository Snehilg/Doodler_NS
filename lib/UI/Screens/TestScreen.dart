import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:doodler/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechTest extends StatefulWidget {
  final List<String> words, images;
  final String category, group;

  SpeechTest(
      {required this.words,
      required this.images,
      required this.category,
      required this.group});

  @override
  _SpeechTestState createState() => _SpeechTestState();
}

class _SpeechTestState extends State<SpeechTest> {
  List<String> mainList = [], mainListImages = [];

  List<int> scoreList = [];

  late FlutterTts flutterTts;

  final SpeechToText speech = SpeechToText();

  final CarouselController _controller = CarouselController();

  String _currentLocaleId = "";

//  List<LocaleName> _localeNames = [];
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  bool _hasSpeech = false;
  bool _changeIcon = false;
  bool _bindIsRun = false;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  double level = 0.0;

  int? forItem;

  int newScore = 0;

  void setTts() async {
    flutterTts = FlutterTts();
    await flutterTts.isLanguageAvailable("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    print(
        "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

  Future<void> initSpeechState() async {
    final SpeechToText speech = SpeechToText();
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
//      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale!.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final SpeechToText speech = SpeechToText();
    setTts();
    initSpeechState();

    widget.words.forEach((word) {
      scoreList.add(0);
      mainList.add(word);
    });

    widget.images.forEach((image) {
      mainListImages.add(image);
    });

//    _speak(mainList[0]);
  }

  Future _speak(text) async {
    await flutterTts.speak(text);
  }

  Future _stop() async {
    await flutterTts.stop();
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
//    print("lastWords:" + lastWords);
    setState(() {
      lastWords = "${result.recognizedWords}";
    });
    if (!speech.isListening) {
      _changeIcon = true;
    }
    // - ${result.finalResult}
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    //print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  Widget getWidget(item) {
    return Image.network(
      mainListImages[mainList.indexOf(item)],
    );
  }

  Widget getWidgetForList(item) {
    return Image.network(
      mainListImages[mainListImages.indexOf(item)],
      fit: BoxFit.fill,
      width: 60,
      height: 60,
    );
  }

  Widget getIcon(item) {
    _changeIcon = false;

//    print("lastWords:" + lastWords + " " + "item:" + item);
    if (lastWords == "") {
      return Center(child: Text("🔵"));
    } else if (widget.group == "Alphabets" &&
        ((widget.category.toLowerCase() + " for " + item.toLowerCase()) ==
                lastWords.toLowerCase() ||
            item.toLowerCase() == lastWords.toLowerCase())) {
      //Alphabets
      scoreList[mainList.indexOf(item)] = 1;
      scoreFun();
      return Center(child: Text("✔️"));
    } else if (widget.group != "Alphabets" &&
        item.toLowerCase() == lastWords.toLowerCase()) {
      scoreList[mainList.indexOf(item)] = 1;
      scoreFun();
      return Center(child: Text("✔️"));
    } else {
      return Center(child: Text("❌"));
    }
  }

  List<Widget> cardsTemplate() {
    return (mainList
        .map((item) => Builder(builder: (context) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: getWidget(item),
//                        color:Colors.white,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
//                  color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.record_voice_over,
                              color: Colors.white),
                          style: ButtonStyle(backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            // If the button is pressed, return green, otherwise blue
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.red;
                            }
                            return Colors.black;
                          })),
                          onPressed: () {
                            if (widget.group != "Alphabets") {
                              _speak(item);
                            } else {
                              _speak(widget.category + " for " + item);
                            }
                          },
                          label: Text(
                            'Spell',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text("Result",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: _changeIcon &&
                                          forItem == mainList.indexOf(item)
                                      ? getIcon(item)
                                      : Center(child: Text("🔵")),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: .26,
                              spreadRadius: forItem == mainList.indexOf(item)
                                  ? level * 1.5
                                  : 0,
                              color: Colors.black.withOpacity(.05))
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: IconButton(
                          icon: Icon(Icons.mic),
                          onPressed: () {
                            forItem = mainList.indexOf(item);
                            if (_hasSpeech || !speech.isListening)
                              startListening();
                          }),
                    ),
                  ],
                ),
              );
            }))
        .toList());
  }

  List<Widget> scrollListTemplate() {
    return (mainListImages
        .map((item) => Builder(
              builder: (context) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      _controller.animateToPage(mainListImages.indexOf(item));
                    },
                    child: getWidgetForList(item),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                );
              },
            ))
        .toList());
  }

  void scoreFun() {
    int score = 0;
    for (int i = 0; i < mainList.length; i++) {
      if (scoreList[i] == 1) {
        score++;
      }
    }
    if (!_bindIsRun) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          newScore = score;
          _changeIcon = true;
          _bindIsRun = true;
          if (speechTotalScore < newScore) {
            speechTotalScore = newScore;
            speechScore();
          }
        });
      });
    } else {
      _bindIsRun = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Test';
    final total = mainList.length;
    return Scaffold(
      //drawer: new MainDrawer(),
      appBar: AppBar(
        title: Text(
          title + "     Score $newScore/$total",
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
                colors: [Colors.green, Colors.yellow],
              ),
            ),
            child: Column(
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                      height: MediaQuery.of(context).size.height - 165,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        _stop();
//                              _speak(mainList[index]);
                      }),
                  items: cardsTemplate(),
                  carouselController: _controller,
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: scrollListTemplate()),
                )
              ],
            )),
      ),
      backgroundColor: Colors.lightGreenAccent,
    );
  }
}
