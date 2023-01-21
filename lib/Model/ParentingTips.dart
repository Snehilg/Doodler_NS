import 'package:cloud_firestore/cloud_firestore.dart';

class ParentingTips {
  String? url;
  String? note;
  String? userName;
  String? userId;
  String? docId;
  String? delete;
  List<Comment?>? comments;

  ParentingTips(
      {this.note, this.userName, this.userId, this.delete, this.comments});

  ParentingTips.fromMap(Map<String, dynamic> map) {
    this.url = map["url"];
    this.note = map["note"];
    this.userName = map["userName"];

    this.userId = map["userId"];
    this.docId = map["docId"];
    this.delete = map["delete"];

    this.comments = <Comment?>[];
    for (var i = 0; i < map["comments"].length; i++) {
      this.comments!.add(Comment.fromMap(map["comments"][i]));
    }
  }
  ParentingTips.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    this.url = snapshot.data()!["url"];
    this.note = snapshot.data()!["note"];
    this.userName = snapshot.data()!["userName"];

    this.userId = snapshot.data()!["userId"];
    this.docId = snapshot.id;

    this.delete = snapshot.data()!["delete"];
    this.comments = <Comment?>[];
    for (var i = 0; i < snapshot.data()!["comments"].length; i++) {
      this.comments!.add(snapshot.data()!["comments"][i]);
    }
  }

  toJson() {
    return {
      // "url": this.url,
      "note": this.note,
      "userName": this.userName,
      "userId": this.userId,
      "delete": this.delete,
      // "docId":this.docId,
      "comments": List<Comment>.from(this.comments!),
    };
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
