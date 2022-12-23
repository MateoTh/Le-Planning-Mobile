import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:le_planning/models/group.dart';
import 'package:le_planning/pages/profile_page.dart';
import 'package:le_planning/repository/data_repository.dart';
import 'package:le_planning/shared/global_colors.dart';
import 'package:le_planning/widgets/details_group.dart';

import '../authentication/widgets/AssetLogoImage.dart';

class ChooseGroup extends StatefulWidget {
  final User user;
  const ChooseGroup({super.key, required this.user});

  @override
  State<ChooseGroup> createState() => _ChooseGroupState();
}

class _ChooseGroupState extends State<ChooseGroup> {
  DataRepository repository = DataRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalColorYellow,
        elevation: 0,
        title: const Text("Planning"),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.add),
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: repository.groups
            .where('users', arrayContains: widget.user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LinearProgressIndicator();
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container();
          }
          return ListView(
            children: [
              logoApp(),
              Container(
                margin: const EdgeInsets.all(8),
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: listCardGroup(
                      context,
                      snapshot.data!.docs
                          .map((group) => Group.fromSnapshot(group))
                          .toList(),
                      widget.user),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

List<Widget> listCardGroup(BuildContext context, List<Group> list, User user) {
  List<Widget> cards = [];
  for (var group in list) {
    cards.add(cardGroup(group, context, user));
  }
  return cards;
}

Widget cardGroup(Group group, BuildContext context, User user) {
  return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return DetailGroup(
                group: group,
                user: user,
              );
            },
            fullscreenDialog: true));
      },
      child: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.album),
                title: Text(group.name),
                subtitle: Text(group.description),
              ),
            ],
          ),
        ),
      ));
}

Widget cardAddGroup() {
  return ElevatedButton(onPressed: () => {}, child: const Icon(Icons.add));
}

Widget logoApp() {
  return Container(
    margin: const EdgeInsets.only(bottom: 25),
    width: 150,
    height: 150,
    decoration: BoxDecoration(
      image: DecorationImage(image: asssetLogoImage()),
      borderRadius: BorderRadius.circular(100),
    ),
  );
}
