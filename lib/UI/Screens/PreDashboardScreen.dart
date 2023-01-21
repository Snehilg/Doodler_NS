import 'dart:async';
import 'dart:io';

import 'package:doodler/Bloc/userBloc.dart';
import 'package:doodler/Bloc/userEvent.dart';
import 'package:doodler/Model/User.dart';
import 'package:doodler/UI/Screens/Dashboard.dart';
import 'package:file/local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
//import 'package:getflutter/components/button/gf_button.dart';
//import 'package:getflutter/shape/gf_button_shape.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final String userID;
  final LocalFileSystem localFileSystem;

  ProfileScreen({required this.userID, localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserBloc _userBloc;
  User? user;

  File? _image;

  late FlutterAudioRecorder2 _recorder;
  late Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool audioGiven = false;
  bool recordingStarted = false;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  List<String> _genderList = ['Male', 'Female', 'Don\'t Ask'];

  String? _childName = "";
  String? _guardianName = "";
  int? _age;
  String? _gender = "";

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  void didChangeDependencies() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.didChangeDependencies();
  }

  _init() async {
    /* try {
      if (await FlutterAudioRecorder2.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }*/
  }

  _start() async {
    try {
      await _recorder.start();
      recordingStarted = true;
      var recording = await _recorder.current(channel: 0);
      setState(() {
        // _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          //_current = current;
          //_currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  /* _stop() async {
    var result = await _recorder.stop();
    recordingStarted = false;
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }*/

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start Recording';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Saved';
          break;
        }
      default:
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Profile",
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.cyan[100],
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: _image == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo),
                                      Text("Upload Image")
                                    ],
                                  ),
                                )
                              : Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Image.file(
                                      _image!,
                                      fit: BoxFit.fill,
                                    ),
                                    Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new TextButton(
                                onPressed: () {
                                  switch (_currentStatus) {
                                    case RecordingStatus.Initialized:
                                      {
                                        _start();
                                        break;
                                      }
                                    case RecordingStatus.Recording:
                                      {
                                        _pause();
                                        break;
                                      }
                                    case RecordingStatus.Paused:
                                      {
                                        _resume();
                                        break;
                                      }
                                    case RecordingStatus.Stopped:
                                      {
                                        _init();
                                        break;
                                      }
                                    default:
                                      break;
                                  }
                                },
                                child: _buildText(_currentStatus),
                                style: ButtonStyle(backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  // If the button is pressed, return green, otherwise blue
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.green;
                                  }
                                  return Colors.lightBlue;
                                })),
                              ),
                            ),
                          ),
                          Flexible(
                            child: TextButton(
                              onPressed: () {
                                if (_currentStatus != RecordingStatus.Unset)
                                  //_stop();
                                  audioGiven = true;
                              },
                              child: new Text("Stop Recording",
                                  style: TextStyle(color: Colors.white)),
                              style: ButtonStyle(backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                // If the button is pressed, return green, otherwise blue
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.green;
                                }
                                return Colors.lightBlue.withOpacity(0.5);
                              })),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Child Name'),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter child name!!';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _childName = value;
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Child Age',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Enter child age!!';
                        } else if ((int.tryParse(value) == null)) {
                          return 'Enter valid number!!';
                        } else if (int.tryParse(value)! < 0) {
                          return 'Enter correct age value!!';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _age = int.tryParse(value!);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
//                decoration: InputDecoration(labelText: 'Original Price'),
                      items: _genderList
                          .map((eachValue) => DropdownMenuItem(
                                child: Text(eachValue),
                                value: eachValue,
                              ))
                          .toList(),
                      onChanged: (dynamic newValue) {
                        setState(() {
                          _gender = newValue;
                        });
                      },
                      validator: (String? value) {
                        if (_gender == "") {
                          return 'Select a gender of child!!';
                        }
                        return null;
                      },
//                value: _scale,
                      isExpanded: false,
                      hint: Text('Child Gender'),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Name of guardian(optional)'),
                  validator: (String? value) {
//                      if (value.isEmpty) {
//                        return 'Please enter some name!!';
//                      }
                    return null;
                  },
                  onSaved: (String? value) {
                    if (value == null) value = "";
                    _guardianName = value;
                  },
                ),
              ),
              Expanded(
                  child: Text(
                      "The App will speak out the Kid's name  or you can record your audio to be played whenever the app starts .")),
//              SizedBox(height: 50,),
              ElevatedButton(
                /* shape: GFButtonShape.pills,
                blockButton: true,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                color: Colors.amber,*/
                child: Text(
                  "Submit",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  // if (_image == null) {
                  //   showDialog(
                  //     context: context,
                  //     builder: (context) => AlertDialog(
                  //       title: Text('Alert!!'),
                  //       content: Text('Pick Image of Child.'),
                  //       actions: <Widget>[
                  //         GestureDetector(
                  //           onTap: () => Navigator.of(context).pop(true),
                  //           child: Container(
                  //               margin: EdgeInsets.symmetric(
                  //                   vertical: 10, horizontal: 20),
                  //               child: Text(
                  //                 "OK",
                  //                 style: TextStyle(
                  //                     color: Colors.green,
                  //                     fontSize: 20,
                  //                     fontWeight: FontWeight.bold),
                  //               )),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  //   return;
                  // } else
                  if (recordingStarted == true) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Alert!!'),
                        content:
                            Text('Please stop recording before submission.'),
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(true),
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  _formKey.currentState!.save();
                  print(_image);
                  print(_childName);
                  print(_age);
                  print(_gender);
                  print(_guardianName);
                  print(_current.path);
                  User newUser = User(
                    userId: widget.userID,
                    childName: _childName,
                    childAge: _age ?? 0,
                    guardianName: _guardianName,
                    gender: _gender,
                    currentLevel: 1,
                    // completedLessonsNumbers: [],
                    phoneNumber: 0,
                    audioPath: audioGiven ? (_current.path ?? "") : "",
                    // sketches: {}
                  );
                  _userBloc.userEventSink
                      .add(AddUser(user: newUser, file: _image));
                  //Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return MyHomePage(
                        user: newUser,
                      );
                    },
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
