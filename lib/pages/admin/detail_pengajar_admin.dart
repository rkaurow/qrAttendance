import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viko_absensi/core/bloc/regist/auth_regist_bloc.dart';
import 'package:viko_absensi/services/constant/constant.dart';

class DetailPengajarAdmin extends StatefulWidget {
  final String uid;
  const DetailPengajarAdmin({super.key, required this.uid});

  @override
  State<DetailPengajarAdmin> createState() => _DetailPengajarAdminState();
}

class _DetailPengajarAdminState extends State<DetailPengajarAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .get(),
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
            final String status = data['status'];
            final String validasi = data['validasi'];
            final String nidn = data['nidn'];
            final String uid = data['uid'];
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
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: screenHeight(context) * 0.1,
                        child: const Icon(
                          CupertinoIcons.person,
                          size: 50,
                        ),
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
                        nidn,
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
                                    'NIDN :',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    nidn,
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
                                    status,
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
                    BlocListener<AuthRegistBloc, AuthRegistState>(
                      listener: (context, state) {
                        state.maybeWhen(
                            success: (authService) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text('Validasi Berhasil')));
                            },
                            orElse: () {});
                      },
                      child: BlocBuilder<AuthRegistBloc, AuthRegistState>(
                        builder: (context, state) {
                          return state.maybeWhen(loading: () {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }, orElse: () {
                            return GestureDetector(
                              onTap: () {
                                if (validasi == 'invalid') {
                                  context.read<AuthRegistBloc>().add(
                                      AuthRegistEvent.validasidosen(uid: uid));
                                }
                                if (validasi == 'valid') {
                                  context.read<AuthRegistBloc>().add(
                                      AuthRegistEvent.unvalidasimahasiswa(
                                          uid: uid));
                                }
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
                                      'Update Validasi',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        },
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
