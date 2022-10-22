import 'package:firebase_project/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = '/user_profile_page';
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('My Profile'),
      ),
    );
  }
}
