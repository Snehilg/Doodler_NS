import 'dart:io';

import 'package:doodler/Bloc/SketchBloc.dart';
import 'package:doodler/Bloc/SketchEvent.dart';
import 'package:doodler/Model/Sketch.dart';
import 'package:doodler/Model/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PostPage extends StatefulWidget {
  final User? user;
  final Sketch? sketch;
  PostPage({this.user, this.sketch});
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late SketchBloc _sketchBloc;
  String? downloadUrl;

  @override
  void didChangeDependencies() {
    _sketchBloc = BlocProvider.of<SketchBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
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

  /*Future cropImage(image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image,
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

  Future<void> addImageToFirebase() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    // Sketch
    Sketch sketch = new Sketch(
        note: textEditingController.text,
        date: formattedDate,
        userName: widget.user!.childName,
        userPhoto: widget.user!.photoPath,
        userId: auth.FirebaseAuth.instance.currentUser!.uid,
        delete: "",
        likes: [],
        comments: []);
    _sketchBloc.sketchEventSink.add(AddSketch(file: file, sketch: sketch));
  }

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

  displayUploadScreen() {
    return Container(
      color: Colors.orangeAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            color: Colors.grey,
            size: 50.0,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              /* shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.0),
              ),*/
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                // If the button is pressed, return green, otherwise blue
                if (states.contains(MaterialState.pressed)) {
                  return Colors.red;
                }
                return Colors.green;
              })),
              child: Text(
                'Upload image',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () {
                takeImage(context);
              },
            ),
          )
        ],
      ),
    );
  }

  displayUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Sketch ',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
              child: Text(
                'share',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              onPressed: () {
                addImageToFirebase();

                Navigator.of(context).popUntil((route) => route.isFirst);

                //Navigator.popUntil(context, (route) =>true);
              })
        ],
      ),
      body: ListView(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: AspectRatio(
                aspectRatio: 16 / 12,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(File(file!.path)),
                          fit: BoxFit.fill)),
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            title: Container(
              width: 250.0,
              child: TextField(
                style:
                    TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
                controller: textEditingController,
                decoration: InputDecoration(
                    hintText: "say something about image ",
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadForm();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
