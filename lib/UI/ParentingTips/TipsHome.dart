import 'dart:io';

import 'package:doodler/Bloc/ParentingTipsBloc.dart';
import 'package:doodler/Bloc/ParentingTipsEvent.dart';
import 'package:doodler/Model/ParentingTips.dart';
import 'package:doodler/Model/User.dart';
import 'package:doodler/UI/Authentication/welcomePage.dart';
import 'package:doodler/UI/ParentingTips/AddTips.dart';
import 'package:doodler/UI/ParentingTips/ParentingCommentPage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search_page/search_page.dart';

class TipsHome extends StatefulWidget {
  final User? user;
  TipsHome({this.user});
  @override
  _TipsHomeState createState() => _TipsHomeState();
}

class _TipsHomeState extends State<TipsHome> {
  Color? color = Colors.green[100];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int index = 0;
  late ParentingBloc parentingBloc;
  String? downloadUrl;

  List<bool> _likes = [true, false];
  void didChangeDependencies() {
    parentingBloc = BlocProvider.of<ParentingBloc>(context);
    parentingBloc.parentingEventSink.add(FetchTips());
    super.didChangeDependencies();
  }

  String? note;
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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomePage()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Please Login"),
      content: Text("You need to SignUp to continue.!!"),
      actions: [
        //cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ParentingBloc parentingBloc = BlocProvider.of<ParentingBloc>(context);

    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("Parenting Tips",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                widget.user != null
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddParentingTips(
                                  user: widget.user,
                                )))
                    : showAlertDialog(context);
              },
            )
          ],
        ),
        body: Stack(children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent),
          Positioned(
              top: 70.0,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45.0),
                        topRight: Radius.circular(45.0),
                      ),
                      color: Colors.white),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width)),
          Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                onTap: () => displaySearch(),
                decoration: InputDecoration(
                    hintText: "Search",
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.filter_list),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.transparent)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0)),
              )),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              top: 100.0,
            ),
            child: StreamBuilder<List<ParentingTips>?>(
              stream: parentingBloc.allTipsStream,
              initialData: parentingBloc.allParentingTips,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(""),
                    );
                  } else {
                    return Scrollbar(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, i) {
                              if (snapshot.data![i].delete == "") {
                                return Container(
                                  child: Card(
                                    elevation: 1.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 20.0),
                                            child: Row(children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10.0, right: 20.0),
                                                child: Text(
                                                  "${snapshot.data![i].userName![0].toUpperCase()}${snapshot.data![i].userName!.substring(1)}",
                                                  style: TextStyle(
                                                      color: Colors.blue[400],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  if (snapshot
                                                          .data![i].userId ==
                                                      auth.FirebaseAuth.instance
                                                          .currentUser!.uid) {
                                                    displayDialog(
                                                        context,
                                                        snapshot
                                                            .data![i].docId);
                                                  } else {
                                                    print("Hello");
                                                  }
                                                },
                                              ),
                                              IconButton(
                                                  icon: Icon(
                                                      Icons.delete_outline),
                                                  onPressed: () {
                                                    if (snapshot
                                                            .data![i].userId ==
                                                        auth
                                                            .FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid) {
                                                      parentingBloc
                                                          .parentingEventSink
                                                          .add(DeleteTips(
                                                              docId: snapshot
                                                                  .data![i]
                                                                  .docId,
                                                              delete:
                                                                  "deleted"));
                                                    } else {
                                                      print("hello");
                                                    }
                                                  })
                                            ])),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    child: Text(
                                                      snapshot.data![i].note ==
                                                              null
                                                          ? ""
                                                          : snapshot
                                                              .data![i].note!,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      maxLines: 10,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ))
                                            ]),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                            child: snapshot.data![i].url != null
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
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
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                color: Colors.green,
                                                icon: Icon(
                                                  Icons.comment,
                                                  size: 30.0,
                                                ),
                                                tooltip: "Comment",
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParentingCommentPage(
                                                                user:
                                                                    widget.user,
                                                                tips: snapshot
                                                                    .data![i],
                                                              )));
                                                }),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                snapshot.data![i].comments!
                                                            .length
                                                            .toString() ==
                                                        null
                                                    ? 0 as String
                                                    : snapshot.data![i]
                                                        .comments!.length
                                                        .toString(),
                                                style:
                                                    TextStyle(fontSize: 18.0),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container(child: Text(""));
                              }
                            }));
                  }
                }

                return Container(
                  child: Text(""),
                );
              },
            ),
          )
        ]));
  }

  void displaySearch() async {
    ParentingBloc parentingBloc = BlocProvider.of<ParentingBloc>(context);

    showSearch(
        context: context,
        delegate: SearchPage<ParentingTips>(
            items: parentingBloc.allParentingTips!,
            searchLabel: 'Search ParentingTips',
            suggestion: Center(
              child: Text('Filter ParentingTips by title'),
            ),
            failure: Center(
              child: Text('No ParentingTips found :('),
            ),
            filter: (tips) => [
                  tips.userName!,
                  tips.note!,
                ],
            builder: (tips) => Column(children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  tips.delete == ""
                      ? Container(
                          child: Card(
                            elevation: 1.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, right: 20.0),
                                        child: Text(
                                          "${tips.userName![0].toUpperCase()}${tips.userName!.substring(1)}",
                                          style: TextStyle(
                                              color: Colors.blue[400],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          if (tips.userId ==
                                              auth.FirebaseAuth.instance
                                                  .currentUser!.uid) {
                                            displayDialog(
                                                context, DeleteTips().docId);
                                          } else {
                                            print("Hello");
                                          }
                                        },
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.delete_outline),
                                          onPressed: () {
                                            if (tips.userId ==
                                                auth.FirebaseAuth.instance
                                                    .currentUser!.uid) {
                                              parentingBloc.parentingEventSink
                                                  .add(DeleteTips(
                                                      docId: tips.docId,
                                                      delete: "deleted"));
                                            } else {
                                              print("hello");
                                            }
                                          })
                                    ]),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Text(
                                        tips.note == null ? "" : tips.note!,
                                        textAlign: TextAlign.justify,
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                    child: tips.url != null
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: AspectRatio(
                                              aspectRatio: 16 / 12,

                                              // borderRadius: BorderRadius.circular(50),
                                              child: Image.network(
                                                tips.url!,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ))
                                        : SizedBox(
                                            height: 5.0,
                                          )),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        color: Colors.green,
                                        icon: Icon(
                                          Icons.comment,
                                          size: 30.0,
                                        ),
                                        tooltip: "Comment",
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ParentingCommentPage(
                                                      user: widget.user,
                                                      tips: tips,
                                                    )))),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        tips.comments!.length.toString() == null
                                            ? 0 as String
                                            : tips.comments!.length.toString(),
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          child: Text(""),
                        )
                ])));
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
                                  Text("[ Image is optional ]",
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
                // child: ListView(
                //   physics: ScrollPhysics(),
                //   scrollDirection: Axis.vertical,
                //   shrinkWrap: true,
                //   children: [
                //     GestureDetector(
                //       onTap: () {
                //         takeImage(context);
                //       },
                //       child: Container(
                //           child: file != null
                //               ? Container(
                //                   width: MediaQuery.of(context).size.width,
                //                   child: AspectRatio(
                //                     aspectRatio: 16 / 12,
                //                     child: Image.file(
                //                       file,
                //                       width: 100,
                //                       height: 80,
                //                       fit: BoxFit.fitHeight,
                //                     ),
                //                   ))
                //               : Column(children: [
                //                   Container(
                //                     width: 100,
                //                     height: 100,
                //                     child: Icon(
                //                       Icons.add_photo_alternate,
                //                       size: 40.0,
                //                       color: Colors.grey[600],
                //                     ),
                //                   ),
                //                   Text("[ Image is optional ]",
                //                       style: TextStyle(
                //                           fontSize: 16.0,
                //                           color: Colors.grey[600]))
                //                 ])),
                //     ),
                //     SizedBox(
                //       height: 15.0,
                //     ),
                //     Container(
                //       height: 5 * 24.0,
                //       padding: EdgeInsets.only(left: 20.0, right: 20.0),
                //       child: TextFormField(
                //         controller: textEditingController,
                //         validator: (value) =>
                //             textEditingController.text.isEmpty
                //                 ? "description is required"
                //                 : null,
                //         maxLines: 10,
                //         decoration: InputDecoration(
                //             labelText: 'Description ',
                //             contentPadding: EdgeInsets.all(20.0),
                //             border: new OutlineInputBorder(
                //                 borderSide: new BorderSide(
                //               color: Theme.of(context).primaryColor,
                //             )),
                //             prefixIcon: Icon(Icons.add_comment,
                //                 color: Theme.of(context).primaryColor)),
                //       ),
                //     ),
                //     Divider(),
                //   ],
                // ),
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
                    final form = formKey.currentState!;
                    if (form.validate()) {
                      parentingBloc.parentingEventSink.add(UpdateTips(
                          file: file,
                          docId: docId,
                          note: textEditingController.text));
                      textEditingController.clear();

                      Navigator.of(context).pop();
                    } else {
                      print("Hello");
                    }
                  },
                  child: Text('done'))
            ],
          );
        });
  }
}
