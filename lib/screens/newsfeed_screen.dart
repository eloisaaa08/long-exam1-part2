// rewritten so the newsfeed renders real dummyjson posts
// (with each poster's real name/avatar) instead of the old hardcoded PostCard list
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../widgets/post_card.dart';

class NewsFeedScreen extends StatefulWidget {
  // (Newsfeed Update): the logged-in user is threaded through so posts opened from
  // the newsfeed can load/add real comments on the detail screen, same as the profile screen
  final User currentUser;

  const NewsFeedScreen({super.key, required this.currentUser});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  // loads dummyjson posts and every dummyjson user together so each
  // post can be paired with its author's real name/avatar (instead of "User <id>") for display
  late Future<_NewsFeedData> _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = _loadFeed();
  }

  Future<_NewsFeedData> _loadFeed() async {
    final results = await Future.wait([
      _postService.getAllPosts(),
      _userService.getAllUsers(),
    ]);
    return _NewsFeedData(
      posts: results[0] as List<Post>,
      usersById: results[1] as Map<int, User>,
    );
  }

  void _retryLoadFeed() {
    setState(() => _feedFuture = _loadFeed());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_NewsFeedData>(
      future: _feedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Could not load the newsfeed.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: _retryLoadFeed,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final data = snapshot.data!;

        // (Newsfeed Update): each PostCard now gets the real poster's name/avatar
        // (falling back to "User <id>" only if dummyjson has no matching user record) instead
        // of the previously hardcoded userName/profileImageUrl values
        final posts = data.posts.map((post) {
          final author = data.usersById[post.userId];
          return PostCard(
            userName: author?.fullName ?? 'User ${post.userId}',
            postContent: post.body,
            numOfLikes: post.likes,
            date: 'Just now',
            profileImageUrl: author?.image ?? '',
            postId: post.id,
            currentUser: widget.currentUser,
          );
        }).toList();

        // ---------------------------
        // Advertisement posts
        // ---------------------------
        final adsItems = buildAdsItems(count: 7); // 5-7 items

        // ---------------------------
        // Build feed: alternate post -> ad (max 4)
        // ---------------------------
        final children = <Widget>[];
        int adsInserted = 0;

        for (int i = 0; i < posts.length; i++) {
          children.add(posts[i]);
          children.add(SizedBox(height: 12.h));

          if (adsInserted < 4) {
            // Advertisement section with title
            children.add(
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  'Advertisement / Promotion',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
            children.add(SizedBox(height: 6.h));
            children.add(_AdsCarousel(items: adsItems));
            children.add(SizedBox(height: 20.h));
            adsInserted++;
          }
        }

        return RefreshIndicator(
          onRefresh: () async => _retryLoadFeed(),
          child: ListView(
            padding: EdgeInsets.only(bottom: 20.h),
            children: children,
          ),
        );
      },
    );
  }
}

// (Newsfeed Update): small holder so posts + the users map load together via Future.wait
class _NewsFeedData {
  final List<Post> posts;
  final Map<int, User> usersById;

  _NewsFeedData({required this.posts, required this.usersById});
}

// ---------------------------
// Carousel widget for Ads
// ---------------------------
class _AdsCarousel extends StatelessWidget {
  final List<Widget> items;
  const _AdsCarousel({required this.items});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 311.h,
        viewportFraction: 0.85,
        enableInfiniteScroll: false,
        padEnds: false,
      ),
      items: items,
    );
  }
}

// ---------------------------
// Advertisement items
// ---------------------------
List<Widget> buildAdsItems({int count = 7}) {
  final items = <PostCard>[];

  // Using reliable Wikimedia and Unsplash assets
  final List<Map<String, String>> adData = [
    {
      'userName': 'Grab',
      'profileImage':
          'https://images.seeklogo.com/logo-png/62/1/grab-logo-png_seeklogo-622162.png',
      'image':
          'https://assets.bwbx.io/images/users/iqjWHBFdfxIU/i3EoE8yy1r5I/v1/1800x1200.webp',
      'adsMarket': 'GrabFood & Rides',
    },
    {
      'userName': 'Lazada',
      'profileImage':
          'https://toppng.com/uploads/preview/1-12-11739919224b2gxgrrvog.webp',
      'image':
          'https://i0.wp.com/peopleasia.ph/wp-content/uploads/2021/05/Lazada-6.6-Halfy-Mid-Year-Sale-with-New-Lazada-PH-Brand-Ambassador-Alden-Richards-scaled.jpg?resize=800%2C500&ssl=1',
      'adsMarket': 'Official Mall Deals',
    },
    {
      'userName': 'Shopee',
      'profileImage':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Shopee_logo.svg/500px-Shopee_logo.svg.png?20191103132225',
      'image':
          'https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a?auto=format&fit=crop&w=800&q=80',
      'adsMarket': 'Free Shipping Nationwide!',
    },
    {
      'userName': 'Foodpanda',
      'profileImage':
          'https://static.vecteezy.com/system/resources/previews/067/941/692/large_2x/foodpanda-logo-rounded-hd-free-png.png',
      'image':
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1800&q=80',
      'adsMarket': 'Fast Food Delivery',
    },
    {
      'userName': 'Jollibee',
      'profileImage':
          'https://e7.pngegg.com/pngimages/650/155/png-clipart-jollibee-logo-restaurant-logos.png',
      'image':
          'https://www.adobomagazine.com/wp-content/uploads/2021/02/Joshua-Garcia-stars-in-beefy-new-Jollibee-Yumburger-commercial-HERO.jpg',
      'adsMarket': 'Fast Food Favorites',
    },
    {
      'userName': 'Netflix',
      'profileImage':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Netflix_icon.svg/960px-Netflix_icon.svg.png?20220806170125',
      'image':
          'https://images.unsplash.com/photo-1524985069026-dd778a71c7b4?auto=format&fit=crop&w=1800&q=80',
      'adsMarket': 'Unlimited Movies & Series',
    },
    {
      'userName': 'Globe',
      'profileImage':
          'https://cdn.prod.website-files.com/67528de23bee2c4c08297aef/677acb91fc5918f6d8542a8a_Globe%20Square%20Logo%20600x600.png',
      'image':
          'https://www.globe.com.ph/sites/default/files/2025-08/newsroom-consumer-gfiber-prepaid-todomax-inarticle-image.jpg',
      'adsMarket': 'Fast Mobile Internet',
    },
  ];

  for (int i = 0; i < count; i++) {
    // Cycles through the 3 brands based on the count
    final data = adData[i % adData.length];

    items.add(
      PostCard(
        userName: data['userName']!,
        postContent: 'Check this amazing deal!',
        date: 'January 1',
        imageUrl: data['image']!,
        profileImageUrl: data['profileImage']!,
        isAds: true,
        adsMarket: data['adsMarket']!,
      ),
    );
  }

  return items;
}
