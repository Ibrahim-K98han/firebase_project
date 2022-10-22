import 'package:firebase_project/auth/auth_service.dart';
import 'package:firebase_project/pages/launcher_page.dart';
import 'package:firebase_project/pages/login_page.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.blue,
          ),
          ListTile(
            onTap: () async {
              await AuthService.logout();
              Navigator.pushReplacementNamed(context, LauncherPage.routeName);
            },
            leading: Icon(Icons.logout),
            title: Text('LOGOUT'),
          )
        ],
      ),
    );
  }
}
