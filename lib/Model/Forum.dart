class Forum {
  String? url;
  String? note;
  String? userName;
  String? userId;
  String? docId;
  String? status;
  String? delete;

  List<Likes>? likes;
  List<Comment>? comments;

  Forum(
      {this.note,
      this.userName,
      this.userId,
      this.status,
      this.delete,
      this.likes,
      this.comments});

  Forum.fromMap(Map<String, dynamic> map) {
    this.url = map["url"];
    this.note = map["note"];
    this.userName = map["userName"];

    this.userId = map["userId"];
    this.docId = map["docId"];
    this.status = map["status"];
    this.delete = map["delete"];
    this.likes = <Likes>[];
    for (var i = 0; i < map["likes"].length; i++) {
      this.likes!.add(Likes.fromMap(map["likes"][i]));
    }
    this.comments = <Comment>[];
    for (var i = 0; i < map["comments"].length; i++) {
      this.comments!.add(Comment.fromMap(map["comments"][i]));
    }
  }

  toJson() {
    return {
      // "url": this.url,
      "note": this.note,
      "userName": this.userName,
      "userId": this.userId,
      "status": this.status,
      "delete": this.delete,
      // "docId":this.docId,
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
