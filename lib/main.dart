import 'package:puducay_mobprog/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puducay_mobprog/screens/register_screen.dart';
import 'package:puducay_mobprog/screens/splash_screen.dart';
import 'package:puducay_mobprog/providers/theme_provider.dart';

// changed to async so the saved dark/light preference is loaded before the first frame is drawn
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeProvider.loadSavedTheme();
  runApp(const PuducayFacebook());
}

class PuducayFacebook extends StatelessWidget {
  const PuducayFacebook({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        // added: rebuilds MaterialApp whenever ThemeProvider's mode changes
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeProvider.themeMode,
          builder: (context, mode, __) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Facebook Replication',
              themeMode: mode,
              theme: ThemeProvider.lightTheme,
              darkTheme: ThemeProvider.darkTheme,
              initialRoute: '/splash',
              routes: {
                // removed the '/newsfeed' named route — it was dead
                // code (nothing called Navigator.pushNamed(context, '/newsfeed')) and NewsFeedScreen
                // now requires a currentUser, which a route table has no way to supply. The real
                // flow is splash -> login -> HomeScreen, which builds NewsFeedScreen itself.
                '/login': (context) => const LoginScreen(),
                '/register': (context) => const RegisterScreen(),
                '/splash': (context) => const SplashScreen(),
              },
            );
          },
        );
      },
    );
  }
}
