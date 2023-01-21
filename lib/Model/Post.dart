class Post {
  String? postID;
  String? userID;
  String? postType;

  ///photo or video
  String? postPath;

  ///.will contain list of userId how has liked this post
  List<String?>? likes;
  int? dislikes;

  Post({
    this.postID,
    this.userID,
    this.postType,
    this.postPath,
    this.likes,
    this.dislikes,
  });

  Post.fromMap(Map<String, dynamic> map) {
    this.postID = map["postID"];
    this.userID = map["userID"];
    this.postType = map["postType"];
    this.postPath = map["postPath"];
    this.likes = <String?>[];
    for (var i = 0; i < map["likes"].length; i++) {
      this.likes!.add(map["likes"][i]);
    }
    this.dislikes = map["dislikes"];
  }

  toJson(String postId, String userId) {
    return {
      "postID": postId,
      "userID": userId,
      "postType": this.postType,
      "postPath": this.postPath,
      "likes": List<dynamic>.from(this.likes!),
      "dislikes": this.dislikes
    };
  }
}
