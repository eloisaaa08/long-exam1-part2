// added this service to load and post comments per post for enhancement 3
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/comment.dart';

class CommentService {
  static const String _host = 'https://dummyjson.com';

  // calls GET /comments/post/{postId} to load every comment that belongs to a post for enhancement 3
  Future<List<Comment>> getCommentsByPostId(int postId) async {
    final uri = Uri.parse('$_host/comments/post/$postId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> commentsJson = data['comments'] ?? [];
      return commentsJson
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(
      'Failed to load comments for post $postId (status ${response.statusCode})',
    );
  }

  // added a feature so users can add a comment to a post for enhancement 3
  Future<Comment> addComment({
    required int postId,
    required String body,
    required int userId,
  }) async {
    final uri = Uri.parse('$_host/comments/add');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'body': body, 'postId': postId, 'userId': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Comment.fromJson(data);
    }
    throw Exception('Failed to add comment (status ${response.statusCode})');
  }

  // added a feature to make the comment like button interactive by pushing the new count to the api for enhancement 3
  Future<void> updateCommentLikes(int commentId, int newLikes) async {
    final uri = Uri.parse('$_host/comments/$commentId');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'likes': newLikes}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update comment likes (status ${response.statusCode})',
      );
    }
    // dummyjson is a mock api and doesn't really persist this, so the UI trusts
    // the local optimistic update once the call succeeds
  }
}
