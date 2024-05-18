import 'package:flutter/material.dart';

class LoginTextBox extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final IconData icon;
  final bool obsecure;
  final bool isenabled;
  const LoginTextBox(
      {required this.hintText,
      required this.icon,
      required this.obsecure,
      required this.textEditingController,
      required this.isenabled,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
            obscureText: obsecure,
            controller: textEditingController,
            style: TextStyle(color: Colors.grey.shade700),
            decoration: InputDecoration(
              enabled: isenabled,
              prefixIcon: Icon(
                icon,
                color: Colors.grey.shade700,
              ),
              hintText: hintText,
              hintStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
