import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

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
                        ? 'Enter a valid email'
                        : null,
              ),
              TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) =>
                      password != null && password.length < 6
                          ? 'Enter a password with more than 6 characters'
                          : null),
              TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (validationPassword) =>
                      validationPassword != null &&
                              validationPassword != passwordController.text
                          ? "The two passwords don't match"
                          : null),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50)),
                child: const Text('Sign Up'),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: RichText(
                    text: TextSpan(text: '', children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onclickedLogin,
                      style: (const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                      text: 'Sign In')
                ])),
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
