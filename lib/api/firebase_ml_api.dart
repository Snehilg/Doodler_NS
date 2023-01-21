/*
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FirebaseMLApi {
  static Future<String> recogniseText(Uint8List imageFile) async {
    if (imageFile == null) {
      return 'No selected image';
    } else {
      //TODO: PlaneData needs to be prepared first

      final imageMetadata = FirebaseVisionImageMetadata(
        size: Size(1080, 1080),
        planeData: null,
        rawFormat: 'RGBA',
      );

      print("inside recognize text");
      print(imageMetadata);

      //TODO: Plane Data issue .
      FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
          size: Size(512, 512),
          rawFormat: ui.ImageByteFormat.png,
          planeData: null);

      final test = FirebaseVisionImage.fromBytes(imageFile, metadata);
      // final visionImage = FirebaseVisionImage.fromFile(imageFile);

      final textRecognizer = FirebaseVision.instance.textRecognizer();
      try {
        // final visionText = await textRecognizer.processImage(visionImage);
        final visionText = await textRecognizer.processImage(test);
        await textRecognizer.close();

        // final text = extractText(visionText);

        final text = extractText(visionText);
        return text.isEmpty ? 'No text found in the image' : text;
      } catch (error) {
        return error.toString();
      }
    }
  }

  static extractText(VisionText visionText) {
    String text = '';

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          text = text + word.text + ' ';
        }
        text = text + '\n';
      }
    }

    return text;
  }
}
*/
