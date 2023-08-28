import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:le_planning/shared/global_colors.dart';
import 'package:le_planning/widgets/buttons.dart';

import 'auth_service.dart';
import 'widgets/AssetLogoImage.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.all(20),
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
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (login) =>
                    login != null && !EmailValidator.validate(login)
                        ? "L'adresse n'est pas valide"
                        : null,
              ),
              const SizedBox(height: 10),
              const Text(
                'Reçois un email pour réinitialiser ton mot de passe.',
                style: TextStyle(color: Colors.grey),
              ),
              const Text(
                '(Vérifie tes spams !)',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 50),
              Updated_FilledButton(
                  texte: 'Réinitialiser',
                  couleur: globalColorRed,
                  onClick: resetPassword),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    AuthService auth = AuthService();
    auth.resetPassword(context, emailController.text);
  }
}
