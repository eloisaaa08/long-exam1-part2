import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/comment.dart';
import '../models/user.dart';
import '../services/comment_service.dart';

class DetailScreen extends StatefulWidget {
  final String userName;
  final String postContent;
  final String date;
  final String imageUrl;
  final String profileImageUrl;
  int numOfLikes;
  // added so this post's real comments can be loaded/posted through dummyjson
  final int? postId;
  final User? currentUser;

  DetailScreen({
    super.key,
    required this.userName,
    required this.postContent,
    required this.date,
    required this.numOfLikes,
    this.imageUrl = '',
    this.profileImageUrl = '',
    this.postId,
    this.currentUser,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int likes;

  // comment loading/posting state
  final CommentService _commentService = CommentService();
  final TextEditingController _commentController = TextEditingController();
  List<Comment> _comments = [];
  bool _isLoadingComments = false;
  bool _isPostingComment = false;
  String? _commentsError;

  @override
  void initState() {
    super.initState();
    likes = widget.numOfLikes;
    // only posts that came from the api (i.e. have a real postId) have comments to fetch
    if (widget.postId != null) {
      _loadComments();
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // added to fetch every comment tied to this post from dummyjson
  Future<void> _loadComments() async {
    setState(() {
      _isLoadingComments = true;
      _commentsError = null;
    });

    try {
      final comments = await _commentService.getCommentsByPostId(
        widget.postId!,
      );
      if (!mounted) return;
      setState(() => _comments = comments);
    } catch (e) {
      if (!mounted) return;
      setState(
        () => _commentsError = 'Could not load comments. Pull to retry.',
      );
    } finally {
      if (mounted) setState(() => _isLoadingComments = false);
    }
  }

  // added to make each comment's like button interactive and sync the new count to the api
  Future<void> _toggleCommentLike(int index) async {
    final comment = _comments[index];
    final newLikes = comment.likes + 1;

    setState(() {
      _comments[index] = comment.copyWith(likes: newLikes);
    });

    try {
      await _commentService.updateCommentLikes(comment.id, newLikes);
    } catch (_) {
      // dummyjson comments created locally (via /comments/add) aren't real
      // records on their server, so a failed sync here is expected and the
      // optimistic local like count is left as-is
    }
  }

  // added to let the user post a new comment on this post
  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    if (widget.postId == null) {
      // no real post behind this card (e.g. a static demo post) - just show it locally
      setState(() {
        _comments = [
          Comment(
            id: DateTime.now().millisecondsSinceEpoch,
            postId: 0,
            body: text,
            likes: 0,
            userName: widget.currentUser?.username ?? 'you',
            userId: widget.currentUser?.id ?? 0,
          ),
          ..._comments,
        ];
        _commentController.clear();
      });
      return;
    }

    setState(() => _isPostingComment = true);
    try {
      final newComment = await _commentService.addComment(
        postId: widget.postId!,
        body: text,
        userId: widget.currentUser?.id ?? 0,
      );
      if (!mounted) return;
      setState(() {
        _comments = [newComment, ..._comments];
        _commentController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not post comment. Please try again.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isPostingComment = false);
    }
  }

  Widget _buildCommentsSection() {
    if (_isLoadingComments) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_commentsError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(_commentsError!, style: const TextStyle(color: Colors.grey)),
            TextButton(onPressed: _loadComments, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text('No comments yet.', style: TextStyle(color: Colors.grey)),
      );
    }

    return Column(
      children: List.generate(_comments.length, (index) {
        final comment = _comments[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14.sp,
                child: const Icon(Icons.person, size: 16),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2.h),
                      Text(comment.body),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              // added the interactive comment-like button
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.thumb_up_outlined,
                      size: 18.sp,
                      color: Colors.teal,
                    ),
                    onPressed: () => _toggleCommentLike(index),
                  ),
                  Text(
                    comment.likes.toString(),
                    style: TextStyle(fontSize: 11.sp),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.imageUrl.isNotEmpty)
                Image.asset(widget.imageUrl, width: double.infinity),
              SizedBox(height: 10.h),
              Row(
                children: [
                  widget.profileImageUrl.isEmpty
                      ? Icon(Icons.person, size: 40.sp)
                      : CircleAvatar(
                          radius: 20.sp,
                          backgroundImage: AssetImage(widget.profileImageUrl),
                        ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.userName),
                      Text(
                        widget.date,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(widget.postContent),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        likes++;
                      });
                    },
                    icon: const Icon(Icons.thumb_up, color: Colors.teal),
                    label: Text(likes == 0 ? 'Like' : likes.toString()),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.comment, color: Colors.teal),
                    label: const Text('Comment'),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share, color: Colors.teal),
                    label: const Text('Share'),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text(
                'Comments',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              // added the add-a-comment input + comments list
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _isPostingComment
                      ? SizedBox(
                          width: 20.sp,
                          height: 20.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send, color: Colors.teal),
                          onPressed: _submitComment,
                        ),
                ],
              ),
              SizedBox(height: 8.h),
              _buildCommentsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
