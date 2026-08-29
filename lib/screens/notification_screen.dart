import '../widgets/custom_info.dart' as notif;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'name': 'Janella Elyse Arceo',
      'post': 'New Photo',
      'description': 'Kicking off the holiday season with ICpEP-NCR!',
      'profileImageUrl': 'assets/images/janella 1.jpg',
      'imageUrl': 'assets/images/owl.jpg',
      'date': 'December 2',
    },
    {
      'name': 'Mia Santos',
      'post': 'Shared a photo',
      'description': 'Throwback to our beach trip!',
      'imageUrl': 'assets/images/throwback.jpg',
      'date': 'October 9',
      'numOfLikes': 15,
    },
    {
      'name': 'Carlos Reyes',
      'post': 'Mention',
      'description': 'Mentioned you in a post.',
      'profileImageUrl': 'assets/images/boy 2.jpeg',
      'date': 'December 3',
      'numOfLikes': 10,
    },
    {
      'name': 'Anna Dela Cruz',
      'post': 'Reaction',
      'description': 'Liked your recent post.',
      'profileImageUrl': 'assets/images/girl 3.jpeg',
      'date': 'December 4',
      'numOfLikes': 75,
    },
    {
      'name': 'Liam Rodriguez',
      'post': 'Friend Request',
      'description': 'Sent you a friend request.',
      'profileImageUrl': 'assets/images/boy 3.jpeg',
      'date': 'December 5',
      'numOfLikes': 0,
    },
    {
      'name': 'Sofia Hernandez',
      'post': 'Story Update',
      'description': 'Posted a new story.',
      'profileImageUrl': 'assets/images/girl 4.jpeg',
      'imageUrl': 'assets/images/story.jpg',
      'date': 'December 6',
      'numOfLikes': 120,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return notif.NotificationWidget(
            name: item['name'],
            post: item['post'],
            description: item['description'],
            profileImageUrl: item['profileImageUrl'] ?? '',
            imageUrl: item['imageUrl'] ?? '',
            date: item['date'],
            
            
            numOfLikes: item['numOfLikes'] ?? 0,
          );
        },
      ),
    );
  }
}
