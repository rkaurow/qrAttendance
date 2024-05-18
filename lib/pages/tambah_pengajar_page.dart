import 'package:flutter/material.dart';
import 'package:viko_absensi/components/buttonlogin.dart';
import 'package:viko_absensi/components/logintextbox.dart';

class TambahPengajar extends StatefulWidget {
  const TambahPengajar({super.key});

  @override
  State<TambahPengajar> createState() => _TambahPengajarState();
}

class _TambahPengajarState extends State<TambahPengajar> {
  final TextEditingController _namacontroller = TextEditingController();
  final TextEditingController _nimcontroller = TextEditingController();

  String testmessage = 'Mantap';

  void tambahpelajar() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pelajar'),
      ),
      body: Column(
        children: [
          LoginTextBox(
            isenabled: true,
            hintText: 'Masukkan Nama',
            icon: Icons.person,
            obsecure: false,
            textEditingController: _namacontroller,
          ),
          LoginTextBox(
            isenabled: true,
            hintText: 'Masukkan Nim',
            icon: Icons.numbers,
            obsecure: false,
            textEditingController: _nimcontroller,
          ),
          LoginButton(
              onTap: () {
                tambahpelajar();
                Navigator.pop(context);
              },
              namatombol: 'Daftar'),
          Text(testmessage)
        ],
      ),
    );
  }
}
