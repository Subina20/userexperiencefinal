import 'package:flutter/material.dart';

import '../components/drawer.dart';

class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});
  static const String route = "WritingScreen";

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        toolbarHeight: 100,
        title: Image.asset(
          'assets/images/logo.png',
          width: 180,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 45,
            right: 45,
            top: 10,
          ), // Adjust the padding as desired
          child: Column(
            children: const [
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
