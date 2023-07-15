import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mydiary_app/auth/auth.dart';
import 'package:mydiary_app/components/my_list_tile.dart';
import 'package:mydiary_app/screens/help_screen.dart';
import 'package:mydiary_app/screens/language_screen.dart';
import 'package:mydiary_app/screens/privacy_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  static const String route = "SettingScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Padding(
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Text(
            " Settings",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        // centerTitle: true,
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            Column(
              children: [
                GestureDetector(
                  child: MyListTile(
                    icon: Icons.account_circle_outlined,
                    text: 'Profile',
                    color: Colors.black,
                    tilecolor: const Color.fromARGB(255, 217, 217, 217),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  child: MyListTile(
                    icon: Icons.privacy_tip_outlined,
                    text: 'Privacy',
                    color: Colors.black,
                    tilecolor: const Color.fromARGB(255, 217, 217, 217),
                    onTap: () {
                      Navigator.pushNamed(context, PrivacyScreen.route);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  child: MyListTile(
                    icon: Icons.language,
                    text: 'Language',
                    color: Colors.black,
                    tilecolor: const Color.fromARGB(255, 217, 217, 217),
                    onTap: () {
                      Navigator.pushNamed(context, LanguageScreen.route);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  child: MyListTile(
                    icon: Icons.help,
                    text: 'Help',
                    color: Colors.black,
                    tilecolor: const Color.fromARGB(255, 217, 217, 217),
                    onTap: () {
                      Navigator.pushNamed(context, HelpScreen.route);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  child: MyListTile(
                    icon: Icons.logout,
                    text: 'Logout',
                    color: Colors.black,
                    tilecolor: const Color.fromARGB(255, 217, 217, 217),
                    onTap: () {
                      final GoogleSignIn googleSignIn = GoogleSignIn();
                      if (googleSignIn.currentUser != null) {
                        googleSignIn.disconnect().then((_) {
                          FirebaseAuth.instance.signOut().then((_) {
                            Navigator.pushReplacementNamed(
                                context, AuthScreen.route);
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
                          Navigator.pushReplacementNamed(
                              context, AuthScreen.route);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
