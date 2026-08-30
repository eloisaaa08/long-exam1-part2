import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constants.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_button.dart';
import '../widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  // changed from a plain username string to the full authenticated User so posts can be
  // fetched by userId and the About tab can show real contact info
  final User currentUser;

  const ProfileScreen({super.key, required this.currentUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // fetches this user's posts from dummyjson
  final PostService _postService = PostService();
  late Future<List<Post>> _postsFuture;

  // ✅ network photos for Photos tab
  final List<String> photoUrls = [
    'https://www.petplace.com/article/breed/media_15ad72c2fdb39acf09aafa9934912c89bfa08665a.jpeg?width=1200&format=pjpg&optimize=medium',
    'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?q=80&w=736&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1573865526739-10659fec78a5?q=80&w=715&auto=format&fit=crop',
    'https://hips.hearstapps.com/hmg-prod/images/shibainu-dog-royalty-free-image-1752089989.pjpeg?crop=1xw:1xh;center,top',
    'https://i.guim.co.uk/img/media/f5f48c15a993315efb3faa88e4980b5e661d0487/0_0_2420_1936/master/2420.jpg?width=620&dpr=2&s=none&crop=none',
    'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=1200&auto=format&fit=crop',
  ];

  @override
  void initState() {
    super.initState();
    // added a feature so the profile screen fetches posts filtered to the authenticated user's id
    _postsFuture = _postService.getPostsByUserId(widget.currentUser.id);
  }

  // added to let the user pull-to-retry if the initial fetch fails
  void _retryLoadPosts() {
    setState(() {
      _postsFuture = _postService.getPostsByUserId(widget.currentUser.id);
    });
  }

  // ✅ revised Photos widget (Grid + tap opens dialog)
  Widget _photos() {
    return GridView.count(
      primary: false,
      padding: EdgeInsets.all(10.sp),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 5.w,
      mainAxisSpacing: 5.h,
      childAspectRatio: 1,
      children: List.generate(photoUrls.length, (index) {
        final url = photoUrls[index];

        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: Colors.black,
                          child: InteractiveViewer(
                            minScale: 0.8,
                            maxScale: 4.0,
                            child: CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.contain,
                              placeholder: (_, __) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (_, __, ___) => const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ✅ Close (X)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Material(
                          color: Colors.black54,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => Navigator.pop(context),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },

          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.sp),
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (context, _) => Container(color: Colors.grey[300]),
              errorWidget: (context, _, __) => const Icon(Icons.error),
            ),
          ),
        );
      }),
    );
  }

  // changed from a hardcoded list of InkWell+PostCard entries to a FutureBuilder that renders
  // whatever dummyjson returns for this user's id
  Widget _postsTab() {
    return FutureBuilder<List<Post>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                const Text(
                  'Could not load posts.',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: _retryLoadPosts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final posts = snapshot.data ?? [];
        if (posts.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('No posts yet.')),
          );
        }

        return ListView(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: posts.map((post) {
            // dummyjson posts have no real timestamp, so this mirrors what a freshly-fetched feed would show
            return PostCard(
              userName: widget.currentUser.fullName,
              postContent: post.body,
              numOfLikes: post.likes,
              date: 'Just now',
              profileImageUrl: widget.currentUser.image,
              postId: post.id,
              currentUser: widget.currentUser,
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Photo & Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          'https://i.guim.co.uk/img/media/f5f48c15a993315efb3faa88e4980b5e661d0487/0_0_2420_1936/master/2420.jpg?width=620&dpr=2&s=none&crop=none',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: ScreenUtil().setWidth(20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // changed to show the authenticated user's own avatar from dummyjson
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: widget.currentUser.image.isNotEmpty
                              ? CachedNetworkImageProvider(
                                  widget.currentUser.image,
                                )
                              : const CachedNetworkImageProvider(
                                  'https://hips.hearstapps.com/hmg-prod/images/shibainu-dog-royalty-free-image-1752089989.pjpeg?crop=1xw:1xh;center,top',
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey,
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(55)),

              // Name, Followers, Buttons
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFont(
                      text: widget.currentUser.fullName, // ✅ dynamic name
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(20),
                      color: Colors.black,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    Row(
                      children: [
                        CustomFont(
                          text: '5M',
                          fontSize: ScreenUtil().setSp(15),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomFont(
                          text: 'followers',
                          fontSize: ScreenUtil().setSp(15),
                          color: Colors.grey,
                          fontWeight: FontWeight.w100,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(5)),
                        Icon(
                          Icons.circle,
                          size: ScreenUtil().setSp(5),
                          color: Colors.grey,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(5)),
                        CustomFont(
                          text: '5',
                          fontSize: ScreenUtil().setSp(15),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomFont(
                          text: 'following',
                          fontSize: ScreenUtil().setSp(15),
                          color: Colors.grey,
                          fontWeight: FontWeight.w100,
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Row(
                      children: [
                        CustomButton(buttonName: 'Follow', onPressed: () {}),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomButton(
                          buttonName: 'Message',
                          onPressed: () {},
                          buttonType: 'outlined',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),

              // Tabs
              TabBar(
                indicatorColor: FB_DARK_PRIMARY,
                tabs: [
                  Tab(
                    child: CustomFont(
                      text: 'Posts',
                      fontSize: ScreenUtil().setSp(15),
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    child: CustomFont(
                      text: 'About',
                      fontSize: ScreenUtil().setSp(15),
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    child: CustomFont(
                      text: 'Photos',
                      fontSize: ScreenUtil().setSp(15),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              // Tab Views
              SizedBox(
                height: ScreenUtil().setHeight(2000),
                child: TabBarView(
                  children: [
                    // ================= POSTS TAB (now backed by the api) =================
                    _postsTab(),

                    // ================= ABOUT TAB =================
                    SingleChildScrollView(
                      padding: EdgeInsets.all(20.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Intro',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),

                          Row(
                            children: [
                              Icon(
                                Icons.school,
                                size: 20.sp,
                                color: Colors.grey[700],
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Studied Information Technology at National University',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(5)),

                          Row(
                            children: [
                              Icon(
                                Icons.home,
                                size: 20.sp,
                                color: Colors.grey[700],
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Lives in Quezon City, Philippines',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(5)),

                          Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 20.sp,
                                color: Colors.grey[700],
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Single',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: ScreenUtil().setHeight(20)),

                          Text(
                            'Hobbies',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),

                          Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: const [
                              Chip(label: Text('Working out')),
                              Chip(label: Text('Cooking')),
                              Chip(label: Text('Photography')),
                              Chip(label: Text('Traveling')),
                            ],
                          ),

                          SizedBox(height: ScreenUtil().setHeight(20)),

                          Text(
                            'Contact Info',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),

                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                size: 20.sp,
                                color: Colors.grey[700],
                              ),
                              SizedBox(width: 8.w),
                              // changed to show the authenticated user's real email
                              Text(
                                widget.currentUser.email,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(5)),

                          Row(
                            children: [
                              Icon(
                                Icons.alternate_email,
                                size: 20.sp,
                                color: Colors.grey[700],
                              ),
                              SizedBox(width: 8.w),
                              // changed to show the authenticated user's dummyjson username
                              Text(
                                '@${widget.currentUser.username}',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ================= PHOTOS TAB ✅ =================
                    _photos(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
