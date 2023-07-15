import 'package:flutter/material.dart';
import 'package:mydiary_app/components/my_list_tile.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);
  static const String route = "AccountScreen";

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
              icon: const Icon(Icons.manage_accounts_outlined),
            ),
            const Text(
              " Account Setting",
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
            // Handle back button press
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.manage_accounts_outlined),
                ),
                const Text(
                  " Account",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 10),
                GestureDetector(
                  child: MyListTile(
                    icon: Icons.lock_outline,
                    text: 'Change Password',
                    color: Colors.black,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: MyListTile(
                    icon: Icons.email_outlined,
                    text: 'Change Email',
                    color: Colors.black,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: MyListTile(
                    icon: Icons.delete_outline,
                    text: 'Delete Account',
                    color: Colors.black,
                    onTap: () {
                      Navigator.pop(context);
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
