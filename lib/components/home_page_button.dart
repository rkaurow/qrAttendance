// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageButton extends StatelessWidget {
  final void Function()? onTap;
  final String assetbutton;
  final String namabutton;
  final String deskripsi;

  const HomePageButton({
    Key? key,
    required this.onTap,
    required this.namabutton,
    required this.assetbutton,
    required this.deskripsi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(width: 5, color: Colors.deepPurple.shade300),
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepPurple),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namabutton,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      deskripsi,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset(
                  assetbutton,
                  color: Colors.white,
                  height: 50,
                  width: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
