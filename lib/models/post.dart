// added this model to represent a post returned by dummyjson's /posts endpoints for enhancement 2
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  int likes;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final reactions = json['reactions'];
    return Post(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      likes: (reactions is Map && reactions['likes'] != null)
          ? reactions['likes'] as int
          : 0,
    );
  }
}
