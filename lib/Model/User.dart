import 'package:doodler/Model/Sketch.dart';

class User {
  String? userId;
  String? gender;
  int? phoneNumber;
  int? currentLevel;
  int? childAge;
  String? childName;
  String? audioPath;
  String? photoPath;
  String? guardianName;
 //List<int> completedLessonsNumbers;

  //Map<String, Sketch> sketches;

  User(
      {this.userId,
      this.gender,
      this.phoneNumber,
      this.currentLevel,
      this.childAge,
      this.childName,
      this.audioPath,
      this.guardianName,
  //  this.completedLessonsNumbers,
  //  this.sketches
  });

  User.fromMap(Map<String, dynamic> map) {
    this.userId = map["userId"];
    this.gender = map["gender"];
    this.phoneNumber = map["phoneNumber"];
    this.currentLevel = map["currentLevel"];
    this.childAge = map["childAge"];
    this.childName = map["childName"];
    this.audioPath = map["audioPath"];
    this.photoPath = map["photoPath"];
    this.guardianName = map["guardianName"];
   /* this.completedLessonsNumbers = List<int>();
    for (var i = 0; i < map["lessonNum"].length; i++) {
      this.completedLessonsNumbers.add(map["lessonNum"][i]);
    }
    this.sketches =
        Map<String, dynamic>.from(map["sketches"]).map((key, value) =>
            MapEntry(key, Sketch.fromMap(value)));
//    .forEach((sketch) {
//      sketches[sketch["url"]]=Sketch.fromMap(sketch);
////    });*/
  }

  toJson(String? userId) {
    return {
      "userId": userId,
      "gender": this.gender,
      "phoneNumber": this.phoneNumber,
      "currentLevel": this.currentLevel,
      "childAge": this.childAge,
      "childName": this.childName,
      "audioPath": this.audioPath,
      "guardianName": this.guardianName,
    // "lessonNum": List<dynamic>.from(this.completedLessonsNumbers),
     // "sketches": Map<String, dynamic>.from(this.sketches),
    };
  }
}
