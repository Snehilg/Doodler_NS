import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

//import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

const directoryName = 'Signature';

class SignApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignAppState();
  }
}

class SignAppState extends State<SignApp> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  String text = "";
  late File file;
  GlobalKey globalKey = GlobalKey();
  Color pickerColor = Colors.black;
  Color selectedColor = Colors.black;
  Color selectedBackground = Colors.white;
  void changeColor(Color color) => setState(() => selectedBackground = color);
  void changeBgColor(Color color) => setState(() => selectedColor = color);

  List<TouchPoints?>? points = [];
  double opacity = 1.0;
  StrokeCap strokeType = StrokeCap.round;
  double strokeWidth = 3.0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  Future<void> _pickStroke() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClipOval(
          child: AlertDialog(
            actions: <Widget>[
              TextButton(
                child: Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  strokeWidth = 3.0;
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Icon(
                  Icons.brush,
                  size: 24,
                ),
                onPressed: () {
                  strokeWidth = 10.0;
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Icon(
                  Icons.brush,
                  size: 40,
                ),
                onPressed: () {
                  strokeWidth = 30.0;
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Icon(
                  Icons.brush,
                  size: 60,
                ),
                onPressed: () {
                  strokeWidth = 50.0;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _opacity() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClipOval(
          child: AlertDialog(
            actions: <Widget>[
              TextButton(
                child: Icon(
                  Icons.opacity,
                  size: 24,
                ),
                onPressed: () {
                  opacity = 0.1;
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Icon(
                  Icons.opacity,
                  size: 40,
                ),
                onPressed: () {
                  opacity = 0.5;
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Icon(
                  Icons.opacity,
                  size: 60,
                ),
                onPressed: () {
                  opacity = 1.0;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
        as FutureOr<ByteData>);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    if (!(await Permission.storage.status.isGranted))
      await Permission.storage.request();

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 60,
        name: "canvas_image");
    print(result);
    displayDialog();
  }

  Future readText() async {
    showDialog(
      context: context,

      /*child: Center(
        child: CircularProgressIndicator(),
      ), */
      builder: (BuildContext context) {
        CircularProgressIndicator();
      } as Widget Function(BuildContext),
    );
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
        as FutureOr<ByteData>);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 60,
        name: "canvas_image");
    print(result);
    // var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(result);
    });

    //Todo
    /* FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(file);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
        }
      }
    }*/

    Navigator.of(context).pop();
  }

  /* Future readText() async {
     RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();



    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 60,
        name: "canvas_image");
    print(result);
    setState(() {


    });
    try{


    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(file);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
        }
      }
    }
    }
    catch(error){
      print(error);
    }
  }*/

  displayDialog() async {
    AwesomeDialog(
      context: context,
      animType: AnimType.BOTTOMSLIDE,
      dialogType: DialogType.SUCCES,
      body: Center(
        child: Text(
          """ Your sketch is successfully saved to the gallery......\n if you want to publish it\n Please !! select sketch from the gallery""",
          style: TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ),
      btnOkOnPress: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    )..show();
  }

  List<Bubble> fabOption() {
    Color screenPickerColor;
    screenPickerColor = Colors.blue;
    return <Bubble>[
      Bubble(
        title: "Save",
        iconColor: Colors.white,
        bubbleColor: Colors.blue,
        icon: Icons.save,
        titleStyle: TextStyle(fontSize: 16, color: Colors.white),
        //heroTag: "paint_save",
        //child: Icon(Icons.save),
        //tooltip: 'Save',
        onPress: () {
          //min: 0, max: 50
          setState(() {
            _save();
          });
        },
        //icon: null,
      ),
      Bubble(
        title: "Brush",
        iconColor: Colors.white,
        bubbleColor: Colors.blue,
        icon: Icons.brush,
        titleStyle: TextStyle(fontSize: 16, color: Colors.white),
        onPress: () {
          //min: 0, max: 50
          setState(() {
            _pickStroke();
          });
        },
      ),
      Bubble(
        title: "Opacity",
        iconColor: Colors.white,
        bubbleColor: Colors.blue,
        icon: Icons.opacity,
        titleStyle: TextStyle(fontSize: 16, color: Colors.white),
        onPress: () {
          //min:0, max:1
          setState(() {
            _opacity();
          });
        },
      ),
      Bubble(
          title: "Colors",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.color_lens_outlined,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                context: context,
                builder: (BuildContext bc) {
                  return Container(
                    padding: EdgeInsets.all(15.0),
                    width: 300,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: SingleChildScrollView(
                      child: ColorPicker(
                        color: selectedBackground,
                        onColorChanged: (Color color) =>
                            setState(() => selectedBackground = color),
                        heading: Text(
                          'Select color',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        subheading: Text(
                          'Select color shade',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      // child: ColorPicker(
                      //     pickerColor: pickerColor,
                      //     onColorChanged: changeColor,
                      //     colorPickerWidth: 500.0,
                      //     pickerAreaHeightPercent: 0.3,
                      //     enableAlpha: true,
                      //     displayThumbColor: true,
                      //     showLabel: true,
                      //     paletteType: PaletteType.hsv,
                      //     pickerAreaBorderRadius: BorderRadius.circular(10.0)),
                    ),
                  );
                });
          }),
      Bubble(
          title: "Clear",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.clean_hands_rounded,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            setState(() {
              points!.clear();
            });
          }),
      Bubble(
          title: "Background Color",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.collections_outlined,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                context: context,
                builder: (BuildContext bc) {
                  return Container(
                      padding: EdgeInsets.all(15.0),
                      width: 300,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: SingleChildScrollView(
                        child: ColorPicker(
                          color: selectedColor,
                          onColorChanged: (Color color) =>
                              setState(() => selectedColor = color),
                          heading: Text(
                            'Select color',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          subheading: Text(
                            'Select color shade',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        // child: ColorPicker(
                        //     pickerColor: pickerColor,
                        //     onColorChanged: changeBgColor,
                        //     colorPickerWidth: 500.0,
                        //     pickerAreaHeightPercent: 0.8,
                        //     enableAlpha: true,
                        //     displayThumbColor: true,
                        //     showLabel: true,
                        //     paletteType: PaletteType.hsv,
                        //     pickerAreaBorderRadius:
                        //         BorderRadius.circular(10.0)),
                      ));
                });
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //appBar: AppBar(title: Text('Create Your Sketch....')),
        backgroundColor: selectedBackground,
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                points!.add(TouchPoints(
                    points: renderBox.globalToLocal(details.globalPosition),
                    paint: Paint()
                      ..strokeCap = strokeType
                      ..isAntiAlias = true
                      ..color = selectedColor.withOpacity(opacity)
                      ..strokeWidth = strokeWidth));
              });
            },
            onPanStart: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                points!.add(TouchPoints(
                    points: renderBox.globalToLocal(details.globalPosition),
                    paint: Paint()
                      ..strokeCap = strokeType
                      ..isAntiAlias = true
                      ..color = selectedColor.withOpacity(opacity)
                      ..strokeWidth = strokeWidth));
              });
            },
            onPanEnd: (details) {
              setState(() {
                //TOdo
                points!.add(null);
                // points = [];
              });
            },
            child: RepaintBoundary(
                key: globalKey,
                child: Container(
                  color: selectedBackground,
                  child: Center(
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: MyPainter(
                        pointsList: points,
                      ),
                    ),
                  ),
                )),
          ),
        ),
        floatingActionButton: FloatingActionBubble(
          /* fabButtons: fabOption(),
          colorStartAnimation: Colors.amber,
          colorEndAnimation: Colors.cyan,*/
          animatedIconData: AnimatedIcons.menu_close,
          items: fabOption(),
          animation: _animation,

          // On pressed change animation state
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),
          iconColor: Colors.black,
          backGroundColor: Colors.transparent,
          //animation: null,
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter({this.pointsList});

  List<TouchPoints?>? pointsList;
  List<Offset?> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList!.length - 1; i++) {
      if (pointsList![i] != null && pointsList![i + 1] != null) {
        canvas.drawLine(pointsList![i]!.points!, pointsList![i + 1]!.points!,
            pointsList![i]!.paint!);
      } else if (pointsList![i] != null && pointsList![i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList![i]!.points);
        offsetPoints.add(Offset(pointsList![i]!.points!.dx + 0.1,
            pointsList![i]!.points!.dy + 0.1));

        canvas.drawPoints(ui.PointMode.points, offsetPoints as List<ui.Offset>,
            pointsList![i]!.paint!);
      }
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;
}

class TouchPoints {
  Paint? paint;
  Offset? points;
  TouchPoints({this.points, this.paint});
}
