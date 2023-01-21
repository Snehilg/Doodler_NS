//import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class DrumPad extends StatefulWidget {
  @override
  _RunAppState createState() => _RunAppState();
}

class _RunAppState extends State<DrumPad> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  void PlaySound(int number) async {
    assetsAudioPlayer.stop();

    assetsAudioPlayer.open(
      Audio("assets/$number.mp3"),
    );
    assetsAudioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            color: Colors.amber),
        Positioned(
            top: 75.0,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45.0),
                      topRight: Radius.circular(45.0),
                    ),
                    color: Colors.white),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      child: Image(
                        image: AssetImage("images/orange.png"),
                      ),
                      onPressed: () async {
                        PlaySound(1);
                        /* assetsAudioPlayer.open(
                          Audio("assets/1.mp3"),
                        );
                        assetsAudioPlayer.play();*/
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Image(
                        image: AssetImage("images/brown.png"),
                      ),
                      onPressed: () {
                        PlaySound(2);
                        //final player = AudioCache();
                        //player.play('2.mp3');
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Image(
                        image: AssetImage("images/purple.png"),
                      ),
                      onPressed: () {
                        PlaySound(3);
                        //final //player = AudioCache();
                        //player.play('3.mp3');
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      child: Image(
                        image: AssetImage("images/brown.png"),
                      ),
                      onPressed: () {
                        PlaySound(4);
                        //final //player = AudioCache();
                        //player.play('4.mp3');
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Image(
                        image: AssetImage("images/purple.png"),
                      ),
                      onPressed: () {
                        PlaySound(5);
                        //final //player = AudioCache();
                        //player.play('5.mp3');
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Image(
                        image: AssetImage("images/orange.png"),
                      ),
                      onPressed: () {
                        PlaySound(6);
                        //final //player = AudioCache();
                        //player.play('6.mp3');
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      child: Image(
                        image: AssetImage("images/purple.png"),
                      ),
                      onPressed: () {
                        PlaySound(7);
                        //final //player = AudioCache();
                        //player.play('7.mp3');
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Image(
                        image: AssetImage("images/brown.png"),
                      ),
                      onPressed: () {
                        PlaySound(8);
                        //final //player = AudioCache();
                        //player.play('8.mp3');
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Image(
                        image: AssetImage("images/orange.png"),
                      ),
                      onPressed: () {
                        PlaySound(9);
                        //final //player = AudioCache();
                        //player.play('9.mp3');
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(),
            ),
          ],
        ),
      ],
    );
  }
}
