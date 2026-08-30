import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../services/user_service.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_font.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserService _authService = UserService();
  bool _isSigningOut = false;

  // clears the saved session then sends the user
  // back to the login screen
  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);

    await _authService.logout();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // shows a confirmation dialog before signing out
  // so the user can choose Cancel or Sign Out
  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will need to log in again to continue.'),
        actions: [
          // Cancel closes the confirmation dialog
          // without signing the user out
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),

          // Sign Out confirms the action
          // and calls the logout function
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FB_DARK_PRIMARY,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              _signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sign Out was removed from the AppBar
      // and is now placed below the Dark Mode preference
      appBar: AppBar(
        shadowColor: FB_TEXT_COLOR_WHITE,
        elevation: 2,
        title: CustomFont(
          text: 'Settings',
          fontWeight: FontWeight.bold,
          fontFamily: 'Klavika',
          fontSize: ScreenUtil().setSp(25),
          color: FB_PRIMARY,
        ),
      ),

      body: ListView(
        children: [
          SizedBox(height: 8.h),

          // (Enhancement 2 - Dark Mode Preference): the Dark Mode
          // toggle is the user preference control on this screen
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeProvider.themeMode,
            builder: (context, mode, _) {
              return ListTile(
                leading: const Icon(
                  Icons.dark_mode_outlined,
                  color: FB_DARK_PRIMARY,
                ),
                title: CustomFont(
                  text: 'Dark Mode',
                  fontWeight: FontWeight.w600,
                ),
                subtitle: CustomFont(
                  text: mode == ThemeMode.dark ? 'On' : 'Off',
                  fontSize: ScreenUtil().setSp(12),
                  color: Colors.grey,
                ),
                trailing: Switch(
                  value: mode == ThemeMode.dark,
                  activeColor: FB_PRIMARY,

                  // (Enhancement 2): updates the user's
                  // Dark Mode preference through ThemeProvider
                  onChanged: (value) {
                    ThemeProvider.setDarkMode(value);
                  },
                ),
              );
            },
          ),

          const Divider(height: 1),

          // (Enhancement 2): Sign Out is placed below Dark Mode
          // instead of being displayed in the AppBar
          ListTile(
            leading: const Icon(Icons.logout, color: FB_DARK_PRIMARY),
            title: CustomFont(text: 'Sign Out', fontWeight: FontWeight.w600),
            subtitle: CustomFont(
              text: 'Sign out of your account',
              fontSize: ScreenUtil().setSp(12),
              color: Colors.grey,
            ),

            // (Enhancement 2): displays a loading indicator
            // while the logout process is running
            trailing: _isSigningOut
                ? SizedBox(
                    width: 20.sp,
                    height: 20.sp,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color: Colors.grey,
                  ),

            // (Enhancement 2): tapping Sign Out opens the
            // confirmation dialog instead of immediately signing out
            onTap: _isSigningOut ? null : _confirmSignOut,
          ),
        ],
      ),
    );
  }
}
