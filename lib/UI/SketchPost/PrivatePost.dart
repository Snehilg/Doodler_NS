import 'dart:io';

import 'package:doodler/Bloc/SketchBloc.dart';
import 'package:doodler/Bloc/SketchEvent.dart';
import 'package:doodler/Model/Sketch.dart';
import 'package:doodler/Model/User.dart';
import 'package:doodler/UI/Authentication/welcomePage.dart';
import 'package:doodler/UI/SketchPost/commentPage%20copy.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PrivatePost extends StatefulWidget {
  final User? userData;
  PrivatePost({this.userData});
  @override
  _PrivatePostState createState() => _PrivatePostState();
}

class _PrivatePostState extends State<PrivatePost> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int index = 0;
  List<bool> _likes = [true, false];

  late SketchBloc _sketchBloc;
  void didChangeDependencies() {
    _sketchBloc = BlocProvider.of<SketchBloc>(context);
    _sketchBloc.sketchEventSink.add(FetchPrivateSketches(
        userId: widget.userData != null
            ? auth.FirebaseAuth.instance.currentUser!.uid
            : null));
    super.didChangeDependencies();
  }

  TextEditingController textEditingController = TextEditingController();

  File? file;
  Future galleryImage() async {
    // Navigator.pop(context);
    PickedFile? image = (await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 600, maxWidth: 700));
    //cropImage(image!.path);
  }

  Future cameraImage() async {
    // Navigator.pop(context);
    PickedFile? image = (await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 600, maxWidth: 700));
    //cropImage(image!.path);
  }

  /* Future cropImage(imagePath) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: false,
          showCropGrid: true,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )) as File;
    setState(() {
      file = croppedFile;
    });
  }*/

  takeImage(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                  child: Text('select image from gallery',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600)),
                  onPressed: () async {
                    await galleryImage();
                    Navigator.of(context).pop();
                  }),
              SimpleDialogOption(
                  child: Text('select image from camera',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0)),
                  onPressed: () async {
                    await cameraImage();
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: widget.userData != null
            ? Container(
                padding: EdgeInsets.all(0.0),
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<List<Sketch>?>(
                  stream: _sketchBloc.sketchesDataStream,
                  //initialData: _sketchBloc.allPrivateSketches,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error"),
                        );
                      } else {
                        return Scrollbar(
                            child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i) {
                            if (snapshot.data![i].delete == "") {
                              return Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0, top: 20.0),
                                      child: Row(children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.amber,
                                          backgroundImage: NetworkImage(snapshot
                                                      .data![i].userPhoto ==
                                                  null
                                              ? ""
                                              : snapshot.data![i].userPhoto!),

                                          // backgroundImage:NetworkImage(widget.userData.photoPath),
                                          // backgroundColor: Colors.blue,
                                        ),
                                        SizedBox(width: 10.0),
                                        Text(
                                          "${snapshot.data![i].userName![0].toUpperCase()}${snapshot.data![i].userName!.substring(1)}",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Spacer(),
                                        Text(DateFormat.yMMMEd()
                                            .format(DateTime.now())
                                            .toString()),
                                        new PopupMenuButton(
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder: (_) =>
                                              <PopupMenuItem<String>>[
                                            new PopupMenuItem<String>(
                                                child: InkWell(
                                              child: ListTile(
                                                  leading: Icon(Icons.edit),
                                                  title: Text("Edit")),
                                              onTap: () {
                                                if (snapshot.data![i].userId ==
                                                    auth.FirebaseAuth.instance
                                                        .currentUser!.uid) {
                                                  displayDialog(context,
                                                      snapshot.data![i].docId);
                                                } else {
                                                  print("Hello");
                                                }
                                              },
                                            )),
                                            new PopupMenuItem<String>(
                                                child: InkWell(
                                              child: ListTile(
                                                  leading: Icon(Icons.delete),
                                                  title: Text("delete")),
                                              onTap: () {
                                                if (snapshot.data![i].userId ==
                                                    auth.FirebaseAuth.instance
                                                        .currentUser!.uid) {
                                                  _sketchBloc.sketchEventSink
                                                      .add(DeleteSketches(
                                                          docId: snapshot
                                                              .data![i].docId,
                                                          delete: "deleted"));
                                                } else {
                                                  print("hello");
                                                }
                                              },
                                            ))
                                          ],
                                        ),
                                      ])),
                                  SizedBox(height: 5.0),
                                  Container(
                                      child: snapshot.data![i].url != null
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: AspectRatio(
                                                aspectRatio: 16 / 12,
                                                child: Image.network(
                                                  snapshot.data![i].url!,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ))
                                          : SizedBox(
                                              height: 5.0,
                                            )),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 15.0, right: 15.0, top: 10.0),
                                    child: Row(children: [
                                      GestureDetector(
                                        child: Icon(
                                          Icons.favorite,
                                          size: 30.0,
                                          color: _likes[index]
                                              ? Colors.red
                                              : Colors.red,
                                        ),
                                        onTap: () {
                                          Likes likes = Likes(
                                              userId: auth.FirebaseAuth.instance
                                                  .currentUser!.uid);
                                          _sketchBloc.sketchEventSink.add(
                                              AddLikes(
                                                  docId:
                                                      snapshot.data![i].docId,
                                                  likes: likes));
                                          setState(() {
                                            _likes[index] = true;
                                          });
                                        },
                                        onDoubleTap: () {
                                          setState(() {
                                            _likes[index] = false;
                                          });
                                          Likes likes = Likes(
                                              userId: auth.FirebaseAuth.instance
                                                  .currentUser!.uid);
                                          _sketchBloc.sketchEventSink.add(
                                              RemoveLikes(
                                                  docId:
                                                      snapshot.data![i].docId,
                                                  likes: likes));
                                        },
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      GestureDetector(
                                        child: Icon(
                                          Icons.chat_bubble_outline,
                                          size: 25.0,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommentPage(
                                                        user: widget.userData,
                                                        sketch:
                                                            snapshot.data![i],
                                                      )));
                                        },
                                      ),
                                      SizedBox(
                                        width: 180.0,
                                      ),
                                    ]),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: Text(
                                        "${snapshot.data![i].likes!.length.toString()} likes",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      )),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${snapshot.data![i].userName![0].toUpperCase()}${snapshot.data![i].userName!.substring(1)}",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text(
                                              snapshot.data![i].note == null
                                                  ? ""
                                                  : snapshot.data![i].note!,
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 15.0),
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  )
                                ],
                              ));
                            } else {
                              return Center(
                                child: Text(
                                  "Let's start adding your sketch here (: !!!",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0),
                                ),
                              );
                            }
                          },
                        ));
                      }
                    } else {
                      return Container();
                    }
                  },
                ))
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        //elevation: 5,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WelcomePage()));
                        },
                        child: Text("Sign up with us Today !"),
                        /*shape: GFButtonShape.pills,
                        blockButton: true,
                        color: Colors.amber,
                        textColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 30),*/
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Participate in Contests .",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Publish your SketchBoard to the world.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Post your articles in forums and tips.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Make New Friends .",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "All that for free !!!!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ));
  }

  Future<void> displayDialog(BuildContext context, String? docId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        takeImage(context);
                      },
                      child: Container(
                          child: file != null
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: AspectRatio(
                                    aspectRatio: 16 / 12,
                                    child: Image.file(
                                      file!,
                                      width: 100,
                                      height: 80,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ))
                              : Column(children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.add_photo_alternate,
                                      size: 40.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text("[ Add Image here ]",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[600]))
                                ])),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      height: 5 * 24.0,
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        controller: textEditingController,
                        validator: (value) => textEditingController.text.isEmpty
                            ? "description is required"
                            : null,
                        maxLines: 10,
                        decoration: InputDecoration(
                            labelText: 'Description ',
                            contentPadding: EdgeInsets.all(20.0),
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(
                              color: Theme.of(context).primaryColor,
                            )),
                            prefixIcon: Icon(Icons.add_comment,
                                color: Theme.of(context).primaryColor)),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('cancel')),
              TextButton(
                  onPressed: () async {
                    final form = formKey.currentState;
                    if (file != null) {
                      if (form!.validate()) {
                        _sketchBloc.sketchEventSink.add(UpdateSketch(
                            file: file,
                            docId: docId,
                            note: textEditingController.text));
                        textEditingController.clear();

                        Navigator.of(context).pop();
                      } else {
                        print("hello");
                      }
                    } else {
                      return alert(context);
                    }
                  },
                  child: Text('done'))
            ],
          );
        });
  }

  Future<void> alert(BuildContext context) {
    return showDialog(
        context: _scaffoldKey.currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please pick a image first !!"),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
