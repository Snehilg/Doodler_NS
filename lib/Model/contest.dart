import 'package:cloud_firestore/cloud_firestore.dart';

class Contest {
  String? title;
  String? note;
  List<String?>? rules;
  String? startDate;
  String? endDate;
  List<Nominations>? nominations;
  String? regEndDate;
  String? prize;
  String? docId;
  String? status;
  Contest(
      {this.title,
      this.note,
      this.rules,
      this.startDate,
      this.endDate,
      this.nominations,
      this.regEndDate,
      this.prize,
      this.docId});

  Contest.fromMap(Map<String, dynamic> map) {
    this.title = map["title"];
    this.note = map["note"];
    this.rules = <String?>[];
    for (var i = 0; i < map["rules"].length; i++) {
      this.rules!.add(map["rules"][i]);
    }
    this.startDate = map["startDate"];
    this.endDate = map["endDate"];
    this.nominations = <Nominations>[];
    for (var i = 0; i < map["nominations"].length; i++) {
      this.nominations!.add(Nominations.fromMap(map["nominations"][i]));
    }

    this.regEndDate = map["regEndDate"];
    this.prize = map["prize"];
    this.docId = map["docId"];
    this.status = map["status"];
  }
  toJson() {
    return {
      "title": this.title,
      "note": this.note,
      "rules": List<String>.from(this.rules!),
      "startDate": this.startDate,
      "endDate": this.endDate,
      "nominations": List<Nominations>.from(this.nominations!),
      "regEndDate": this.regEndDate,
      "prize": this.prize
    };
  }
}

class Nominations {
  String? userId;
  Nominations({this.userId});
  Nominations.fromMap(Map<String, dynamic> map) {
    this.userId = map["userId"];
  }
  toJson() {
    return {"userId": this.userId};
  }
}

class ContestForm {
  String? url;
  String? date;
  String? note;
  String? userName;
  String? userPhoto;
  String? userId;
  String? docId;

  List<ContestLikes?>? likes;
  List<ContestComment?>? comments;

  ContestForm(
      {this.date,
      this.note,
      this.userName,
      this.userPhoto,
      this.userId,
      this.likes,
      this.comments});

  ContestForm.fromMap(Map<String, dynamic> map) {
    this.url = map["url"];
    this.date = map["date"];
    this.note = map["note"];
    this.userName = map["userName"];
    this.userPhoto = map["userPhoto"];

    this.userId = map["userId"];
    this.docId = map["docId"];
    this.likes = <ContestLikes?>[];
    for (var i = 0; i < map["likes"].length; i++) {
      this.likes!.add(ContestLikes.fromMap(map["likes"][i]));
    }
    this.comments = <ContestComment?>[];
    for (var i = 0; i < map["comments"].length; i++) {
      this.comments!.add(ContestComment.fromMap(map["comments"][i]));
    }
  }

  ContestForm.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    this.url = snapshot.data()!["url"];
    this.date = snapshot.data()!["date"];
    this.note = snapshot.data()!["note"];
    this.userName = snapshot.data()!["userName"];
    this.userPhoto = snapshot.data()!["userPhoto"];

    this.userId = snapshot.data()!["userId"];
    this.docId = snapshot.id;
    this.likes = <ContestLikes?>[];
    for (var i = 0; i < snapshot.data()!["likes"].length; i++) {
      this.likes!.add(snapshot.data()!["likes"][i]);
    }
    this.comments = <ContestComment?>[];
    for (var i = 0; i < snapshot.data()!["comments"].length; i++) {
      this.comments!.add(snapshot.data()!["comments"][i]);
    }
  }

  toJson() {
    return {
      // "url": this.url,
      "date": this.date,
      "note": this.note,
      "userName": this.userName,
      "userPhoto": this.userPhoto,
      "userId": this.userId,
      // "docId":this.docId,
      "likes": List<ContestLikes>.from(this.likes!),
      "comments": List<ContestComment>.from(this.comments!),
    };
  }
}

class ContestLikes {
  String? userId;
  ContestLikes({this.userId});
  ContestLikes.fromMap(Map<String, dynamic> map) {
    this.userId = map["userId"];
  }
  toJson() {
    return {"userId": this.userId};
  }
}

class ContestComment {
  String? commentDate;
  String? comment;
  String? userId;
  String? userName;
  String? userPhoto;

  ContestComment(
      {this.commentDate,
      this.comment,
      this.userId,
      this.userName,
      this.userPhoto});

  ContestComment.fromMap(Map<String, dynamic> map) {
    this.commentDate = map["commentDate"];
    this.comment = map["comment"];
    this.userId = map["userId"];
    this.userName = map["userName"];
    this.userPhoto = map["userPhoto"];
  }

  toJson() {
    return {
      "commentDate": this.commentDate,
      "comment": this.comment,
      "userId": this.userId,
      "userName": this.userName,
      "userPhoto": this.userPhoto
    };
  }
}
