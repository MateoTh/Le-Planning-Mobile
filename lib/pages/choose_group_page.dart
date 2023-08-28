import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:le_planning/models/group.dart';
import 'package:le_planning/pages/join_group_page.dart';
import 'package:le_planning/pages/profile_page.dart';
import 'package:le_planning/repository/group_repository.dart';
import 'package:le_planning/shared/global_colors.dart';
import 'package:le_planning/pages/group_page.dart';
import 'package:le_planning/widgets/buttons.dart';

import '../authentication/widgets/AssetLogoImage.dart';

class ChooseGroupPage extends StatefulWidget {
  final User user;
  const ChooseGroupPage({super.key, required this.user});

  @override
  State<ChooseGroupPage> createState() => _ChooseGroupPageState();
}

class _ChooseGroupPageState extends State<ChooseGroupPage> {
  GroupRepository repository = GroupRepository();
  final groupNameController = TextEditingController();
  final groupDescriptionController = TextEditingController();
  final groupDateDebutController = TextEditingController();
  final groupDateFinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              const TextSpan(
                text: 'Bonjour ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: widget.user.displayName != '' &&
                        widget.user.displayName != null
                    ? widget.user.displayName
                    : 'Kevin',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            color: Colors.grey,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Updated_FilledButton(
                      couleur: globalColorRed,
                      texte: 'Rejoindre un groupe',
                      onClick: () => showJoinGroupDialog(widget.user),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Updated_OutlinedButton(
                      couleur: globalColorRed,
                      texte: 'Créer un groupe',
                      onClick: () => showAddGroupDialog(widget.user),
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
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
                return GridView.count(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    children: listGroupes(
                      context,
                      snapshot.data!.docs
                          .map((group) => Group.fromSnapshot(group))
                          .toList(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> listGroupes(BuildContext context, List<Group> list) {
    List<Widget> cards = [];
    for (var groupe in list) {
      cards.add(boutonGroup(context, groupe));
    }
    return cards;
  }

  Widget boutonGroup(BuildContext context, Group group) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return GroupPage(
              group: group,
              user: widget.user,
            );
          },
          fullscreenDialog: true)),
      child: Container(
        decoration: BoxDecoration(
          color: globalColorRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: globalColorRed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.person)),
            const SizedBox(height: 10),
            Text(
              group.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(dateToStringDisplay(group.startDate)),
                Text(dateToStringDisplay(group.endDate)),
              ],
            )
          ],
        ),
      ),
    );
  }

  String dateToStringDisplay(DateTime date) {
    var day = '${date.day}'.length == 1 ? '0' '${date.day}' : '${date.day}';
    var month =
        '${date.month}'.length == 1 ? '0' '${date.month}' : '${date.month}';
    var year = date.year.toString().substring(2);

    return '$day.$month.$year';
  }

  void showAddGroupDialog(User user) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Ajouter un groupe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                decoration: const InputDecoration(labelText: "Nom"),
                controller: groupNameController),
            TextField(
                decoration: const InputDecoration(labelText: "Description"),
                controller: groupDescriptionController),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration:
                        const InputDecoration(labelText: "Date de début"),
                    controller: groupDateDebutController,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: "Date de fin"),
                    keyboardType: TextInputType.datetime,
                    controller: groupDateFinController,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () {
                var newGroup = Group(
                    '',
                    '',
                    groupNameController.text,
                    groupDescriptionController.text,
                    user.uid,
                    DateTime.now(),
                    DateTime.now().add(const Duration(days: 5)),
                    [user.uid],
                    []);

                repository.addGroup(newGroup);
              },
              child: Text(
                'Ajouter',
                style: TextStyle(color: globalColorRed),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showJoinGroupDialog(User user) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return JoinGroupPage(
            user: widget.user,
          );
        },
        fullscreenDialog: true));
  }
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
