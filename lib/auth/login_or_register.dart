import 'package:flutter/src/widgets/framework.dart';
import 'package:mydiary_app/screens/login_screen.dart';
import 'package:mydiary_app/screens/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});
    static const String route = "LoginOrRegister";


  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
  void toggleScreen() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(onTap: toggleScreen);
    }else{
      return RegisterScreen(onTap: toggleScreen);
    }
  }
}
