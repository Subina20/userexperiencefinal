import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mydiary_app/screens/post_display_screen.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const String route = "SearchScreen";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchText = '';
  bool isSearching = false;

  Future<List<DocumentSnapshot>> fetchUserPosts(String userId) async {
    final postsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('posts')
        .get();
    return postsSnapshot.docs;
  }

  Future<int> countLikes(String postId) async {
    final postSnapshot =
        await FirebaseFirestore.instance.collection('likes').doc(postId).get();
    final likesArray = postSnapshot.data()?['likes'] as List<dynamic>?;

    if (likesArray != null) {
      return likesArray.length;
    } else {
      return 0;
    }
  }

  void performSearch() {
    setState(() {
      isSearching = true;
    });
  }

  Future<String> getUsername(String userId) async {
    final userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userSnapshot.data()?['username'] ?? '';
  }

  String formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    final formatter = DateFormat.yMMMd().add_jm();
    return formatter.format(date);
  }

  Future<String> getImage(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.get('profileImageUrl');
    }
    return '';
  }

  void toggleBookmark(String postId, bool isCurrentlyBookmarked) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final bookmarksRef =
          FirebaseFirestore.instance.collection('bookmarks').doc(postId);

      if (isCurrentlyBookmarked) {
        bookmarksRef.update({
          'bookmarks': FieldValue.arrayRemove([currentUser.uid]),
        });
      } else {
        bookmarksRef.update({
          'bookmarks': FieldValue.arrayUnion([currentUser.uid]),
        });
      }
    }
  }

  void toggleLike(String postId, bool isCurrentlyLiked) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final likesRef =
          FirebaseFirestore.instance.collection('likes').doc(postId);

      if (isCurrentlyLiked) {
        likesRef.update({
          'likes': FieldValue.arrayRemove([currentUser.uid]),
        });
      } else {
        likesRef.update({
          'likes': FieldValue.arrayUnion([currentUser.uid]),
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: performSearch,
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 40,
          right: 40,
          top: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Display stats for searched user
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isEqualTo: searchText)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('User not found'),
                    );
                  }

                  final userDocument = snapshot.data!.docs[0];
                  final userId = userDocument.id;

                  return FutureBuilder<List<DocumentSnapshot>>(
                    future: fetchUserPosts(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      final postDocuments = snapshot.data!;
                      final postCount = postDocuments.length;

                      return Column(
                        children: [
                          // Display user stats
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.black,
                              ),
                              child: FutureBuilder<String>(
                                future: getImage(userId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(snapshot.data!),
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
                            title: Text('${userDocument['username']}'),
                            subtitle: Text('Total Posts: $postCount'),
                          ),
                          // Add other user stats as needed
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: postCount,
                            itemBuilder: (context, index) {
                              final postDocument = postDocuments[index];
                              final postId = postDocument.id;

                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Posts from ${userDocument['username']}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userId)
                                          .collection('posts')
                                          .doc(postId)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error fetching posts: ${snapshot.error}');
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        final post = snapshot.data?.data()
                                            as Map<String, dynamic>?;
                                        if (post == null) {
                                          return const SizedBox();
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              PostDisplayScreen.route,
                                              arguments: post,
                                            );
                                          },
                                          child: Container(
                                            height: 300,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 233, 233, 233),
                                                  offset: Offset(1, 1),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 220,
                                                  child: SingleChildScrollView(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Column(
                                                        children: [
                                                          HtmlWidget(
                                                              post['htmltext']),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          const Text(
                                                            '',
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.black,
                                                          ),
                                                          child: FutureBuilder<
                                                              String>(
                                                            future: getImage(
                                                                post['userId']),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                return CircleAvatar(
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          snapshot
                                                                              .data!),
                                                                );
                                                              } else if (snapshot
                                                                  .hasError) {
                                                                return const Icon(
                                                                    Icons
                                                                        .error); // Display an error icon or placeholder image
                                                              } else {
                                                                return const CircularProgressIndicator(); // Display a loading indicator
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 15),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            FutureBuilder<
                                                                String>(
                                                              future: getUsername(
                                                                  post[
                                                                      'userId']),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return const CircularProgressIndicator();
                                                                }
                                                                if (snapshot
                                                                    .hasError) {
                                                                  return Text(
                                                                      'Error: ${snapshot.error}');
                                                                }
                                                                final username =
                                                                    snapshot
                                                                        .data;
                                                                return Text(
                                                                  username ??
                                                                      '',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            55,
                                                                            55,
                                                                            55),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            Text(
                                                              formatTimestamp(post[
                                                                  'timestamp']),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 11,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        55,
                                                                        55,
                                                                        55),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        StreamBuilder<
                                                            DocumentSnapshot>(
                                                          stream:
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'bookmarks')
                                                                  .doc(postId)
                                                                  .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasError) {
                                                              return const Icon(
                                                                  Icons
                                                                      .bookmark_border);
                                                            }
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return const CircularProgressIndicator();
                                                            }

                                                            final isBookmarked =
                                                                snapshot.data
                                                                        ?.exists ??
                                                                    false;
                                                            final bookmarkData =
                                                                snapshot.data
                                                                        ?.data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>?;

                                                            // Check if the current user ID exists in the bookmarks array
                                                            final isCurrentUserBookmark =
                                                                bookmarkData?[
                                                                            'bookmarks']
                                                                        ?.contains(
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser
                                                                          ?.uid,
                                                                    ) ??
                                                                    false;

                                                            return IconButton(
                                                              onPressed: () {
                                                                toggleBookmark(
                                                                    postId,
                                                                    isCurrentUserBookmark);
                                                              },
                                                              icon: Icon(
                                                                isCurrentUserBookmark
                                                                    ? Icons
                                                                        .bookmark
                                                                    : Icons
                                                                        .bookmark_border,
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    13,
                                                                    78,
                                                                    132),
                                                                size: 30,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        StreamBuilder<
                                                            DocumentSnapshot>(
                                                          stream:
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'likes')
                                                                  .doc(postId)
                                                                  .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasError) {
                                                              return const Icon(
                                                                  Icons
                                                                      .favorite_border_sharp);
                                                            }
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return const CircularProgressIndicator();
                                                            }

                                                            final isLiked =
                                                                snapshot.data
                                                                        ?.exists ??
                                                                    false;
                                                            final likeData =
                                                                snapshot.data
                                                                        ?.data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>?;

                                                            // Check if the current user ID exists in the likes array
                                                            final isCurrentUserLike =
                                                                likeData?['likes']
                                                                        ?.contains(
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser
                                                                          ?.uid,
                                                                    ) ??
                                                                    false;

                                                            return IconButton(
                                                              onPressed: () {
                                                                toggleLike(
                                                                    postId,
                                                                    isCurrentUserLike);
                                                              },
                                                              icon: Icon(
                                                                isCurrentUserLike
                                                                    ? Icons
                                                                        .favorite
                                                                    : Icons
                                                                        .favorite_border_sharp,
                                                                color:
                                                                    Colors.red,
                                                                size: 30,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
