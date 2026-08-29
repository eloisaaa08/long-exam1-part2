// this screen gives the user a place to toggle dark mode and sign out
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

  // clears the saved session then sends the user back to the login screen
  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    await _authService.logout();
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will need to log in again to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
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

          // added the Dark Mode toggle; reads/writes ThemeProvider so the switch
          // stays in sync with the mode actually applied to MaterialApp
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
                  onChanged: (value) => ThemeProvider.setDarkMode(value),
                ),
              );
            },
          ),
          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.logout, color: FB_DARK_PRIMARY),
            title: CustomFont(text: 'Sign Out', fontWeight: FontWeight.w600),
            trailing: _isSigningOut
                ? SizedBox(
                    width: 18.sp,
                    height: 18.sp,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chevron_right),
            onTap: _isSigningOut ? null : _confirmSignOut,
          ),
        ],
      ),
    );
  }
}
