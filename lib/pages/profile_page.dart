import 'package:flutter/material.dart';
import 'package:le_planning/authentication/profile.dart';
import 'package:le_planning/shared/global_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: globalColorRed, title: const Text('Profil')),
        body: const Profile());
  }
}
