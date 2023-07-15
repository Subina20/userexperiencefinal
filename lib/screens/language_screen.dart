import 'package:flutter/material.dart';
import 'package:mydiary_app/components/my_list_tile.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);
  static const String route = "LanguageScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                // Handle help center button press
              },
              icon: const Icon(Icons.language),
            ),
            const Text(
              " Language",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: MyListTile(
                  icon: Icons.language,
                  text: 'English',
                  color: Colors.black,
                  tilecolor: const Color.fromARGB(255, 217, 217, 217),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
