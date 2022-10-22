import 'package:firebase_project/auth/auth_service.dart';
import 'package:firebase_project/pages/login_page.dart';
import 'package:firebase_project/pages/user_profile_page.dart';
import 'package:flutter/material.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = '/';
  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      if(AuthService.user == null){
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }else{
        Navigator.pushReplacementNamed(context, UserProfilePage.routeName);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
