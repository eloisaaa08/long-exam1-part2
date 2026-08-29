import 'dart:async';
import 'dart:math';
import 'package:puducay_mobprog/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/user_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  final List<_Particle> _particles = [];
  // added so splash can decide between /home and /login for enhancement 1
  final UserService _authService = UserService();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulse = Tween<double>(
      begin: 0.3,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    for (int i = 0; i < 22; i++) {
      _particles.add(_Particle.random());
    }

    getIsLogin();
  }

  // changed to check UserService for a saved session instead of always going to /login, for enhancement 1
  void getIsLogin() {
    Timer(const Duration(seconds: 4), () async {
      final bool loggedIn = await _authService.isLoggedIn();
      final user = loggedIn ? await _authService.getSavedUser() : null;
      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(currentUser: user)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _ParticlePainter(_particles),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [FB_PRIMARY, FB_SECONDARY, FB_DARK_PRIMARY],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // MORE top space removed = higher content
                  SizedBox(height: ScreenUtil().setHeight(50)),

                  // Glow
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, __) {
                      return Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: FB_LIGHT_PRIMARY.withOpacity(
                            _pulse.value * 0.22,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: FB_LIGHT_PRIMARY.withOpacity(
                                _pulse.value * 0.8,
                              ),
                              blurRadius: 110,
                              spreadRadius: 45,
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 4),

                  // Bright Logo
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: FB_LIGHT_PRIMARY.withOpacity(0.8),
                              blurRadius: 70,
                              spreadRadius: 25,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 165,
                        height: 165,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              FB_TEXT_COLOR_WHITE.withOpacity(0.35),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.18),
                          BlendMode.screen,
                        ),
                        child: Image.asset(
                          'assets/images/SocialHub_logo.png',
                          height: ScreenUtil().setHeight(145),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // BIGGER Tagline
                  Text(
                    "Connect. Share. Belong.",
                    style: TextStyle(
                      color: FB_TEXT_COLOR_WHITE.withOpacity(0.97),
                      fontSize: 19, // bigger
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Your circle, your space",
                    style: TextStyle(
                      color: FB_TEXT_COLOR_WHITE.withOpacity(0.75),
                      fontSize: 14, // bigger
                      letterSpacing: 0.9,
                    ),
                  ),

                  // Push loader DOWN
                  const Spacer(),

                  // Loader at very bottom
                  Column(
                    children: const [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.8,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FB_TEXT_COLOR_WHITE,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Connecting...",
                        style: TextStyle(
                          color: FB_TEXT_COLOR_WHITE,
                          fontSize: 13,
                          letterSpacing: 0.9,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/* ---------------- PARTICLES ---------------- */

class _Particle {
  double x;
  double y;
  double r;
  double speed;
  double dx;

  _Particle(this.x, this.y, this.r, this.speed, this.dx);

  factory _Particle.random() {
    final rand = Random();
    return _Particle(
      rand.nextDouble(),
      rand.nextDouble(),
      rand.nextDouble() * 3 + 1,
      rand.nextDouble() * 0.002 + 0.001,
      rand.nextDouble() * 0.004 - 0.002,
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = FB_TEXT_COLOR_WHITE.withOpacity(0.15);

    for (final p in particles) {
      p.y -= p.speed;
      p.x += p.dx;

      if (p.y < 0) p.y = 1;
      if (p.x < 0 || p.x > 1) p.dx *= -1;

      final pos = Offset(p.x * size.width, p.y * size.height);
      canvas.drawCircle(pos, p.r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
