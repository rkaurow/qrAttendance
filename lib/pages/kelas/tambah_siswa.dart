import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viko_absensi/core/bloc/mahasiswa/mahasiswa_bloc.dart';

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
              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data =
                      doc.data()! as Map<String, dynamic>;
                  if (data['status'] == 'mahasiswa') {
                    return Card(
                      child: BlocListener<MahasiswaBloc, MahasiswaState>(
                        listener: (context, state) {
                          state.maybeWhen(
                              success: (dataService) {
                                Navigator.pop(context);
                              },
                              orElse: () {});
                        },
                        child: BlocBuilder<MahasiswaBloc, MahasiswaState>(
                          builder: (context, state) {
                            return state.maybeWhen(loading: () {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }, orElse: () {
                              return ListTile(
                                onTap: () {
                                  context.read<MahasiswaBloc>().add(
                                      MahasiswaEvent.tambahmahasiswa(
                                          nama: data['nama'],
                                          uid: data['uid'],
                                          nim: data['nim'],
                                          prodi: data['prodi'],
                                          idkelas: widget.kelasId));
                                },
                                subtitle: Text(data['prodi']),
                                title: Text(
                                  data['nama'],
                                ),
                              );
                            });
                          },
                        ),
                      ),
                    );
                  }
                  return const Center();
                }).toList(),
              );
            }));
  }
}
