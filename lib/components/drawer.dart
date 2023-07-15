import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:mydiary_app/auth/auth.dart';
import 'package:mydiary_app/components/my_list_tile.dart';
import 'package:mydiary_app/screens/memories_screen.dart';
import 'package:mydiary_app/screens/text_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late User? user;
  // late String username;
  late String username = '';
  late String profileImageUrl = '';
  final picker.ImagePicker _imagePicker = picker.ImagePicker();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final data = userDoc.data();
    setState(() {
      username = data?['username'] ?? '';
      profileImageUrl = data?['profileImageUrl'] ?? '';
    });
  }

  Future<void> changeProfilePicture() async {
    final picker.XFile? pickedImage = await _imagePicker.pickImage(
      source: picker.ImageSource.gallery,
    );

    if (pickedImage != null) {
      // Upload the new profile picture to Firebase Storage
      final File imageFile = File(pickedImage.path);

      try {
        final String userId = user!.uid;
        final String fileName = 'profile_images/$userId.jpg';

        final Reference storageRef =
            FirebaseStorage.instance.ref().child(fileName);
        final UploadTask uploadTask = storageRef.putFile(imageFile);

        final TaskSnapshot uploadSnapshot = await uploadTask;

        if (uploadSnapshot.state == TaskState.success) {
          // Get the URL of the uploaded image
          final String downloadUrl = await storageRef.getDownloadURL();

          // Update the user's profile image URL in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({'profileImageUrl': downloadUrl});

          setState(() {
            profileImageUrl = downloadUrl;
          });
        }
      } catch (error) {
        print('Error uploading profile picture: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 29, 39, 49),
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: DrawerHeader(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: changeProfilePicture,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : const NetworkImage(
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    username,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  IconButton(
                    onPressed: changeProfilePicture,
                    icon: const Icon(Icons.edit, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          MyListTile(
            icon: Icons.local_hospital,
            text: 'Write and clear your mind',
            onTap: () {
              Navigator.pushNamed(context, MyHtmlEditorScreen.route);
            },
          ),
          MyListTile(
            icon: Icons.file_copy,
            text: 'Your Memories',
            onTap: () {
              Navigator.pushNamed(context, MemoriesScreen.route);
            },
          ),
          MyListTile(
            icon: Icons.notification_add,
            text: 'Notification',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          MyListTile(
            icon: Icons.logout,
            text: 'Logout',
            color: Colors.red,
            onTap: () {
              final GoogleSignIn googleSignIn = GoogleSignIn();
              if (googleSignIn.currentUser != null) {
                googleSignIn.disconnect().then((_) {
                  FirebaseAuth.instance.signOut().then((_) {
                    Navigator.pushReplacementNamed(context, AuthScreen.route);
                  }).catchError((error) {
                    // Handle sign-out error
                    print('Error signing out: $error');
                  });
                }).catchError((error) {
                  // Handle revoke access error
                  print('Error revoking access: $error');
                });
              } else {
                FirebaseAuth.instance.signOut().then((_) {
                  Navigator.pushReplacementNamed(context, AuthScreen.route);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
