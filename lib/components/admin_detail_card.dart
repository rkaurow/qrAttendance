import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viko_absensi/components/button_validasi.dart';
import 'package:viko_absensi/services/constant/constant.dart';

class AdminDetailCard extends StatelessWidget {
  final String nama;
  final String email;
  final String semeornidn;
  final String validasi;
  final String fotoprofil;
  final void Function()? onTap;
  const AdminDetailCard(
      {super.key,
      required this.nama,
      required this.email,
      required this.semeornidn,
      required this.validasi,
      required this.onTap,
      required this.fotoprofil});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
      child: Container(
        height: screenHeight(context) * 0.2,
        width: screenWidth(context) * 1,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade400, width: 2),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        semeornidn,
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        email,
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonValidasi(
                        validasi: validasi,
                        onTap: onTap,
                      )
                    ],
                  ),
                ],
              ),
              fotoprofil == ''
                  ? CircleAvatar(
                      radius: screenHeight(context) * 0.05,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(
                        CupertinoIcons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  : CircleAvatar(
                      radius: screenHeight(context) * 0.05,
                      backgroundColor: Colors.deepPurple,
                      backgroundImage: NetworkImage(fotoprofil),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
