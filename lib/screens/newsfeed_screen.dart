import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/post_card.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ---------------------------
    // NewsFeed posts
    // ---------------------------
    final posts = <PostCard>[
      PostCard(
        userName: 'Eloisa Puducay',
        postContent: 'Kamusta',
        numOfLikes: 2000,
        date: 'October 11',
        imageUrl:
            'https://www.petplace.com/article/breed/media_15ad72c2fdb39acf09aafa9934912c89bfa08665a.jpeg?width=1200&format=pjpg&optimize=medium',
        profileImageUrl:
            'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?q=80&w=736&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ),
      PostCard(
        userName: 'Janella Elyse',
        postContent: 'Kicking off the holiday season with ICpEP-NCR!',
        numOfLikes: 200,
        date: 'December 2',
        profileImageUrl:
            'https://image.petmd.com/files/inline-images/shiba-inu-black-and-tan-colors.jpg?VersionId=pLq84BE0jdMjXeDCUJ3JLFPuIWsVMUU',
      ),
      PostCard(
        userName: 'Cyrus Robles',
        postContent: 'Hello CCIT!',
        numOfLikes: 120,
        date: 'January 3',
        profileImageUrl:
            'https://images.unsplash.com/photo-1573865526739-10659fec78a5?q=80&w=715&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ),
      PostCard(
        userName: 'Alexia Kaye',
        postContent: 'Study grind 💪',
        numOfLikes: 89,
        date: 'January 10',
        profileImageUrl:
            'https://image.petmd.com/files/inline-images/shiba-inu-black-and-tan-colors.jpg?VersionId=pLq84BE0jdMjXeDCUJ3JLFPuIWsVMUU',
      ),
    ];

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
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
        );
        children.add(SizedBox(height: 6.h));
        children.add(_AdsCarousel(items: adsItems));
        children.add(SizedBox(height: 20.h));
        adsInserted++;
      }
    }

    return ListView(
      padding: EdgeInsets.only(bottom: 20.h),
      children: children,
    );
  }
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
