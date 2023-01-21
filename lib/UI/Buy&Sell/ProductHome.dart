import 'dart:io';

import 'package:doodler/Bloc/SellBloc.dart';
import 'package:doodler/Bloc/SellEvent.dart';
import 'package:doodler/Model/User.dart';
import 'package:doodler/Model/buyandsell.dart';
import 'package:doodler/UI/Authentication/welcomePage.dart';
import 'package:doodler/UI/Buy&Sell/ProductCommentPage.dart';
import 'package:doodler/UI/Buy&Sell/addProduct.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search_page/search_page.dart';

class ProductHome extends StatefulWidget {
  final User? user;
  ProductHome({this.user});
  @override
  _BuyAndSellState createState() => _BuyAndSellState();
}

class _BuyAndSellState extends State<ProductHome> {
  late ProductBloc productBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  Color? color = Colors.green[100];
  int index = 0;
  List<bool> _likes = [true, false];
  void didChangeDependencies() {
    productBloc = BlocProvider.of<ProductBloc>(context);
    productBloc.productEventSink.add(FetchProducts());
    super.didChangeDependencies();
  }

  String? note;
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
    // cropImage(image!.path);
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
            /* title: Text(
              'Contest Form',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),*/
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
    ProductBloc productBloc = BlocProvider.of<ProductBloc>(context);

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("Buy and Sell",
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
                            builder: (context) => AddProduct(
                                  user: widget.user,
                                )))
                    : showAlertDialog(context);
              },
            )
          ],
        ),
        body: Stack(children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.8,
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
            padding: EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
            child: StreamBuilder<List<Products>?>(
              stream: productBloc.allProductStream,
              initialData: productBloc.allProduct,
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
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 20.0),
                                          child: Row(children: [
                                            InkWell(
                                              child: Chip(
                                                label: Text(
                                                  snapshot.data![i].status ==
                                                          null
                                                      ? ""
                                                      : snapshot
                                                          .data![i].status!,
                                                  style: TextStyle(
                                                      color: Colors.green[900],
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                backgroundColor: color,
                                              ),
                                              onTap: () {
                                                if (snapshot.data![i].userId ==
                                                    auth.FirebaseAuth.instance
                                                        .currentUser!.uid) {
                                                  productBloc.productEventSink
                                                      .add(UpdateStatus(
                                                          docId: snapshot
                                                              .data![i].docId,
                                                          status: "sold"));
                                                } else {
                                                  print("hello");
                                                }
                                              },
                                            ),
                                            Spacer(),
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                if (snapshot.data![i].userId ==
                                                    auth.FirebaseAuth.instance
                                                        .currentUser!.uid) {
                                                  editModalBottomSheet(
                                                      snapshot.data![i].docId,
                                                      snapshot.data![i].url);
                                                } else {
                                                  print("Hello");
                                                }
                                              },
                                            ),
                                            IconButton(
                                                icon:
                                                    Icon(Icons.delete_outline),
                                                onPressed: () {
                                                  if (snapshot
                                                          .data![i].userId ==
                                                      auth.FirebaseAuth.instance
                                                          .currentUser!.uid) {
                                                    productBloc.productEventSink
                                                        .add(DeleteProduct(
                                                            docId: snapshot
                                                                .data![i].docId,
                                                            delete: "deleted"));
                                                  } else {
                                                    print("hello");
                                                  }
                                                })
                                          ])),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                      snapshot.data![i]
                                                                  .userName ==
                                                              null
                                                          ? ""
                                                          : '@' +
                                                              snapshot.data![i]
                                                                  .userName!,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[400],
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.0,
                                                              vertical: 15),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Text(
                                                          snapshot.data![i]
                                                                      .note ==
                                                                  null
                                                              ? ""
                                                              : snapshot
                                                                  .data![i]
                                                                  .note!,
                                                          maxLines: 10,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ))
                                                ]),
                                          ]),
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
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                snapshot.data![i].price == null
                                                    ? ""
                                                    : "Rs." +
                                                        " " +
                                                        snapshot
                                                            .data![i].price! +
                                                        ".00",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  color: Colors.green,
                                                  icon: Icon(Icons.comment),
                                                  tooltip: "Comment",
                                                  onPressed: () {
                                                    if (snapshot
                                                            .data![i].status ==
                                                        "sale") {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProductCommentPage(
                                                                    user: widget
                                                                        .user,
                                                                    products:
                                                                        snapshot
                                                                            .data![i],
                                                                  )));
                                                    } else {
                                                      print("Hello");
                                                    }
                                                  }),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text(snapshot.data![i]
                                                            .comments!.length
                                                            .toString() ==
                                                        null
                                                    ? 0 as String
                                                    : snapshot.data![i]
                                                        .comments!.length
                                                        .toString()),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                              } else {
                                return Container(
                                  child: Text(""),
                                );
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
    ProductBloc productBloc = BlocProvider.of<ProductBloc>(context);

    showSearch(
        context: context,
        delegate: SearchPage<Products>(
            items: productBloc.allProduct!,
            searchLabel: 'Search products',
            suggestion: Center(
              child: Text('Filter products by title'),
            ),
            failure: Center(
              child: Text('No product found :('),
            ),
            filter: (forum) => [
                  forum.userName!,
                  forum.note!,
                ],
            builder: (person) => Container(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  elevation: 1.0,
                  margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                        label: Text(
                          person.status == null ? "" : person.status!,
                          style: TextStyle(
                              color: Colors.green[900],
                              fontWeight: FontWeight.w700),
                        ),
                        backgroundColor: Colors.green[100],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      '@' + person.userName!,
                                      style: TextStyle(
                                          color: Colors.blue[400],
                                          fontSize: 13),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 15),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        person.note!,
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  )
                                ]),
                          ]),
                      Container(
                          child: person.url != null
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: AspectRatio(
                                    aspectRatio: 16 / 12,
                                    child: Image.network(
                                      person.url!,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Rs." + " " + person.price! + ".00",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  color: Colors.green,
                                  icon: Icon(Icons.comment),
                                  tooltip: "Comment",
                                  onPressed: () {
                                    if (person.status == "sale") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductCommentPage(
                                                    user: widget.user,
                                                    products: person,
                                                  )));
                                    } else {
                                      print("Hello");
                                    }
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                    person.comments!.length.toString() == null
                                        ? 0 as String
                                        : person.comments!.length.toString()),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      )
                    ],
                  ),
                ))));
  }

  void editModalBottomSheet(String? docId, String? url) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Form(
              key: formKey,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: ListView(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Spacer(),
                              Text('Edit Product Details ',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.orange)),
                              Spacer(),
                              IconButton(
                                  icon: Icon(Icons.cancel,
                                      color: Colors.orange, size: 25.0),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ]),
                            GestureDetector(
                              onTap: () {
                                takeImage(context);
                              },
                              child: Container(
                                  child: file != null
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                          Text("[ Image  ]",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.grey[600]))
                                        ])),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              height: 5 * 20.0,
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: TextFormField(
                                controller: _noteController,
                                validator: (value) =>
                                    _noteController.text.isEmpty
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
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              height: 5 * 10.0,
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: TextFormField(
                                controller: _priceController,
                                validator: (value) =>
                                    _priceController.text.isEmpty
                                        ? "price is required"
                                        : null,
                                maxLines: 10,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: 'price ',
                                    contentPadding: EdgeInsets.all(20.0),
                                    border: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                      color: Theme.of(context).primaryColor,
                                    )),
                                    prefixIcon: Icon(Icons.add_comment,
                                        color: Theme.of(context).primaryColor)),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextButton(
                                onPressed: () async {
                                  final form = formKey.currentState;
                                  if (file != null) {
                                    if (form!.validate()) {
                                      productBloc.productEventSink.add(
                                          UpdateProduct(
                                              file: file,
                                              docId: docId,
                                              price: _priceController.text,
                                              note: _noteController.text));
                                      _noteController.clear();
                                      _priceController.clear();

                                      Navigator.of(context).pop();
                                    } else {
                                      print("Hello");
                                    }
                                  } else {
                                    return alert(context);
                                  }
                                },
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ))
                          ]))));
        });
  }

  Future<void> alert(BuildContext context) {
    return showDialog(
        context: _scaffoldKey.currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Please pick a image first !!",
              textAlign: TextAlign.center,
            ),
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
