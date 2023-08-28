import 'package:flutter/material.dart';
import 'package:le_planning/models/group.dart';
import 'package:le_planning/shared/global_colors.dart';

class GroupSettingsPage extends StatefulWidget {
  final Group group;
  const GroupSettingsPage({super.key, required this.group});

  @override
  State<GroupSettingsPage> createState() => GroupSettingsPageState();
}

class GroupSettingsPageState extends State<GroupSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réglages ${widget.group.name}'),
        backgroundColor: globalColorRed,
      ),
      body: Center(child: Text(widget.group.joinCode)),
    );
  }
}
