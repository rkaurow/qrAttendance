import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viko_absensi/pages/auth/register_dosen.dart';
import 'package:viko_absensi/pages/auth/register_mahasiswa.dart';

class RegisterGate extends StatefulWidget {
  const RegisterGate({super.key});

  @override
  State<RegisterGate> createState() => _RegisterGateState();
}

class _RegisterGateState extends State<RegisterGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          'Pilih Status',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.grey.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(30)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterMahasiswa(),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.lightBlue,
                      ),
                      Text(
                        'Daftar Sebagai Mahasiswa',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.grey.shade800),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(30)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterDosen()));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_4_sharp,
                        size: 50,
                        color: Colors.grey.shade200,
                      ),
                      Text(
                        'Daftar Sebagai Dosen',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.grey.shade200),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
