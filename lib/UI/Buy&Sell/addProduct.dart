import 'dart:io';

import 'package:doodler/Bloc/SellBloc.dart';
import 'package:doodler/Bloc/SellEvent.dart';
import 'package:doodler/Model/User.dart';
import 'package:doodler/Model/buyandsell.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  final User? user;
  AddProduct({this.user});
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController _priceController = TextEditingController();
  late ProductBloc _productBloc;
  String? downloadUrl;

  @override
  void didChangeDependencies() {
    _productBloc = BlocProvider.of<ProductBloc>(context);
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

  /*Future cropImage(imagePath) async {
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

  Future<void> addImageToFirebase() async {
    Products products = new Products(
        note: textEditingController.text,
        userName: widget.user!.childName,
        userId: auth.FirebaseAuth.instance.currentUser!.uid,
        status: "sale",
        price: _priceController.text,
        delete: "",
        comments: []);
    _productBloc.productEventSink
        .add(AddProducts(file: file, products: products));
  }

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
              /*shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.0),
              ),*/
              style: ButtonStyle(
                //shape: MaterialStateProperty.resolveWith((states) {}),
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  // If the button is pressed, return green, otherwise blue
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.green;
                  }
                  return Colors.blue;
                }),
                /*textStyle: MaterialStateProperty.resolveWith((states) {
                  // If the button is pressed, return size 40, otherwise 20
                  if (states.contains(MaterialState.pressed)) {
                    return TextStyle(fontSize: 40);
                  }
                  return TextStyle(fontSize: 20);
                })*/
              ),
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
            'Add Product',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: AspectRatio(
                    aspectRatio: 18 / 12,
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
              Container(
                height: 5 * 24.0,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: textEditingController,
                  validator: (value) => textEditingController.text.isEmpty
                      ? "description is required !"
                      : null,
                  maxLines: 10,
                  decoration: InputDecoration(
                      labelText: 'Description about the product',
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
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _priceController,
                  validator: (value) => _priceController.text.isEmpty
                      ? "price is required !"
                      : null,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Enter the Price of the Product ',
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  autofocus: true,
                ),
              ),
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

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadForm();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
