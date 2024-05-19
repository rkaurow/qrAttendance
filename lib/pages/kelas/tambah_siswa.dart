import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viko_absensi/core/bloc/mahasiswa/mahasiswa_bloc.dart';
import 'package:viko_absensi/pages/home_page.dart';
import 'package:viko_absensi/pages/kelas/kelas_page.dart';
import 'package:viko_absensi/services/constant/constant.dart';

class TambahSiswa extends StatefulWidget {
  final String kelasId;
  const TambahSiswa({super.key, required this.kelasId});

  @override
  State<TambahSiswa> createState() => _TambahSiswaState();
}

class _TambahSiswaState extends State<TambahSiswa> {
  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.grey.shade800,
          title: Text(
            'Tambah Pelajar',
            style: GoogleFonts.poppins(),
          ),
        ),
        body: StreamBuilder(
            stream: _userStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var items = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot data = items[index];
                    return data['status'] == 'mahasiswa'
                        ? Card(
                            child: BlocListener<MahasiswaBloc, MahasiswaState>(
                              listener: (context, state) {
                                state.maybeWhen(
                                    loading: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.deepPurple,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    success: (dataService) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                          (route) => false);
                                    },
                                    orElse: () {});
                              },
                              child: BlocBuilder<MahasiswaBloc, MahasiswaState>(
                                builder: (context, state) {
                                  return state.maybeWhen(orElse: () {
                                    return GestureDetector(
                                      onTap: () {
                                        context.read<MahasiswaBloc>().add(
                                              MahasiswaEvent.tambahmahasiswa(
                                                nama: data['nama'],
                                                uid: data['uid'],
                                                nim: data['nim'],
                                                prodi: data['prodi'],
                                                idkelas: widget.kelasId,
                                              ),
                                            );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Container(
                                          height: screenHeight(context) * 0.1,
                                          width: screenWidth(context),
                                          decoration: BoxDecoration(
                                            color: Colors.deepPurple,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0, vertical: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data['nama'],
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  data['nim'],
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                },
                              ),
                            ),
                          )
                        : Center();
                  });
            }));
  }
}
