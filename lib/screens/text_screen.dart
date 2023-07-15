import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:mydiary_app/screens/memories_screen.dart';

class MyHtmlEditorScreen extends StatefulWidget {
  const MyHtmlEditorScreen({
    Key? key,
    this.width,
    this.height,
    this.currentHtml,
  }) : super(key: key);
  static const String route = "MyHtmlEditorScreen";

  final double? width;
  final double? height;
  final String? currentHtml;

  @override
  _MyHtmlEditorScreenState createState() => _MyHtmlEditorScreenState();
}

class _MyHtmlEditorScreenState extends State<MyHtmlEditorScreen> {
  final HtmlEditorController controller = HtmlEditorController();

  // Get a reference to the Firestore database
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  late final CollectionReference<Map<String, dynamic>> collectionRef;

  String? textToEdit;
  String? postId;

  @override
  void initState() {
    super.initState();
    // Initialize the collection reference
    collectionRef = firestore.collection('htmleditor');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dynamic argument = ModalRoute.of(context)?.settings.arguments;
    if (argument is String) {
      textToEdit = argument;
    } else if (argument is Map<String, dynamic>) {
      // Access the specific field containing the text to edit
      textToEdit = argument['textToEdit'] as String?;
      postId = argument['postId'] as String?;

      print('POSTID$postId'); // Use 'postId' instead of 'uid'
    }
    // If 'textToEdit' is null, assign an empty string as default
    textToEdit ??= '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          // color: Colors.red,
          height: MediaQuery.of(context).size.height * 0.960,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          textToEdit = null;
                          controller.clear();
                        });
                        Future.delayed(const Duration(microseconds: 45))
                            .then((value) => Navigator.pop(context));
                      },
                      icon: const Icon(
                        Icons.backspace_rounded,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    const Text(
                      'Pour your thoughts',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () async {
                        final String data = await controller.getText();
                        final DateTime currentTime = DateTime.now();

                        // Save to Firebase
                        final doc = {
                          'isPrivate': true,
                          'htmltext': data,
                          'timestamp': currentTime,
                        };

                        final snapshot = await collectionRef.limit(1).get();
                        if (snapshot.docs.isNotEmpty) {
                          // Update document
                          final docRef = snapshot.docs[0].reference;
                          await docRef.update(doc);
                        } else {
                          // Create document
                          final newDocRef = await collectionRef.add(doc);
                          if (newDocRef != null) {
                            // Retrieve the generated document ID
                            final newDocId = newDocRef.id;
                            // Update the postId with the new document ID
                            postId = newDocId;
                          } else {
                            // Handle error when creating a new document
                            print('Failed to create a new document.');
                            return;
                          }
                        }

                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          final userPostsCollectionRef = firestore
                              .collection('users')
                              .doc(user.uid)
                              .collection('posts');

                          final userPostDoc = {
                            'isPrivate': true,
                            'htmltext': data,
                            'timestamp': currentTime,
                          };
                          print('postId: $postId');

                          if (postId != null) {
                            // Update the specific post with the postId
                            final postDocRef =
                                userPostsCollectionRef.doc(postId);
                            await postDocRef.update(userPostDoc);
                          } else {
                            // Create a new post
                            final newUserPostRef =
                                await userPostsCollectionRef.add(userPostDoc);
                            if (newUserPostRef != null) {
                              // Retrieve the generated document ID
                              final newUserPostId = newUserPostRef.id;
                              // Update the postId with the new document ID
                              postId = newUserPostId;
                            } else {
                              // Handle error when creating a new user post
                              print('Failed to create a new user post.');
                              return;
                            }
                          }
                        }

                        setState(() {
                          FFAppState().update(() {
                            FFAppState().textFromHtmlEditor = data;
                          });

                          setState(() {
                            textToEdit = null;
                            controller.clear();
                          });
                          Future.delayed(const Duration(microseconds: 45)).then(
                              (value) => Navigator.pushReplacementNamed(
                                  context, MemoriesScreen.route));
                        });
                      },
                      icon: const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: HtmlEditor(
                  controller: controller,
                  htmlEditorOptions: HtmlEditorOptions(
                    adjustHeightForKeyboard: true,
                    autoAdjustHeight: true,
                    initialText: textToEdit ?? widget.currentHtml,
                  ),
                  htmlToolbarOptions: const HtmlToolbarOptions(
                    toolbarType: ToolbarType.nativeGrid,
                    gridViewHorizontalSpacing: 0,
                    gridViewVerticalSpacing: 0,
                    toolbarItemHeight: 40,
                  ),
                  otherOptions: const OtherOptions(

                      // height: MediaQuery.of(context).size.height * 0.9,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FFButtonOptions {
  const FFButtonOptions({
    this.width,
    this.height,
    this.color,
    this.textStyle,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final Color? color;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
}

class FFButtonWidget extends StatelessWidget {
  const FFButtonWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.options,
  }) : super(key: key);

  final void Function() onPressed;
  final String text;
  final FFButtonOptions options;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(options.width ?? 88.0, options.height ?? 36.0),
        backgroundColor: options.color,
        shape: RoundedRectangleBorder(
          borderRadius: options.borderRadius ?? BorderRadius.circular(2.0),
        ),
      ),
      child: Text(
        text,
        style: options.textStyle,
      ),
    );
  }
}

class FFAppState {
  String? textFromHtmlEditor;

  void update(VoidCallback callback) {
    callback();
  }
}
