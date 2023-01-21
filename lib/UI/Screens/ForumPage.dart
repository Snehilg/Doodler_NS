import 'dart:io';

import 'package:doodler/Bloc/forumBloc.dart';
import 'package:doodler/Bloc/forumEvent.dart';
import 'package:doodler/Model/Forum.dart';
import 'package:doodler/Model/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';

class ForumPage extends StatefulWidget {
  final User? user;
  ForumPage({this.user});
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late ForumBloc _forumBloc;
  String? downloadUrl;

  @override
  void didChangeDependencies() {
    _forumBloc = BlocProvider.of<ForumBloc>(context);
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
        ));
    setState(() {
      file = croppedFile;
    });
  }*/

  Future<void> addImageToFirebase() async {
    Forum tips = new Forum(
        note: textEditingController.text,
        userName: widget.user!.childName,
        userId: auth.FirebaseAuth.instance.currentUser!.uid,
        status: "active",
        delete: "",
        likes: [],
        comments: []);
    _forumBloc.forumEventSink.add(AddForum(file: file, forum: tips));
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

  @override
  Widget build(BuildContext context) {
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
            'Add Forum',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  takeImage(context);
                },
                child: Container(
                    //backgroundColor: Color(0xffFDCF09),
                    child: file != null
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            child: AspectRatio(
                              aspectRatio: 16 / 12,

                              // borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                file!,
                                width: 100,
                                height: 100,
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
                            Text("[ Image is optional ]",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey[600]))
                          ])),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
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
              SizedBox(
                height: 15.0,
              ),
              Container(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextButton(
                      onPressed: () async {
                        final form = formKey.currentState!;
                        if (form.validate()) {
                          addImageToFirebase();
                          Navigator.of(context).pop();
                        } else {
                          print("Hello");
                        }
                      },
                      child: Text(
                        'continue',
                        style: TextStyle(color: Colors.blue, fontSize: 25.0),
                      )))
            ],
          ),
        ));
  }
}
