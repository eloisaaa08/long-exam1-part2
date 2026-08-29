import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_inkwell_button.dart';
import '../screens/detail_screen.dart';
import '../models/user.dart';

import '../constants.dart';
import 'custom_font.dart';

import 'package:flutter/material.dart';

bool isNetworkImage(String path) {
  return path.startsWith('http://') || path.startsWith('https://');
}

Widget smartImage(
  String path, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  if (isNetworkImage(path)) {
    return CachedNetworkImage(
      imageUrl: path,
      fit: fit,
      width: width,
      height: height,
      placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
      errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
    );
  }

  return Image.asset(
    path,
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
  );
}

ImageProvider smartImageProvider(String path) {
  if (isNetworkImage(path)) return CachedNetworkImageProvider(path);
  return AssetImage(path);
}

// ignore: must_be_immutable
class PostCard extends StatefulWidget {
  final String userName;
  final String postContent;
  final String date;
  int numOfLikes;
  final bool hasImage;
  final String? imagePath;
  final String? avatarPath;
  final String imageUrl;
  final String profileImageUrl;
  final bool isAds;
  final String adsMarket;
  // added so posts backed by dummyjson can load/add real comments on the detail screen for enhancement 3
  final int? postId;
  final User? currentUser;

  PostCard({
    super.key,
    required this.userName,
    required this.postContent,
    this.numOfLikes = 0,
    required this.date,
    this.hasImage = false,
    this.imagePath,
    this.avatarPath,
    this.imageUrl = "",
    this.profileImageUrl = "",
    this.isAds = false,
    this.adsMarket = "",
    this.postId,
    this.currentUser,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          // Navigator.pushNamed(context, ./detail );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                userName: widget.userName,
                postContent: widget.postContent,
                date: widget.date,
                numOfLikes: widget.numOfLikes,
                imageUrl: widget.imageUrl,
                profileImageUrl: widget.profileImageUrl,
                postId: widget.postId,
                currentUser: widget.currentUser,
              ),
            ),
          ),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setSp(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.profileImageUrl.isEmpty
                      ? const Icon(Icons.person)
                      : CircleAvatar(
                          radius: 15,
                          backgroundImage: smartImageProvider(
                            widget.profileImageUrl,
                          ),
                          backgroundColor: Colors.grey[300],
                        ),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: widget.userName,
                        fontSize: ScreenUtil().setSp(15),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomFont(
                            text: widget.date,
                            fontSize: ScreenUtil().setSp(12),
                            color: Colors.grey,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(3)),
                          Icon(
                            Icons.public,
                            color: Colors.grey,
                            size: ScreenUtil().setSp(15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.more_horiz),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(5)),
              CustomFont(
                text: widget.postContent,
                fontSize: ScreenUtil().setSp(12),
                color: Colors.black,
              ),
              SizedBox(height: ScreenUtil().setHeight(5)),
              if (widget.imageUrl.isNotEmpty) ...[
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: smartImage(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
              ],
              (widget.adsMarket != "")
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            print('Liked');
                            setState(() {
                              widget.numOfLikes++;
                            });
                          },
                          icon: const Icon(
                            Icons.thumb_up,
                            color: FB_DARK_PRIMARY,
                          ),
                          label: CustomFont(
                            text: (widget.numOfLikes == 0)
                                ? 'Like'
                                : widget.numOfLikes.toString(),
                            fontSize: ScreenUtil().setSp(13),
                            color: FB_DARK_PRIMARY,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.comment,
                            color: FB_DARK_PRIMARY,
                          ),
                          label: CustomFont(
                            text: 'Comment',
                            fontSize: ScreenUtil().setSp(13),
                            color: FB_DARK_PRIMARY,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.redo, color: FB_DARK_PRIMARY),
                          label: CustomFont(
                            text: 'Share',
                            fontSize: ScreenUtil().setSp(13),
                            color: FB_DARK_PRIMARY,
                          ),
                        ),
                      ],
                    ),

              (widget.adsMarket != "")
                  ? Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Row(
                        children: [
                          // ✅ para di mag overflow ang text column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomFont(
                                  text: 'MORE DETAILS',
                                  fontSize: 13.sp, // ✅ smaller
                                  color: Colors.black,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  widget.adsMarket,
                                  maxLines: 1, // ✅ prevent wrap
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 8.w),

                          // ✅ bawasan height ng button para hindi sumobra
                          SizedBox(
                            height: 34.h,
                            child: CustomInkwellButton(
                              width: 46.w,
                              height: 34.h,
                              icon: Icon(
                                Icons.arrow_right_alt,
                                color: FB_LIGHT_PRIMARY,
                                size: 22.sp,
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    userName: widget.userName,
                                    postContent: widget.postContent,
                                    date: widget.date,
                                    numOfLikes: widget.numOfLikes,
                                    imageUrl: widget.imageUrl,
                                    profileImageUrl: widget.profileImageUrl,
                                    postId: widget.postId,
                                    currentUser: widget.currentUser,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
