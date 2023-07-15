import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';

class PostDisplayScreen extends StatefulWidget {
  const PostDisplayScreen({Key? key}) : super(key: key);
  static const String route = 'PostDisplayScreen';

  @override
  State<PostDisplayScreen> createState() => _PostDisplayScreenState();
}

class _PostDisplayScreenState extends State<PostDisplayScreen> {
  bool isLiked = false;
  bool isBookmarked = false;

  Future<String> getImage(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.get('profileImageUrl');
    }
    return '';
  }

  Future<String> getUsername(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.get('username');
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final post =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final String postId = post['postId'];

    return Scaffold(
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 45,
            right: 45,
            top: 20,
          ),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.black,
                          ),
                          child: FutureBuilder<String>(
                            future: getImage(post['userId']),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data!),
                                );
                              } else if (snapshot.hasError) {
                                return const Icon(Icons
                                    .error); // Display an error icon or placeholder image
                              } else {
                                return const CircularProgressIndicator(); // Display a loading indicator
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<String>(
                              future: getUsername(post['userId']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                final username = snapshot.data;
                                return Text(
                                  username ?? '',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 55, 55, 55),
                                  ),
                                );
                              },
                            ),
                            Text(
                              formatTimestamp(post['timestamp']),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(255, 55, 55, 55),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('bookmarks')
                              .doc(postId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Icon(Icons.bookmark_border);
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            final isBookmarked = snapshot.data?.exists ?? false;
                            final bookmarkData =
                                snapshot.data?.data() as Map<String, dynamic>?;

                            // Check if the current user ID exists in the bookmarks array
                            final isCurrentUserBookmark =
                                bookmarkData?['bookmarks']?.contains(
                                      FirebaseAuth.instance.currentUser?.uid,
                                    ) ??
                                    false;

                            return IconButton(
                              onPressed: () {
                                toggleBookmark(postId, isCurrentUserBookmark);
                              },
                              icon: Icon(
                                isCurrentUserBookmark
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: const Color.fromARGB(255, 13, 78, 132),
                                size: 30,
                              ),
                            );
                          },
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('likes')
                              .doc(postId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Icon(Icons.favorite_border_sharp);
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            final isLiked = snapshot.data?.exists ?? false;
                            final likeData =
                                snapshot.data?.data() as Map<String, dynamic>?;

                            // Check if the current user ID exists in the likes array
                            final isCurrentUserLike =
                                likeData?['likes']?.contains(
                                      FirebaseAuth.instance.currentUser?.uid,
                                    ) ??
                                    false;

                            return IconButton(
                              onPressed: () {
                                toggleLike(postId, isCurrentUserLike);
                              },
                              icon: Icon(
                                isCurrentUserLike
                                    ? Icons.favorite
                                    : Icons.favorite_border_sharp,
                                color: Colors.red,
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child:
                    SingleChildScrollView(child: HtmlWidget(post['htmltext'])),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }

  Future<void> toggleBookmark(String postId, bool isBookmarked) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final bookmarkRef =
          FirebaseFirestore.instance.collection('bookmarks').doc(postId);

      try {
        final bookmarkSnapshot = await bookmarkRef.get();

        if (bookmarkSnapshot.exists) {
          final bookmarkData = bookmarkSnapshot.data() as Map<String, dynamic>;

          if (isBookmarked) {
            // Remove the user ID from the bookmarks array
            final updatedBookmarks = List<String>.from(
              bookmarkData['bookmarks'] ?? [],
            )..remove(user.uid);

            await bookmarkRef
                .update({'bookmarks': updatedBookmarks, 'postId': postId});
          } else {
            // Add the user ID to the bookmarks array
            final updatedBookmarks = List<String>.from(
              bookmarkData['bookmarks'] ?? [],
            )..add(user.uid);

            await bookmarkRef
                .update({'bookmarks': updatedBookmarks, 'postId': postId});
          }
        } else {
          // Document does not exist, create a new document with the user ID in the bookmarks array
          await bookmarkRef.set({
            'bookmarks': [user.uid],
            'postId': postId
          });
        }
      } catch (error) {
        print('Error toggling bookmark: $error');
        // Handle error
      }
    }
  }

  Future<void> toggleLike(String postId, bool isLiked) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final likeRef =
          FirebaseFirestore.instance.collection('likes').doc(postId);

      try {
        final likeSnapshot = await likeRef.get();

        if (likeSnapshot.exists) {
          final likeData = likeSnapshot.data() as Map<String, dynamic>;

          if (isLiked) {
            // Remove the user ID from the likes array
            final updatedLikes = List<String>.from(
              likeData['likes'] ?? [],
            )..remove(user.uid);

            await likeRef.update({'likes': updatedLikes, 'postId': postId});
          } else {
            // Add the user ID to the likes array
            final updatedLikes = List<String>.from(
              likeData['likes'] ?? [],
            )..add(user.uid);

            await likeRef.update({'likes': updatedLikes, 'postId': postId});
          }
        } else {
          // Document does not exist, create a new document with the user ID in the likes array
          await likeRef.set({
            'likes': [user.uid],
            'postId': postId
          });
        }
      } catch (error) {
        print('Error toggling like: $error');
        // Handle error
      }
    }
  }
}
