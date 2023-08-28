import 'package:flutter/material.dart';

class Updated_FilledButton extends StatelessWidget {
  final String texte;
  final Color couleur;
  final VoidCallback onClick;

  Updated_FilledButton(
      {required this.texte, required this.couleur, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(couleur),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Text(texte),
    );
  }
}

class Updated_OutlinedButton extends StatelessWidget {
  final String texte;
  final Color couleur;
  final VoidCallback onClick;

  Updated_OutlinedButton(
      {required this.texte, required this.couleur, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: couleur, width: 2.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Text(
        texte,
        style: TextStyle(color: couleur),
      ),
    );
  }
}
