import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:le_planning/shared/global_colors.dart';
import 'package:le_planning/widgets/buttons.dart';

import 'widgets/AssetLogoImage.dart';

class Register extends StatefulWidget {
  final VoidCallback onclickedLogin;
  const Register({super.key, required this.onclickedLogin});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 100),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(image: asssetLogoImage()),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: loginController,
                decoration: const InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (login) =>
                    login != null && !EmailValidator.validate(login)
                        ? "L'adresse Email n'est pas valide"
                        : null,
              ),
              TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) =>
                      password != null && password.length < 6
                          ? "Le mot de passe doit contenir plus de 6 caractères"
                          : null),
              TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Confirmer mot de passe'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (validationPassword) =>
                      validationPassword != null &&
                              validationPassword != passwordController.text
                          ? "Les deux mots de passes ne correspondent pas"
                          : null),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: Updated_OutlinedButton(
                    texte: 'Inscription',
                    couleur: globalColorRed,
                    onClick: register),
              ),
              SizedBox(
                width: double.infinity,
                child: Updated_FilledButton(
                    texte: 'Connexion',
                    couleur: globalColorRed,
                    onClick: widget.onclickedLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future register() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: loginController.text,
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      final snackbar =
          SnackBar(content: Text(e.message!), backgroundColor: Colors.black);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
