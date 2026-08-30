import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import '../models/user.dart';
import '../screens/newsfeed_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/custom_font.dart';

class HomeScreen extends StatefulWidget {
  // changed from a plain username string to the full authenticated User
  final User currentUser;
  final int initialIndex;

  const HomeScreen({
    super.key,
    required this.currentUser,
    this.initialIndex = 0,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  // changed to show the authenticated user's name instead of a passed-in string
  String get appBarTitle {
    if (_selectedIndex == 0) return "SocialHub";
    if (_selectedIndex == 1) return "Notifications";
    if (_selectedIndex == 2) return widget.currentUser.fullName;
    return "SocialHub";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: FB_TEXT_COLOR_WHITE,
        elevation: 2,
        title: CustomFont(
          text: appBarTitle,
          fontWeight: FontWeight.bold,
          fontFamily: 'Klavika',
          fontSize: ScreenUtil().setSp(25),
          color: FB_PRIMARY,
        ),
        actions: [
          // added a way into SettingsScreen (and its Sign Out action)
          IconButton(
            icon: Icon(Icons.settings, size: 24.sp, color: FB_PRIMARY),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) => setState(() => _selectedIndex = page),
        children: [
          // changed to pass the authenticated user so posts opened
          // from the newsfeed can load/add real comments, same as posts opened from the profile
          NewsFeedScreen(currentUser: widget.currentUser),
          const NotificationScreen(),
          // changed to pass the authenticated user so posts can be fetched by userId
          ProfileScreen(currentUser: widget.currentUser),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: FB_PRIMARY,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (value) {
          setState(() => _selectedIndex = value);
          _pageController.jumpToPage(value);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
