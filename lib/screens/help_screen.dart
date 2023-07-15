import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});
  static const String route = "HelpScreen";

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
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
              icon: const Icon(Icons.help_center_outlined),
            ),
            const Text(
              " Help Section",
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
            children: const [
              Text(
                "Welcome to the Help Section of the Dear Diary app!",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "We're here to assist you in maximizing your diary-keeping experience. This section offers valuable information and guidance on effectively utilizing the app's features.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                "Getting Started:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Account Creation",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Navigation",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Diary Entry",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                "Diary Management:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Creating Entries",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Editing and Deleting Entries",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Organizing Entries",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                "Customization:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Personalization",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Notifications",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                "Privacy and Security:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Privacy Settings",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Security Measures",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                "Social Features:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Social Feed",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Reacting and Commenting",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                "FAQs and Troubleshooting:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Frequently Asked Questions",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Troubleshooting",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                "Contact Support:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Reach out to our support team for assistance.",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "We're here to ensure your Dear Diary app experience is enjoyable, seamless, and personalized. If you have questions or suggestions, please contact our support team.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                "Happy diary-keeping!",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                "The Dear Diary Team",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
