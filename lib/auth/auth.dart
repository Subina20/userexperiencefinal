import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mydiary_app/screens/displayname_screen.dart';
import 'package:mydiary_app/screens/home_screen.dart';
import 'package:mydiary_app/screens/onboard_screen.dart';


class AuthScreen extends StatelessWidget {
  static const String route = "AuthScreen";

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is logged in
          if (snapshot.hasData) {
            final user = snapshot.data!;
            final usersCollectionRef =
                FirebaseFirestore.instance.collection('users');

            return FutureBuilder<DocumentSnapshot>(
              future: usersCollectionRef.doc(user.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final document = snapshot.data!;
                  final data = document.data() as Map<String, dynamic>?;

                  if (data != null && data.containsKey('username')) {
                    final username = data['username'] as String;
                    print('Username: $username');
                    return const HomeScreen();
                  } else {
                    return DisplayNameScreen();
                  }
                }

                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                )); // Show a loading indicator while checking for the username
              },
            );
          }
          // User is NOT logged in
          else {
            return const OnboardScreen();
          }
        },
      ),
    );
  }
}
