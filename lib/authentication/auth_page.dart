import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? Login(onclickedRegister: toggle)
      : Register(onclickedLogin: toggle);

  void toggle() {
    isLogin = !isLogin;
    setState(() {});
  }
}
