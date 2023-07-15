import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mydiary_app/auth/auth.dart';
import 'package:mydiary_app/components/button.dart';

class DisplayNameScreen extends StatelessWidget {
  final TextEditingController _displayNameController = TextEditingController();

  DisplayNameScreen({super.key});

  Future<bool> _checkUsernameExists(String username) async {
    final User user = FirebaseAuth.instance.currentUser!;
    final usersCollectionRef = FirebaseFirestore.instance.collection('users');

    final querySnapshot =
        await usersCollectionRef.where('username', isEqualTo: username).get();

    return querySnapshot.docs.isNotEmpty;
  }

  void _updateDisplayName(BuildContext context) async {
    final String newUsername = _displayNameController.text;

    if (await _checkUsernameExists(newUsername)) {
      // Username already exists, show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Username already exists. Please choose a different one.'),
        ),
      );
    } else {
      // Username is unique, update Firestore
      final User user = FirebaseAuth.instance.currentUser!;
      final usersCollectionRef = FirebaseFirestore.instance.collection('users');

      // Add the username field in the users collection document with user's UID as the document ID
      await usersCollectionRef.doc(user.uid).set({'username': newUsername});

      Navigator.pushReplacementNamed(context, AuthScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hey, ${FirebaseAuth.instance.currentUser!.email} \n',
                style: const TextStyle(fontSize: 16),
              ),
              const Text(
                'It looks like you\'ve not added a username',
                style: TextStyle(fontSize: 26),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _displayNameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 16.0),
              MyButton(
                onTap: () {
                  _updateDisplayName(context);
                },
                text: 'Update',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
