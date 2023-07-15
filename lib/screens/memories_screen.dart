import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mydiary_app/auth/auth.dart';
import 'package:mydiary_app/screens/text_screen.dart';
import 'package:mydiary_app/screens/uploading_screen.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({Key? key}) : super(key: key);
  static const String route = "MemoriesScreen";

  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool is_private = true;
  String displayName = '';

  Future<List<Map<String, dynamic>>>? _fetchPosts;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSnackbar(String message, Color color) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> updatePostPrivacy(String postId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userPostsCollectionRef =
          firestore.collection('users').doc(user.uid).collection('posts');

      final postDocRef = userPostsCollectionRef.doc(postId);
      final postDocSnapshot = await postDocRef.get();
      if (postDocSnapshot.exists) {
        await postDocRef.update({
          'isPrivate': true, // Set 'is_private' field to true for privacy
          'category': FieldValue.delete(), // Remove the 'category' field
        });
        print('Post privacy updated successfully.');
        showSnackbar('Post is now private', Colors.green);
        setState(() {
          is_private = !is_private;
          print(is_private);
          _fetchPosts = getPostsFromFirebase();
        });
      } else {
        print('Post document does not exist.');
        showSnackbar('Failed to update post.', Colors.red);
      }
    } else {
      print('User is not authenticated.');
      showSnackbar('User is not authenticated.', Colors.red);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dynamic argument = ModalRoute.of(context)?.settings.arguments;
    if (argument is bool) {
      setState(() {
        is_private = false;
        _fetchPosts = getPostsFromFirebase();
      });
    }

    is_private ??= true;
  }

  @override
  void initState() {
    super.initState();
    _fetchPosts = getPostsFromFirebase();
  }

  Future<List<Map<String, dynamic>>> getPostsFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userPostsCollectionRef =
          firestore.collection('users').doc(user.uid).collection('posts');

      final querySnapshot = await userPostsCollectionRef
          .where('isPrivate', isEqualTo: is_private)
          .get();

      final posts = <Map<String, dynamic>>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final uid = doc.id;
        final htmltext = data['htmltext'] ?? '';

        final username = await fetchDisplayName(user.uid);

        posts.add({'uid': uid, 'htmltext': htmltext, 'username': username});
      }

      print('POSTS:$posts');
      return posts;
    }

    return <Map<String, dynamic>>[]; // Return an empty list of the correct type
  }

  Future<String> fetchDisplayName(String uid) async {
    final userDoc = await firestore.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final username = userDoc['username'] ?? '';
      return username;
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
        appBar: AppBar(
          toolbarHeight: 100,
          title: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.file_copy),
              ),
              const Text(
                " My Memories",
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
              Navigator.pushReplacementNamed(context, AuthScreen.route);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 45,
              right: 45,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Private'),
                    Switch(
                      activeColor: Colors.black,
                      value: !is_private,
                      onChanged: (val) {
                        setState(() {
                          is_private = !is_private;
                          print(is_private);
                          _fetchPosts = getPostsFromFirebase();
                        });
                      },
                    ),
                    const Text('Public'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchPosts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final posts = snapshot.data ?? [];
                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final uid = post['uid'];
                            final htmltext = post['htmltext'];
                            final username = post['username'];

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Slidable(
                                endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      is_private
                                          ? SlidableAction(
                                              flex: 3,
                                              onPressed: (val) {
                                                Navigator.pushNamed(
                                                  context,
                                                  UploadScreen.route,
                                                  arguments: {
                                                    'htmltext': htmltext,
                                                    'postId': uid
                                                  },
                                                );
                                              },
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 33, 202, 84),
                                              foregroundColor: Colors.white,
                                              icon: Icons.upload_file,
                                              // label: 'Upload',
                                            )
                                          : SlidableAction(
                                              flex: 3,
                                              onPressed: (val) async {
                                                await updatePostPrivacy(uid);
                                              },
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 33, 202, 84),
                                              foregroundColor: Colors.white,
                                              icon: Icons.lock_outline,
                                              // label: 'Upload',
                                            ),
                                      SlidableAction(
                                        flex: 3,
                                        onPressed: (val) {
                                          Navigator.pushNamed(
                                            context,
                                            MyHtmlEditorScreen.route,
                                            arguments: {
                                              'textToEdit': htmltext,
                                              'postId': uid
                                            },
                                          );
                                        },
                                        backgroundColor: const Color.fromARGB(
                                            255, 33, 112, 202),
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        // label: 'Edit',
                                      ),
                                      SlidableAction(
                                        flex: 3,
                                        onPressed: (val) async {
                                          // Delete post from Firebase
                                          final user =
                                              FirebaseAuth.instance.currentUser;
                                          if (user != null) {
                                            final userPostsCollectionRef =
                                                firestore
                                                    .collection('users')
                                                    .doc(user.uid)
                                                    .collection('posts');

                                            await userPostsCollectionRef
                                                .doc(uid)
                                                .delete();

                                            // Refresh the posts list by calling _fetchPosts again
                                            setState(() {
                                              _fetchPosts =
                                                  getPostsFromFirebase();
                                            });
                                          }
                                        },
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                      ),
                                    ]),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  height: 250,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 233, 233, 233),
                                        offset: Offset(1, 1),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    // height: 230,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10.0),
                                    child: SingleChildScrollView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      child: HtmlWidget(htmltext),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
