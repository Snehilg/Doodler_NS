import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:doodler/Bloc/dataBloc.dart';
import 'package:doodler/Bloc/dataEvent.dart';
import 'package:doodler/UI/Screens/TestScreen.dart';
import 'package:doodler/UI/Widgets/BottomScrollList.dart';
import 'package:doodler/UI/Widgets/ImageCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class HomeScreen extends StatefulWidget {
//  final DataEvent event;
  final String title;
  final String group;

  HomeScreen({required this.title, required this.group});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DataBloc dataBloc;

  List<String> Word = [], Images = [];
  late FlutterTts flutterTts;

  int lastIndex = 0;

  final CarouselController _controller = CarouselController();

  void setTts() async {
    flutterTts = FlutterTts();
    await flutterTts.isLanguageAvailable("en-US");
    await flutterTts.setSpeechRate(0.7);
  }

  Future _speak(text) async {
    await flutterTts.speak(text);
  }

  Future _stop() async {
    await flutterTts.stop();
  }

  List<Widget> CardsTemplate() {
    return (Images.map((item) => Builder(builder: (context) {
          return Container(
              margin: EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                children: [
                  ImageCard(item: item),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        Word[Images.indexOf(item)],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        icon:
                            Icon(Icons.record_voice_over, color: Colors.white),
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
                            _speak(Word[Images.indexOf(item)]);
                          } else {
                            _speak(widget.title +
                                " for " +
                                Word[Images.indexOf(item)]);
                          }
                        },
                        label: Text(
                          'Spell',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        // icon: Icon(Icons.record_voice_over),
                        // backgroundColor: Colors.black87,
                        //shape: RoundedRectangleBorder(),
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.edit, color: Colors.white),
                        style: ButtonStyle(backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          // If the button is pressed, return green, otherwise blue
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.red;
                          }
                          return Colors.black;
                        })),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return SpeechTest(
                                words: Word,
                                images: Images,
                                category: widget.title,
                                group: widget.group,
                              );
                            },
                          ));
                        },
                        label: Text(
                          'Test',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        // icon: Icon(Icons.record_voice_over),
                        // backgroundColor: Colors.black87,
                        //shape: RoundedRectangleBorder(),
                      ),
                    ],
                  ),
                ],
              ));
        })).toList());
  }

  List<Widget> ScrollListTemplate() {
    return (Images.map((item) => Builder(
          builder: (context) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  _controller.animateToPage(Images.indexOf(item));
                  setState(() {
                    lastIndex = Images.indexOf(item);
                  });
                },
                child: BottomScrollList(item: item),
              ),
              margin: EdgeInsets.symmetric(horizontal: 5),
            );
          },
        )).toList());
  }

  @override
  void didChangeDependencies() {
    dataBloc = BlocProvider.of<DataBloc>(context);
    dataBloc.mapEventToState(FetchData(name: widget.title));
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTts();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, String>>(
        stream: dataBloc.dataStream as Stream<Map<String, String>>?,
//                                        initialData: _storeBloc.getInitialRateList,
        builder: (context, snapshot) {
          print("data stream" + dataBloc.dataStream.isEmpty.toString());
          if (snapshot.hasData) {
            Map<String, String> imagesUrl = snapshot.data!;

            Word = [];
            Images = [];

            imagesUrl.forEach((k, v) {
              if (!Word.contains(k)) Word.add(k);
              if (!Images.contains(v)) Images.add(v);
            });
//                        _speak(Word[0]);
            print(2);
            print(Word);
            print(Images);
            return Scaffold(
              // drawer: new MainDrawer(),
              appBar: AppBar(
                title: Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 30,
                      fontStyle: FontStyle.italic),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.apps),
                    color: Colors.blue,
                    onPressed: () {
//                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return SpeechTest(
                            words: Word,
                            images: Images,
                            category: widget.title,
                            group: widget.group,
                          );
                        },
                      ));
                    },
                  )
                ],
                // backgroundColor: Colors.blueAccent,
                centerTitle: true,
              ),
              body: SafeArea(
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.deepOrange,
                          Colors.yellow,
                          Colors.green
                        ],
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                              height: MediaQuery.of(context).size.height - 164,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                if (reason !=
                                        CarouselPageChangedReason.controller ||
                                    index == lastIndex) {
                                  _stop();
                                  if (widget.group != "Alphabets") {
                                    _speak(Word[index]);
                                  } else {
                                    _speak(
                                        widget.title + " for " + Word[index]);
                                  }
                                }
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
                    )),
              ),
              //  backgroundColor: Colors.lightGreenAccent,
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ],
                ),
              ),
            );
          } else {
            print("LOG SNAPSHOT" + snapshot.toString());
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}
