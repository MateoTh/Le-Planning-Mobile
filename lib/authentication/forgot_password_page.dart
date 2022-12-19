import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
                        ? 'Enter a valid email'
                        : null,
              ),
              const SizedBox(height: 10),
              const Text(
                'Recieve an email to reset your password.',
                style: TextStyle(color: Colors.grey),
              ),
              const Text(
                '(Check your spams)',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50)),
                child: const Text('Reset Password'),
              ),
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
