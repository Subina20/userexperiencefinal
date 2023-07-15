import 'package:flutter/material.dart';
import 'package:mydiary_app/auth/auth.dart';
import 'package:mydiary_app/auth/login_or_register.dart';
import 'package:mydiary_app/screens/account_screen.dart';
import 'package:mydiary_app/screens/bookmark_screen.dart';
import 'package:mydiary_app/screens/editprofile_screen.dart';
import 'package:mydiary_app/screens/help_screen.dart';
import 'package:mydiary_app/screens/language_screen.dart';
import 'package:mydiary_app/screens/memories_screen.dart';
import 'package:mydiary_app/screens/notification_screen.dart';
import 'package:mydiary_app/screens/onboard_screen.dart';
import 'package:mydiary_app/screens/post_display_screen.dart';
import 'package:mydiary_app/screens/post_screen.dart';
import 'package:mydiary_app/screens/privacy_screen.dart';
import 'package:mydiary_app/screens/search_screen.dart';
import 'package:mydiary_app/screens/setting%20_screen.dart';
import 'package:mydiary_app/screens/category_screen.dart';
import 'package:mydiary_app/screens/text_screen.dart';
import 'package:mydiary_app/screens/uploading_screen.dart';
import 'package:mydiary_app/screens/writing_screen.dart';

var getAppRoutes = <String, WidgetBuilder>{
  OnboardScreen.route: (context) => const OnboardScreen(),
  LoginOrRegister.route: (context) => const LoginOrRegister(),
  AuthScreen.route: (context) => const AuthScreen(),
  SettingScreen.route: (context) => const SettingScreen(),
  HelpScreen.route: (context) => const HelpScreen(),
  PrivacyScreen.route: (context) => const PrivacyScreen(),
  LanguageScreen.route: (context) => const LanguageScreen(),
  AccountScreen.route: (context) => const AccountScreen(),
  EditProfileScreen.route: (context) => const EditProfileScreen(),
  SearchScreen.route: (context) => const SearchScreen(),
  CategoryScreen.route: (context) => const CategoryScreen(),
  PostScreen.route: (context) => const PostScreen(),
  BookmarkScreen.route: (context) => const BookmarkScreen(),
  NotificationScreen.route: (context) => const NotificationScreen(),
  MemoriesScreen.route: (context) => const MemoriesScreen(),
  WritingScreen.route: (context) => const WritingScreen(),
  MyHtmlEditorScreen.route: (context) => const MyHtmlEditorScreen(),
  UploadScreen.route: (context) => const UploadScreen(),
  PostDisplayScreen.route: (context) => const PostDisplayScreen(),
  // LoginScreen.route: (context) => const LoginScreen(),
  // RegisterScreen.route: (context) =>  RegisterScreen(),
};
