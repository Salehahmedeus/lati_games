import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gameslati/helpers/consts.dart';
import 'package:gameslati/main.dart';
import 'package:gameslati/providers/authetication_provider.dart';
import 'package:gameslati/widgets/cards/clickables/main_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passowrdController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SafeArea(
                child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text("Login Screen", style: largeTitle),
            const SizedBox(height: 24),
            TextFormField(
              validator: (v) {
                if (v!.isEmpty) {
                  return "Email cannot be empty";
                }
                if (!v.contains("@") || !v.contains(".")) {
                  return "Please Enter Valid Email";
                }

                return null;
              },
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "Email",
                  labelText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              validator: (v) {
                if (v!.isEmpty) {
                  return "Password cannot be empty";
                }
                if (!v.contains("@") || !v.contains(".")) {
                  return "Password must be atleast 8 characters";
                }

                return null;
              },
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "Password",
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(
              height: 24,
            ),
            MainButton(
                label: "Login",
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Provider.of<AutheticationProvider>(context, listen: false)
                        .login(emailController.text, passowrdController.text)
                        .then((logedin) {
                      if (logedin) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const ScreenRouter()),
                            (route) => false);
                      }
                    });
                  } else {
                    if (kDebugMode) {
                      print("Form not valid");
                    }
                  }
                })
          ],
        ),
      ),
    ))));
  }
}
