import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mydiary_app/screens/memories_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);
  static const String route = "UploadScreen";

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? selectedCategory;
  String? htmltext;
  String? postId;
  bool isUploading = false;

  FocusNode? controllerDropdown;

  @override
  void initState() {
    super.initState();
    // Initialize the FocusNode
    controllerDropdown = FocusNode();
  }

  Future<void> doThisFirst() async {
    final dynamic argument = ModalRoute.of(context)?.settings.arguments;
    if (argument is String) {
      htmltext = argument;
    } else if (argument is Map<String, dynamic>) {
      htmltext = argument['htmltext'] as String?;
      postId = argument['postId'] as String?;

      print('POSTID$postId');
    }
    htmltext ??= '';
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await doThisFirst();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updatePostPrivacyAndCategory(
      String postId, String category) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userPostsCollectionRef =
          firestore.collection('users').doc(user.uid).collection('posts');

      final postDocRef = userPostsCollectionRef.doc(postId);
      final postDocSnapshot = await postDocRef.get();
      if (postDocSnapshot.exists) {
        await postDocRef.update({
          'isPrivate': false,
          'category': category,
          'userId': user.uid,
          'postId': postId
        });
        print('Post privacy and category updated successfully.');
        showSnackbar('Upload completed successfully.', Colors.green);
        Navigator.pushReplacementNamed(context, MemoriesScreen.route,
            arguments: false);
      } else {
        print('Post document does not exist.');
        showSnackbar('Failed to update post privacy and category.', Colors.red);
      }
    } else {
      print('User is not authenticated.');
      showSnackbar('User is not authenticated.', Colors.red);
    }
  }

  final List<String> items = [
    'Travel',
    'Fiction',
    'Health',
    'Creativity',
    'Work',
    'Ideas',
    'Day to Remember'
  ];
  String? selectedValue;
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

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
        appBar: AppBar(
          toolbarHeight: 100,
          title: const Text(
            "Upload",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              controllerDropdown!.dispose();
              Navigator.pushReplacementNamed(context, MemoriesScreen.route);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Memory To Upload",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: 250,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 233, 233, 233),
                      offset: Offset(1, 1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: HtmlWidget(htmltext!),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Select Category",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    width: double.infinity,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        focusNode: controllerDropdown,
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedCategory == null
                                    ? 'Select a category'
                                    : selectedCategory!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value
                                as String; // Update selectedCategory instead of selectedValue
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 160,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                          ),
                          iconSize: 24,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: MediaQuery.of(context).size.width * 0.7 -
                                (MediaQuery.of(context).padding.left +
                                    MediaQuery.of(context).padding.right),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(5),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            )),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 50,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isUploading = true;
                      });
                      print('details$postId $selectedCategory');
                      await updatePostPrivacyAndCategory(
                          postId!, selectedCategory!);

                      setState(() {
                        isUploading = false;
                      });
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Upload to the feed'),
                  ),
                  if (isUploading)
                    const CircularProgressIndicator(), // Show circular progress indicator while uploading
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
