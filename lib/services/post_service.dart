// added this service to fetch a user's own posts from dummyjson
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  static const String _host = 'https://dummyjson.com';

  // calls GET /posts so the newsfeed can render real dummyjson
  // posts instead of the old hardcoded PostCard list
  Future<List<Post>> getAllPosts({int limit = 12}) async {
    final uri = Uri.parse('$_host/posts?limit=$limit');
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

  // calls GET /posts/user/{userId} so ProfileScreen can render posts that belong to the logged-in user
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
