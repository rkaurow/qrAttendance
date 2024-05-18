import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viko_absensi/components/admin_detail_card.dart';
import 'package:viko_absensi/core/bloc/regist/auth_regist_bloc.dart';
import 'package:viko_absensi/pages/admin/detail_mahasiswa_admin.dart';

class DataMahasiswa extends StatefulWidget {
  const DataMahasiswa({super.key});

  @override
  State<DataMahasiswa> createState() => _DataMahasiswaState();
}

class _DataMahasiswaState extends State<DataMahasiswa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text(
          'Data Mahasiswa',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('ERROR'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var items = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = items[index];
                      final String nama = doc['nama'];
                      final String email = doc['email'];
                      final String status = doc['status'];
                      final String uid = doc['uid'];
                      final String fotoprofil = doc['fotoprofil'];
                      return status == 'mahasiswa'
                          ? BlocBuilder<AuthRegistBloc, AuthRegistState>(
                              builder: (context, state) {
                                return state.maybeWhen(loading: () {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }, orElse: () {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  DetailMahasiswaAdmin(
                                                    uid: uid,
                                                  )));
                                    },
                                    child: AdminDetailCard(
                                        fotoprofil: fotoprofil,
                                        nama: nama,
                                        email: email,
                                        semeornidn: doc['nim'],
                                        validasi: doc['validasi'],
                                        onTap: () {
                                          // if (doc['validasi'] == 'valid') {
                                          //   context.read<AuthRegistBloc>().add(
                                          //       AuthRegistEvent
                                          //           .unvalidasimahasiswa(
                                          //               uid: doc['uid']));
                                          // } else {
                                          //   context.read<AuthRegistBloc>().add(
                                          //       AuthRegistEvent.validasidosen(
                                          //           uid: doc['uid']));
                                          // }
                                        }),
                                  );
                                });
                              },
                            )
                          : const Center();
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
