import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:le_planning/pages/choose_group_page.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChooseGroupPage(
      user: widget.user,
    );
  }
}
