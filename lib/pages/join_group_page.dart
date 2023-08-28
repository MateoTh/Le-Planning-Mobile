import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:le_planning/pages/choose_group_page.dart';
import 'package:le_planning/repository/request_result.dart';
import 'package:le_planning/widgets/buttons.dart';

import '../repository/group_repository.dart';
import '../shared/global_colors.dart';

class JoinGroupPage extends StatefulWidget {
  final User user;

  const JoinGroupPage({super.key, required this.user});
  @override
  _JoinGroupPageState createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  GroupRepository repository = GroupRepository();
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];
  var code = '';
  String error = '';
  String popupError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalColorRed,
        title: const Text("Rejoindre un Groupe"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoApp(),
          const Text(
            "Renseigne le code d’invitation du groupe que tu souhaites rejoindre",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: onRawKeyEvent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) {
                  return SizedBox(
                    width: 40,
                    height: 50,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      onChanged: (value) => onTextChanged(index, value),
                      maxLength: 1,
                      keyboardType: TextInputType.visiblePassword,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Text(error),
          TextButton(
            onPressed: () => getGroupToJoin(),
            child: Text(
              'Rejoindre',
              style: TextStyle(color: globalColorRed),
            ),
          )
        ],
      ),
    );
  }

  void getGroupToJoin() async {
    var group = await repository.getGroupByJoinCode(getCode(), widget.user.uid);

    if (group == null) {
      error = 'Aucun groupe ne corresponds à ce code';
      setState(() {});
      return;
    }

    if (group.users.contains(widget.user.uid)) {
      error = 'Tu appartiens déjà au groupe ${group.name}';
      setState(() {});
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Rejoindre le groupe ${group.name} ?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Updated_FilledButton(
                  texte: 'Oui',
                  couleur: globalColorRed,
                  onClick: () async {
                    RequestResult result =
                        await repository.joinGroup(group.uid, widget.user.uid);
                    if (result.success) {
                      Navigator.of(context).pop();
                    }
                    popupError = result.message;
                    setState(() {});
                  },
                ),
                Updated_OutlinedButton(
                    texte: 'Non',
                    couleur: globalColorRed,
                    onClick: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void onTextChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < _controllers.length - 1) {
        _focusNodes[index + 1].requestFocus();
        _controllers[index + 1].selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controllers[index + 1].text.length,
        );
      } else {
        getCode();
      }
    }
  }

  void onRawKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      for (var i = _controllers.length - 1; i >= 0; i--) {
        if (_focusNodes[i].hasFocus && i > 0) {
          if (_controllers[i].text.isEmpty) {
            _focusNodes[i - 1].requestFocus();
            _controllers[i - 1].selection = TextSelection(
              baseOffset: 0,
              extentOffset: _controllers[i - 1].text.length,
            );
          } else {
            _controllers[i].clear();
          }
          break;
        }
      }
    }
  }

  String getCode() {
    code = '';
    for (var c in _controllers) {
      code = code + c.text;
    }
    return code;
  }
}
