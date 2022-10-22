import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/models/userModel.dart';

class DBHelper{
  static const String collectionUser = 'Users';

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addUser(UserModel userModel){
    final doc = _db.collection(collectionUser).doc(userModel.uid);
    return doc.set(userModel.toMap());
  }
}