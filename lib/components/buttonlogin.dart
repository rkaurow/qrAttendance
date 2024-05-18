import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButton extends StatelessWidget {
  final void Function()? onTap;
  final String namatombol;
  const LoginButton({
    required this.onTap,
    required this.namatombol,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueAccent),
          child: Center(
              child: Text(
            namatombol.toUpperCase(),
            style: GoogleFonts.poppins(
              color: Colors.grey.shade300,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }
}
