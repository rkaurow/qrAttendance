import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viko_absensi/pages/auth/mahasiswa/edit_profil_mahasiswa.dart';
import 'package:viko_absensi/services/constant/constant.dart';

class DetailPelajar extends StatefulWidget {
  const DetailPelajar({super.key});

  @override
  State<DetailPelajar> createState() => _DetailPelajarState();
}

class _DetailPelajarState extends State<DetailPelajar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            final String nama = data['nama'];
            final String email = data['email'];
            final String prodi = data['prodi'];
            final String semester = data['semester'];
            final String validasi = data['validasi'];
            final String nim = data['nim'];
            final String fotoprofil = data['fotoprofil'];

            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: fotoprofil == ''
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: screenHeight(context) * 0.1,
                              child: const Icon(
                                CupertinoIcons.person,
                                size: 50,
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: screenHeight(context) * 0.1,
                              backgroundImage: NetworkImage(fotoprofil),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        nama,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        nim,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                        height: screenHeight(context) * 0.4,
                        width: screenWidth(context) * 1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Email :',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    email,
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'NIM :',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    nim,
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Status :',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    data['status'],
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Semester :',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    semester,
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Program Studi :',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    prodi,
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Validasi :',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    validasi,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: validasi == 'invalid'
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EditProfilMahasiswa()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: screenHeight(context) * 0.1,
                          width: screenWidth(context),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.deepPurple),
                          child: Center(
                            child: Text(
                              'Edit Profil',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
