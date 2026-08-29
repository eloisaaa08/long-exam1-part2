// added this service to fetch a user's own posts from dummyjson for enhancement 2
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  static const String _host = 'https://dummyjson.com';

  // calls GET /posts/user/{userId} so ProfileScreen can render posts that belong to the logged-in user for enhancement 2
  Future<List<Post>> getPostsByUserId(int userId) async {
    final uri = Uri.parse('$_host/posts/user/$userId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> postsJson = data['posts'] ?? [];
      return postsJson
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load posts (status ${response.statusCode})');
  }
}
