import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      physics: BouncingScrollPhysics(),
      children: [
        ProfileImageWidget(
          imagePath:
              'https://scontent-mrs2-2.xx.fbcdn.net/v/t1.18169-9/20840661_1916414815293981_3503828369660538789_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=ad2b24&_nc_ohc=NYBx8QPeLUYAX8PLVOX&tn=M4JQg3fVGVNIMlOS&_nc_ht=scontent-mrs2-2.xx&oh=00_AfDPq4lvXH4kL6foalx-laQ_jhBhia0bpuFzS8mmSNZbOA&oe=63C7E26C',
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text('Sign Out'),
              ),
            ),
          ],
        ),
        LikedSkateList_GetUser("owned"),
        const SizedBox(height: 20),
        LikedSkateList_GetUser("liked"),
      ],
    );
  }

  void signOut() {
    AuthService auth = AuthService();
    auth.logOut();
  }

  Widget LikedSkateList_GetUser(String typeList) {
    return Container();
  }
}
