import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mydiary_app/auth/auth.dart';
import 'package:mydiary_app/components/button.dart';
import 'package:mydiary_app/components/text_field.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});
  static const String route = "RegisterScreen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController confirmPasswordTextController =
      TextEditingController();

  void signIn() async {
    print('sign in');
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text, password: passwordTextController.text);
    Navigator.pushReplacementNamed(context, AuthScreen.route);
  }

  Future<void> registerUser() async {
    final String email = emailTextController.text.trim();
    final String password = passwordTextController.text.trim();
    final String confirmPassword = confirmPasswordTextController.text.trim();

    if (password != confirmPassword) {
      // Show error message or dialog
      return;
    }

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      signIn();
      // User registration successful, do something
      print('User registered: ${userCredential.user?.uid}');
    } catch (error) {
      // Handle registration error
      print('Error registering user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png'),
                //logo

                const SizedBox(height: 50),

                const Text("Register an account"),
                const SizedBox(height: 50),

                MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: confirmPasswordTextController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),

                MyButton(
                  onTap: registerUser,
                  text: 'Sign Up',
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already Have An Account ?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 120,
                      height: 1,
                      color: Colors.grey,
                    ),
                    const Text("or"),
                    Container(
                      width: 120,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                MyButton(
                  onTap: () {},
                  text: 'Sign In with Google',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
