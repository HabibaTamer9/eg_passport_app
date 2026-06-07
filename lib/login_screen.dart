import 'package:flutter/material.dart';

class Loginscreen extends StatelessWidget {
  static const String routeName = "loginScreen";
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("login"),
        centerTitle: true,
      ),
    );
  }
}
