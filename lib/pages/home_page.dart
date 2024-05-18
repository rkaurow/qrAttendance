import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:viko_absensi/components/home_page_button.dart';
import 'package:viko_absensi/core/bloc/login/auth_login_bloc.dart';
import 'package:viko_absensi/pages/absen_qr_page.dart';
import 'package:viko_absensi/pages/auth/mahasiswa/detail_mahasiswa.dart';
import 'package:viko_absensi/pages/auth/profil_dosen.dart';
import 'package:viko_absensi/pages/kelas/kelas_page.dart';
import 'package:viko_absensi/services/constant/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String user = '';
  String tanggal = '';

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    tanggal = DateFormat.yMMMMEEEEd().format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.deepPurple),
        backgroundColor: Colors.deepPurple,
        actions: [
          BlocListener<AuthLoginBloc, AuthLoginState>(
            listener: (context, state) {
              state.maybeWhen(
                  loading: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        });
                  },
                  success: (authService) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Logout Berhasil'),
                      ),
                    );
                  },
                  orElse: () {});
            },
            child: BlocBuilder<AuthLoginBloc, AuthLoginState>(
              builder: (context, state) {
                return state.maybeWhen(orElse: () {
                  return IconButton(
                    onPressed: () {
                      context
                          .read<AuthLoginBloc>()
                          .add(const AuthLoginEvent.logout());
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.grey.shade200,
                      size: 30,
                    ),
                  );
                });
              },
            ),
          ),
        ],
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              width: screenWidth(context) * 1,
              decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Column(
                children: [
                  Text(
                    DateFormat('EEEE dd MMMM yyyy ').format(DateTime.now()),
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  DigitalClock(
                    showSecondsDigit: false,
                    colon: const Text(
                      '|',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    secondDigitTextStyle: GoogleFonts.poppins(
                      color: Colors.grey.shade200,
                      fontWeight: FontWeight.bold,
                    ),
                    digitAnimationStyle: Curves.decelerate,
                    hourMinuteDigitTextStyle: GoogleFonts.poppins(
                        color: Colors.grey.shade200, fontSize: 60),
                  ),
                ],
              ),
            ),
            // SizedBox(child: CardProfile()),

            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: users.doc(uid).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final String nama = data['nama'];

                  final String email = data['email'];

                  final String uid = data['uid'];
                  if (data['status'] == 'mahasiswa') {
                    if (data['validasi'] == 'valid') {
                      return Column(
                        children: [
                          HomePageButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AbsenPage(uid: _auth.currentUser!.uid),
                                ),
                              );
                            },
                            namabutton: 'Absen Kelas',
                            assetbutton: 'assets/svg/qricon.svg',
                            deskripsi: 'Absensi untuk Kelas',
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          HomePageButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPelajar(),
                                ),
                              );
                            },
                            namabutton: 'Detail Profil',
                            assetbutton: 'assets/svg/qricon.svg',
                            deskripsi: 'Melihat Profil',
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          LottieBuilder.network(
                              height: 150,
                              'https://lottie.host/6220a80f-aa32-409f-9c08-f764acd65dcc/fM6a8IwmgH.json'),
                          Text(
                            'Akun Bermasalah',
                            style: GoogleFonts.poppins(
                                fontSize: 20, color: Colors.grey.shade600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Silahkan Hubungi Admin Untuk Mempercepat Aktivasi',
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: Colors.grey.shade400),
                          ),
                        ],
                      );
                    }
                  }
                  if (data['status'] == 'Dosen') {
                    if (data['validasi'] == 'valid') {
                      return Column(
                        children: [
                          HomePageButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const KelasPage(),
                                ),
                              );
                            },
                            namabutton: 'Ruang Kelas',
                            assetbutton: 'assets/svg/book.svg',
                            deskripsi: 'Manajemen Absensi Mahasiswa',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          HomePageButton(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => ProfilDosen(
                                              nama: nama,
                                              nidn: data['nidn'],
                                              email: email,
                                              verifikasi: data['validasi'],
                                              uid: uid,
                                            )));
                              },
                              namabutton: 'Profil Pengajar',
                              assetbutton: 'assets/svg/dosen.svg',
                              deskripsi: 'Melihat/Edit Profil Pengajar')
                        ],
                      );
                    } else {
                      return Center(
                        child: Column(
                          children: [
                            LottieBuilder.network(
                                height: 150,
                                'https://lottie.host/6220a80f-aa32-409f-9c08-f764acd65dcc/fM6a8IwmgH.json'),
                            Text(
                              'Menunggu Validasi Dari Admin',
                              style: GoogleFonts.poppins(
                                  color: Colors.grey.shade600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Silahkan Hubungi Admin Untuk Mempercepat Aktivasi',
                              style: GoogleFonts.poppins(
                                  fontSize: 10, color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }
                return const Text('Loading');
              },
            ),
            const SizedBox(
              height: 20,
            ),
            // FutureBuilder(
            //   future: users.doc(uid).get(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       return const Text('Error');
            //     }
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Text('Loading');
            //     }
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       Map<String, dynamic> data =
            //           snapshot.data!.data() as Map<String, dynamic>;
            //       if (data['status'] == 'mahasiswa') {
            //         return HomePageButton(
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) =>
            //                     AbsenPage(uid: _auth.currentUser!.uid),
            //               ),
            //             );
            //           },
            //           namabutton: 'History Absen Kelas',
            //           assetbutton: 'assets/svg/history.svg',
            //           deskripsi: 'History Absen',
            //         );
            //       } else if (data['status'] == 'Dosen') {
            //         // return HomePageButton(
            //         //   onTap: () {
            //         //     Navigator.push(
            //         //       context,
            //         //       MaterialPageRoute(
            //         //         builder: (context) => const KelasPage(),
            //         //       ),
            //         //     );
            //         //   },
            //         //   namabutton: 'Rekap Absen',
            //         //   assetbutton: 'assets/svg/history.svg',
            //         //   deskripsi: 'Rekap Absensi Mahasiswa',
            //         // );
            //       }
            //     }
            //     return Center();
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
