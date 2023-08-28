import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:le_planning/shared/global_colors.dart';
import 'package:le_planning/widgets/buttons.dart';

import 'auth_service.dart';
import 'forgot_password_page.dart';
import 'widgets/AssetLogoImage.dart';

class Login extends StatefulWidget {
  final VoidCallback onclickedRegister;
  const Login({super.key, required this.onclickedRegister});

  @override
  LoginState createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: loginController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: GestureDetector(
                child: const Text(
                  'Mot de passe oublié ?',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ForgotPasswordPage())),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: Updated_FilledButton(
                  texte: 'Connexion', couleur: globalColorRed, onClick: logIn),
            ),
            SizedBox(
              width: double.infinity,
              child: Updated_OutlinedButton(
                  texte: 'Inscription',
                  couleur: globalColorRed,
                  onClick: widget.onclickedRegister),
            )
          ],
        ),
      ),
    );
  }

  Future logIn() async {
    AuthService auth = AuthService();
    auth.logIn(context, loginController.text, passwordController.text);
  }
}
