import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puducay_mobprog/constants.dart';
import 'package:puducay_mobprog/widgets/custom_font.dart';
import 'package:puducay_mobprog/widgets/custom_inkwell_button.dart';
import 'package:puducay_mobprog/widgets/custom_textformfield.dart';
import '../widgets/custom_dialogs.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobilenumController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  void register() {
    String firstName = firstnameController.text.trim();
    String lastName = lastnameController.text.trim();
    String mobile = mobilenumController.text.trim();
    String userName = userNameController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmpasswordController.text;

    // 1. Empty fields
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        mobile.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      customDialog(
        context,
        title: 'Invalid Input',
        content: 'All fields are required.',
      );
      return;
    }

    // 2. Mobile number validation
    if (mobile.length != 11) {
      customDialog(
        context,
        title: 'Invalid Mobile Number',
        content: 'Mobile number must be exactly 11 digits.',
      );
      return;
    }

    // 3. Password strength validation
    RegExp passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$',
    );

    if (!passwordRegex.hasMatch(password)) {
      customDialog(
        context,
        title: 'Weak Password',
        content:
            'Password must be at least 8 characters and include:\n'
            '- Uppercase letter\n'
            '- Lowercase letter\n'
            '- Number\n'
            '- Special character',
      );
      return;
    }

    // 4. Password mismatch
    if (password != confirmPassword) {
      customDialog(
        context,
        title: 'Password Mismatch',
        content: 'Password and Confirm Password do not match.',
      );
      return;
    }

    // ✅ Success
    customDialog(
      context,
      title: 'Success',
      content: 'Registration successful!',
    );

    // TODO: Save data or navigate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(25),
            ScreenUtil().setHeight(40),
            ScreenUtil().setWidth(25),
            ScreenUtil().setHeight(10),
          ),
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().setHeight(25)),
              CustomFont(
                text: 'Register Here',
                fontSize: ScreenUtil().setSp(50),
                fontWeight: FontWeight.bold,
                color: FB_DARK_PRIMARY,
              ),
              SizedBox(height: ScreenUtil().setHeight(25)),

              CustomTextFormField(
                controller: firstnameController,
                hintText: 'First name',
                validator: null,
                onSaved: null,
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                fontColor: FB_DARK_PRIMARY,
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              CustomTextFormField(
                controller: lastnameController,
                hintText: 'Last name',
                validator: null,
                onSaved: null,
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                fontColor: FB_DARK_PRIMARY,
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              CustomTextFormField(
                controller: mobilenumController,
                hintText: 'Mobile Number',
                keyboardType: TextInputType.number,
                maxLength: 11,
                validator: null,
                onSaved: null,
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                fontColor: FB_DARK_PRIMARY,
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              CustomTextFormField(
                controller: userNameController,
                hintText: 'Username',
                validator: null,
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
                validator: null,
                onSaved: null,
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                fontColor: FB_DARK_PRIMARY,
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              Text(
                '(Password should be 8 characters, include uppercase, lowercase, number, and special character.)',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: ScreenUtil().setSp(10),
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              CustomTextFormField(
                controller: confirmpasswordController,
                hintText: 'Confirm Password',
                isObscure: true,
                validator: null,
                onSaved: null,
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                fontColor: FB_DARK_PRIMARY,
              ),

              const Spacer(),

              /// 🔹 LOGIN HERE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You have an account? ',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.popAndPushNamed(context, '/login'),
                    child: Text(
                      'Login here',
                      style: TextStyle(
                        color: FB_DARK_PRIMARY,
                        fontSize: ScreenUtil().setSp(15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              CustomInkwellButton(
                onTap: register,
                height: ScreenUtil().setHeight(45),
                width: ScreenUtil().screenWidth,
                fontSize: ScreenUtil().setSp(15),
                fontWeight: FontWeight.bold,
                buttonName: 'Submit',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
