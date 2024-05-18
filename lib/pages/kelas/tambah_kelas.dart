import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viko_absensi/components/buttonlogin.dart';
import 'package:viko_absensi/components/logintextbox.dart';
import 'package:viko_absensi/core/bloc/kelas/kelas_bloc.dart';
import 'package:viko_absensi/pages/kelas/kelas_page.dart';

class TambahKelas extends StatefulWidget {
  const TambahKelas({super.key});

  @override
  State<TambahKelas> createState() => _TambahKelasState();
}

class _TambahKelasState extends State<TambahKelas> {
  final TextEditingController _namakelasController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.grey.shade700,
        title: Text(
          'Tambah Kelas',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Column(
        children: [
          LoginTextBox(
            hintText: 'Masukan Nama Kelas',
            icon: Icons.room_service_rounded,
            obsecure: false,
            textEditingController: _namakelasController,
            isenabled: true,
          ),
          BlocListener<KelasBloc, KelasState>(
            listener: (context, state) {
              state.maybeWhen(
                  error: (message) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(child: Text(message));
                        });
                  },
                  success: (dataService) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KelasPage(),
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Berhasil Tambah Kelas'),
                      ),
                    );
                  },
                  // loading: () {
                  //   showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return const Center(
                  //             child: CircularProgressIndicator());
                  //       });
                  // },
                  orElse: () {});
            },
            child: BlocBuilder<KelasBloc, KelasState>(
              builder: (context, state) {
                return state.maybeWhen(loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }, orElse: () {
                  return LoginButton(
                      onTap: () {
                        context.read<KelasBloc>().add(
                              KelasEvent.tambahkelas(
                                namakelas: _namakelasController.text,
                              ),
                            );
                      },
                      namatombol: 'Simpan Kelas');
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
