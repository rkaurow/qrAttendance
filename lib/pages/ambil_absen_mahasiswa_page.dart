import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:viko_absensi/core/bloc/qrscan/qrscan_bloc.dart';
import 'package:viko_absensi/services/constant/constant.dart';

class AmbilAbsenMahasiswa extends StatefulWidget {
  final String kelasid;
  final String uid;
  const AmbilAbsenMahasiswa(
      {super.key, required this.kelasid, required this.uid});

  @override
  State<AmbilAbsenMahasiswa> createState() => _AmbilAbsenMahasiswaState();
}

class _AmbilAbsenMahasiswaState extends State<AmbilAbsenMahasiswa> {
  final CollectionReference kelas =
      FirebaseFirestore.instance.collection('Kelas');

  void pesan() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Berhasil Ambil Absen',
              style: GoogleFonts.poppins(color: Colors.green, fontSize: 12),
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Terima Kasih',
                    style: GoogleFonts.poppins(),
                  ))
            ],
            content: LottieBuilder.asset('assets/complete.json'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: kelas.doc(widget.kelasid).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something Has Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                return Column(
                  children: [
                    Container(
                      width: screenWidth(context) * 1,
                      height: screenHeight(context) * 0.3,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25)),
                          color: Colors.deepPurple),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Kelas',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              data['nama Kelas'],
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        height: screenHeight(context) * 0.2,
                        width: screenWidth(context) * 1,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 2),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.deepPurple,
                                radius: 35,
                                child: Icon(
                                  CupertinoIcons.person,
                                  color: Colors.white,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: VerticalDivider(),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nama Pengajar',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    data['nama Dosen'],
                                    style: GoogleFonts.poppins(
                                      color: Colors.deepPurple,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.3,
                    ),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('Kelas')
                          .doc(widget.kelasid)
                          .collection('Mahasiswa')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Error');
                        }
                        if (snapshot.data?.data() == null) {
                          return Center(
                            child: Column(
                              children: [
                                Text(
                                  'Anda Tidak Terdaftar Di Kelas Ini!!',
                                  style: GoogleFonts.poppins(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Silahkan Hubungi Pengajar Yang Tercantum',
                                  style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;

                        final String statuskehadiran = data['kehadiran'];

                        return statuskehadiran == 'Hadir'
                            ? Text(
                                'Anda Sudah Mengambil Absen!',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade400),
                              )
                            : BlocListener<QrscanBloc, QrscanState>(
                                listener: (context, state) {
                                  state.maybeWhen(
                                      success: (dataService) {
                                        Navigator.pop(context);
                                        pesan();
                                      },
                                      orElse: () {});
                                },
                                child: BlocBuilder<QrscanBloc, QrscanState>(
                                  builder: (context, state) {
                                    return state.maybeWhen(loading: () {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }, orElse: () {
                                      return GestureDetector(
                                        onTap: () {
                                          context.read<QrscanBloc>().add(
                                              QrscanEvent.absen(
                                                  kelasid: widget.kelasid,
                                                  uid: widget.uid));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Container(
                                            width: screenWidth(context) * 1,
                                            height:
                                                screenHeight(context) * 0.085,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.deepPurple,
                                                    width: 2),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                                child: Text(
                                              'Ambil Absen',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.deepPurple),
                                            )),
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              );
                      },
                    )
                  ],
                );
              }
              return const Text('Loading');
            },
          ),
        ],
      ),
    );
  }
}
