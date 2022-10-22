import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/auth/auth_service.dart';
import 'package:firebase_project/models/userModel.dart';
import 'package:firebase_project/pages/user_profile_page.dart';
import 'package:firebase_project/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isLogin = true, isobscureText = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    filled: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: isobscureText,
                controller: passController,
                decoration: InputDecoration(
                    hintText: 'Email Address',
                    prefixIcon: Icon(Icons.key),
                    suffixIcon: IconButton(
                      icon: Icon(isobscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(() {
                        isobscureText = !isobscureText;
                      }),
                    ),
                    filled: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  isLogin = true;
                  authenticate();
                },
                child: Text('LOGIN'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New User?'),
                  TextButton(
                      onPressed: () {
                        isLogin = false;
                        authenticate();
                      },
                      child: Text('Register Here'))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Forgot Password?'),
                  TextButton(onPressed: () {}, child: Text('Click Here'))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                errMsg,
                style: TextStyle(color: Theme.of(context).errorColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  authenticate() async {
    if (formKey.currentState!.validate()) {
      bool status;
      try {
        if (isLogin) {
          status = await AuthService.login(
              emailController.text, passController.text);
        } else {
          status = await AuthService.register(
              emailController.text, passController.text);
          await AuthService.sendVerificationMail();
          final userModel = UserModel(
            uid: AuthService.user!.uid,
            email: AuthService.user!.email,
          );
          if(mounted){
            await Provider.of<UserProvider>(context, listen: false)
                .addUser(userModel);
          }
        }
        if (status) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, UserProfilePage.routeName);
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }
}
