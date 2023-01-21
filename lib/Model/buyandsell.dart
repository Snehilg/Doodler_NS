class Products {
  String? url;
  String? note;
  String? userName;
  String? userId;
  String? docId;
  String? status;
  String? price;
  String? delete;
  List<Comment>? comments;

  Products(
      {this.note,
      this.userName,
      this.userId,
      this.status,
      this.price,
      this.delete,
      this.comments});

  Products.fromMap(Map<String, dynamic> map) {
    this.url = map["url"];
    this.note = map["note"];
    this.userName = map["userName"];

    this.userId = map["userId"];
    this.docId = map["docId"];
    this.status = map["status"];
    this.price = map["price"];
    this.delete = map["delete"];
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
      // "docId":this.docId,
      "delete": this.delete,
      "price": this.price,
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
