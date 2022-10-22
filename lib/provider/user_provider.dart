import 'package:firebase_project/db/dbhelper.dart';
import 'package:flutter/material.dart';

import '../models/userModel.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> userList = [];

  Future<void> addUser(UserModel userModel) => DBHelper.addUser(userModel);

}
