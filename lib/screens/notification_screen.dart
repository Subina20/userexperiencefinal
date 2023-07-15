import 'package:flutter/material.dart';
import 'package:mydiary_app/components/my_list_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static const String route = "NotificationScreen";

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
              icon: const Icon(Icons.notification_add_outlined),
            ),
            const Text(
              " Notification",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        foregroundColor: Colors.black,
        elevation: 0,
        leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            Column(
              children: [
                GestureDetector(
                  child: MyListTile(
                    icon: Icons.notifications_active_outlined,
                    text: 'Jenny Wilson ha posted a new post',
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
                    icon: Icons.notifications_active_outlined,
                    text: 'Jenny Wilson ha posted a new post',
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
                    icon: Icons.notifications_active_outlined,
                    text: 'Jenny Wilson ha posted a new post',
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
                    icon: Icons.notifications_active_outlined,
                    text: 'Jenny Wilson ha posted a new post',
                    color: Colors.black,
                    tilecolor: const Color.fromARGB(255, 217, 217, 217),
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
