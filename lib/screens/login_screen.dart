import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import '../widgets/custom_textformfield.dart';
import '../widgets/custom_inkwell_button.dart';
import '../services/user_service.dart';
import 'home_screen.dart';
import '../widgets/custom_dialogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // added to authenticate against dummyjson instead of a hardcoded check
  final UserService _authService = UserService();
  bool _isLoading = false;

  // changed from a local username/password check to a real POST /auth/login call
  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final user = await _authService.login(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(currentUser: user)),
      );
    } catch (e) {
      if (!mounted) return;
      customDialog(
        context,
        title: 'Login Failed',
        content: e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setHeight(40),
                  color: FB_DARK_PRIMARY,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(25),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/SocialHub_logo.png',
                        height: ScreenUtil().setHeight(200),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30)),
                      CustomTextFormField(
                        controller: usernameController,
                        hintText: 'Username',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter your username'
                            : null,
                        onSaved: null,
                        fontSize: ScreenUtil().setSp(15),
                        hintTextSize: ScreenUtil().setSp(15),
                        fontColor: FB_DARK_PRIMARY,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      CustomTextFormField(
                        controller: passwordController,
                        hintText: 'Password',
                        isObscure: true,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter your password'
                            : null,
                        onSaved: null,
                        fontSize: ScreenUtil().setSp(15),
                        hintTextSize: ScreenUtil().setSp(15),
                        fontColor: FB_DARK_PRIMARY,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      // added so testers know which dummyjson account works out of the box
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Try: emilys / emilyspass',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: ScreenUtil().setSp(11),
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30)),
                      CustomInkwellButton(
                        buttonName: _isLoading ? 'Logging in...' : 'Login',
                        height: ScreenUtil().setHeight(40),
                        width: ScreenUtil().screenWidth,
                        fontSize: ScreenUtil().setSp(15),
                        onTap: _isLoading ? () {} : login,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setHeight(40),
                  color: FB_DARK_PRIMARY,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You do not have an account? ',
                        style: TextStyle(
                          color: Colors.grey.shade200,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.popAndPushNamed(context, '/register'),
                        child: Text(
                          'Register here',
                          style: TextStyle(
                            color: FB_LIGHT_PRIMARY,
                            fontSize: ScreenUtil().setSp(15),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
