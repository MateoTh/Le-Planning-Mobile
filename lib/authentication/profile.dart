import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:le_planning/shared/global_colors.dart';

import 'auth_service.dart';
import 'widgets/profile_image_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        ProfileImageWidget(
          imagePath:
              'https://preview.redd.it/7mcmlkums6z31.jpg?auto=webp&s=b7c7eff0cf6492b3820e28e4824e2e3fca82944d',
          onClicked: () => {},
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Text(
              user!.displayName != null ? user!.displayName! : 'Guest',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              user!.email != null ? user!.email! : 'email',
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: signOut,
                style:
                    ElevatedButton.styleFrom(backgroundColor: globalColorRed),
                child: const Text('Sign Out'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void signOut() {
    AuthService auth = AuthService();
    auth.logOut();
  }
}
