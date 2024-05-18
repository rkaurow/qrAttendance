import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DosenComponent extends StatelessWidget {
  final String judul;
  final String isi;
  const DosenComponent({super.key, required this.judul, required this.isi});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$judul : ',
          style: GoogleFonts.poppins(color: Colors.grey.shade600),
        ),
        Text(isi,
            style: GoogleFonts.poppins(
                color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
