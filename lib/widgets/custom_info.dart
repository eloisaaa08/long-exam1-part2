import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/detail_screen.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.name,
    required this.post,
    required this.description,
    this.profileImageUrl = '',
    required this.date,
    required this.numOfLikes,
    this.imageUrl = '',
  });

  final String name;
  final String post;
  final String description;
  final String profileImageUrl;
  final String date;
  final int numOfLikes;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(
              userName: name,
              postContent: description,
              date: date,
              numOfLikes: numOfLikes,
              imageUrl: imageUrl,
              profileImageUrl: profileImageUrl,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
        child: Row(
          children: [
            (profileImageUrl.isEmpty)
                ? Icon(Icons.person, size: 40.sp)
                : CircleAvatar(
                    radius: 20.sp,
                    backgroundImage: AssetImage(profileImageUrl),
                  ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Posted: $post', style: TextStyle(fontSize: 14.sp)),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '$numOfLikes likes • $date',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.more_horiz),
          ],
        ),
      ),
    );
  }
}
