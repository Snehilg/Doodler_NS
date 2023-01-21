//import 'package:audioplayers/audio_cache.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../globals.dart';

class Xylophone extends StatefulWidget {
  @override
  _XylophoneState createState() => _XylophoneState();
}

class _XylophoneState extends State<Xylophone> {
  //static AudioCache player = AudioCache();
  //AudioPlayer player = AudioPlayer();
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: new MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Xylophone',
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
      backgroundColor: Colors.blueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          BuildKey(Colors.red, 1),
          BuildKey(Colors.lightGreenAccent, 2),
          BuildKey(Colors.green, 3),
          BuildKey(Colors.yellow, 4),
          BuildKey(Colors.purple, 5),
          BuildKey(Colors.orangeAccent, 6),
          BuildKey(Colors.blueAccent, 7),
        ],
      ),
    );
  }

  void PlaySound(int number) async {
    assetsAudioPlayer.open(
      Audio("assets/xylophone/note$number.wav"),
    );
    assetsAudioPlayer.play();

    if (xyloScoreList[number - 1] != '1') {
      xyloTotalScore++;
      xyloScoreList[number - 1] = '1';
      xyloScore();
    }
  }

  Widget BuildKey(Color color, int number) {
    return Expanded(
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0) {
            // Right Swipe
            //print('drag right');
            PlaySound(number);
            // Sestivity is integer is used when you don't want to mess up vertical drag
          } else if (details.delta.dx < -0) {
            // print('drag down $number');
            PlaySound(number);
            //Left Swipe
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: EdgeInsets.all(10),
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.music_note),
              trailing: Icon(Icons.library_music),
              onTap: () => PlaySound(number),
            ),
          ),
        ),
      ),
    );
  }
}

/*
*     onPressed: () async {
                              String audioasset = "assets/audio/ambulance_sound.mp3";
                              ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
                              Uint8List  soundbytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
                              int result = await player.playBytes(soundbytes);
                              if(result == 1){ //play success
                                  print("Sound playing successful.");
                              }else{
                                  print("Error while playing sound.");
                              }
                      },
*
* */
