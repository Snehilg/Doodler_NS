import 'package:cloud_firestore/cloud_firestore.dart';

class Sketch {
  String? url;
  String? date;
  String? note;
  String? userName;
  String? userPhoto;
  String? userId;
  String? docId;
  String? delete;

  List<Likes?>? likes;
  List<Comment?>? comments;

  Sketch(
      {this.date,
      this.note,
      this.userName,
      this.userPhoto,
      this.userId,
      this.delete,
      this.likes,
      this.comments});

  Sketch.fromMap(Map<String, dynamic> map) {
    this.url = map["url"];
    this.date = map["date"];
    this.note = map["note"];
    this.userName = map["userName"];
    this.userPhoto = map["userPhoto"];

    this.userId = map["userId"];
    this.docId = map["docId"];
    this.delete = map["delete"];
    this.likes = <Likes?>[];
    for (var i = 0; i < map["likes"].length; i++) {
      this.likes!.add(Likes.fromMap(map["likes"][i]));
    }
    this.comments = <Comment?>[];
    for (var i = 0; i < map["comments"].length; i++) {
      this.comments!.add(Comment.fromMap(map["comments"][i]));
    }
  }

  Sketch.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    this.url = snapshot.data()!["url"];
    this.date = snapshot.data()!["date"];
    this.note = snapshot.data()!["note"];
    this.userName = snapshot.data()!["userName"];
    this.userPhoto = snapshot.data()!["userPhoto"];

    this.userId = snapshot.data()!["userId"];
    this.docId = snapshot.id;
    this.likes = <Likes?>[];
    for (var i = 0; i < snapshot.data()!["likes"].length; i++) {
      this.likes!.add(snapshot.data()!["likes"][i]);
    }
    this.comments = <Comment?>[];
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
      "delete": this.delete,
      "likes": List<Likes>.from(this.likes!),
      "comments": List<Comment>.from(this.comments!),
    };
  }
}

class Likes {
  String? userId;
  Likes({this.userId});
  Likes.fromMap(Map<String, dynamic> map) {
    this.userId = map["userId"];
  }
  toJson() {
    return {"userId": this.userId};
  }
}

class Comment {
  String? commentDate;
  String? comment;
  String? userId;
  String? userName;
  String? userPhoto;

  Comment(
      {this.commentDate,
      this.comment,
      this.userId,
      this.userName,
      this.userPhoto});

  Comment.fromMap(Map<String, dynamic> map) {
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
