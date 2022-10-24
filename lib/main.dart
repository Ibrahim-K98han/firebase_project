import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/pages/chat_room_page.dart';
import 'package:firebase_project/pages/launcher_page.dart';
import 'package:firebase_project/pages/login_page.dart';
import 'package:firebase_project/pages/user_profile_page.dart';
import 'package:firebase_project/provider/chat_room_provider.dart';
import 'package:firebase_project/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=> UserProvider()),
      ChangeNotifierProvider(create: (_)=> ChatRoomProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (_) => LauncherPage(),
        LoginPage.routeName: (_) => LoginPage(),
        UserProfilePage.routeName: (_) => UserProfilePage(),
        ChatRoomPage.routeName: (_) => ChatRoomPage(),
      },
    );
  }
}
