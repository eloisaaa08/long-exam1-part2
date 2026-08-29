// added this model to represent a comment returned by dummyjson's /comments endpoints for enhancement 3
class Comment {
  final int id;
  final int postId;
  final String body;
  final int likes;
  final String userName;
  final int userId;

  Comment({
    required this.id,
    required this.postId,
    required this.body,
    required this.likes,
    required this.userName,
    required this.userId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return Comment(
      id: json['id'] ?? 0,
      postId: json['postId'] ?? 0,
      body: json['body'] ?? '',
      likes: json['likes'] ?? 0,
      userName: (user is Map && user['username'] != null)
          ? user['username']
          : 'user',
      userId: (user is Map && user['id'] != null) ? user['id'] as int : 0,
    );
  }

  // used to update the like count locally right after a successful like toggle
  Comment copyWith({int? likes}) => Comment(
    id: id,
    postId: postId,
    body: body,
    likes: likes ?? this.likes,
    userName: userName,
    userId: userId,
  );
}
