import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:viko_absensi/core/bloc/login/auth_login_bloc.dart';
import 'package:viko_absensi/pages/admin/data_mahasiswa.dart';
import 'package:viko_absensi/pages/admin/data_pengajar.dart';
import 'package:viko_absensi/services/constant/constant.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  final List<Widget> _page = [
    const DataMahasiswa(),
    const DataPengajar(),
  ];

  final List<String> _judul = [
    'Data Mahasiswa',
    'Data Pengajar',
  ];
  final List<IconData> _icon = [
    CupertinoIcons.person,
    CupertinoIcons.person_alt,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        // actions: [
        //   BlocBuilder<AuthLoginBloc, AuthLoginState>(
        //     builder: (context, state) {
        //       return state.maybeWhen(loading: () {
        //         return const Padding(
        //           padding: EdgeInsets.all(8.0),
        //           child: Center(
        //             child: CircularProgressIndicator(
        //               color: Colors.white,
        //             ),
        //           ),
        //         );
        //       }, orElse: () {
        //         return IconButton(
        //           onPressed: () {
        //             context
        //                 .read<AuthLoginBloc>()
        //                 .add(const AuthLoginEvent.logout());
        //           },
        //           icon: const Icon(Icons.logout),
        //         );
        //       });
        //     },
        //   )
        // ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Halaman Admin',
              style: GoogleFonts.poppins(),
            ),
            SizedBox(
              width: screenWidth(context) * 0.010,
            ),
            const Icon(
              CupertinoIcons.lock_shield,
              size: 20,
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                          bottomRight: Radius.circular(35))),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight(context) * 0.03,
                ),
                Text(
                  DateFormat('EE, dd MMMM yyyy ').format(DateTime.now()),
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                DigitalClock(
                  showSecondsDigit: false,
                  colon: const Text(
                    ':',
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
                Center(
                  child: Container(
                    height: screenHeight(context) * 0.3,
                    width: screenWidth(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade500),
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _page.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => _page[index]));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                child: Container(
                                    height: screenHeight(context) * 0.12,
                                    width: screenWidth(context) * 0.25,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Icon(
                                      _icon[index],
                                      color: Colors.deepPurple,
                                    )),
                              ),
                            ),
                            Text(
                              _judul[index],
                              style: GoogleFonts.poppins(
                                  color: Colors.deepPurple, fontSize: 10),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight(context) * 0.2,
                ),
                BlocBuilder<AuthLoginBloc, AuthLoginState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      orElse: () {
                        return SlideAction(
                          sliderRotate: false,
                          borderRadius: 15,
                          elevation: 0,
                          innerColor: Colors.white,
                          outerColor: Colors.deepPurple,
                          height: screenHeight(context) * 0.1,
                          text: 'Slide untuk Keluar',
                          textStyle: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 15),
                          sliderButtonIcon: const Icon(
                            Icons.logout,
                            color: Colors.deepPurple,
                          ),
                          onSubmit: () async {
                            await Future.delayed(const Duration(seconds: 2));

                            // ignore: use_build_context_synchronously
                            context
                                .read<AuthLoginBloc>()
                                .add(const AuthLoginEvent.logout());
                            return null;
                          },
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),

          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     HomePageButton(
          //       onTap: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (ctx) => const DataPengajar()));
          //       },
          //       namabutton: 'Data Pengajar',
          //       assetbutton: 'assets/svg/dosen.svg',
          //       deskripsi: 'Menampilkan Data Pengajar',
          //     ),
          //     SizedBox(
          //       height: 10,
          //     ),
          //     HomePageButton(
          //       onTap: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (ctx) => const DataMahasiswa()));
          //       },
          //       namabutton: 'Data Mahasiswa',
          //       assetbutton: 'assets/svg/book.svg',
          //       deskripsi: 'Menampilkan Data Mahasiswa',
          //     ),
          //     SizedBox(
          //       height: 10,
          //     ),
          //     HomePageButton(
          //       onTap: () {},
          //       namabutton: 'Data Mata Kuliah',
          //       assetbutton: 'assets/svg/book.svg',
          //       deskripsi: 'Menampilkan Mata Kuliah',
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
