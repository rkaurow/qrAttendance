import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonValidasi extends StatelessWidget {
  final String validasi;
  final void Function()? onTap;
  const ButtonValidasi(
      {super.key, required this.validasi, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        validasi,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: validasi == 'valid' ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
