import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/auth/auth_service.dart';
import 'package:firebase_project/models/userModel.dart';
import 'package:firebase_project/provider/user_provider.dart';
import 'package:firebase_project/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = '/user_profile_page';

  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final txtController = TextEditingController();

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Center(
        child: Consumer<UserProvider>(
          builder: (context, provider, _) =>
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: provider.getUserByUid(AuthService.user!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userModel = UserModel.fromMap(snapshot.data!.data()!);
                return ListView(
                  children: [
                    SizedBox(height: 10,),
                    Center(
                      child: userModel.image == null
                          ? Image.asset(
                              'images/person.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              userModel.image!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    TextButton.icon(
                        onPressed: _updateImage,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Change Image')),
                    const Divider(
                      color: Colors.grey,
                      height: 1,
                    ),
                    ListTile(
                      title: Text(userModel.name ?? 'No Display Name'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showInputDialog('Display Name', userModel.name, (value)async{
                            provider.updateProfile(AuthService.user!.uid, {'name':value});
                            await AuthService.updateDisplayName(value);
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(userModel.mobile ?? 'No Mobile Number'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showInputDialog('Display Mobile', userModel.mobile, (value){
                            provider.updateProfile(AuthService.user!.uid, {'mobile':value});
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(userModel.email ?? 'No Email Address'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showInputDialog('Display Email', userModel.email, (value){
                            provider.updateProfile(AuthService.user!.uid, {'email':value});
                          });
                        },
                      ),
                    )
                  ],
                );
              }
              if (snapshot.hasError) {
                return Text('Failed to fetch data');
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  void _updateImage() async {
    final xFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 75);
    if (XFile != null) {
      try {
        final downloadUrl =
            await Provider.of<UserProvider>(context, listen: false)
                .updateImage(xFile!);
        await Provider.of<UserProvider>(context, listen: false)
            .updateProfile(AuthService.user!.uid, {'image': downloadUrl});
        await AuthService.updateDisplayImage(downloadUrl);
      } catch (e) {
        rethrow;
      }
    }
  }

  showInputDialog(String title, String? value, Function(String) onSaved) {
    txtController.text = value ?? '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: txtController,
                  decoration: InputDecoration(hintText: 'Enter $title'),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('CANCEL')),
                TextButton(
                    onPressed: (){
                      onSaved(txtController.text);
                      Navigator.pop(context);
                    },
                    child: Text('UPDATE')),
              ],
            ));
  }
}
