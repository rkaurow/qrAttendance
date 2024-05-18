import 'package:flutter/material.dart';
import 'package:viko_absensi/components/buttonlogin.dart';
import 'package:viko_absensi/components/logintextbox.dart';

class UpdateDataDiri extends StatefulWidget {
  const UpdateDataDiri({super.key});

  @override
  State<UpdateDataDiri> createState() => _UpdateDataDiriState();
}

class _UpdateDataDiriState extends State<UpdateDataDiri> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();

  void updatedatadiri() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data Diri'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: CircleAvatar(
                maxRadius: 90,
                backgroundColor: Colors.blueAccent,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            LoginTextBox(
              isenabled: true,
              hintText: 'Masukan Nama',
              icon: Icons.person,
              obsecure: false,
              textEditingController: _namaController,
            ),
            LoginTextBox(
              isenabled: true,
              hintText: 'Masukan NIM',
              icon: Icons.numbers,
              obsecure: false,
              textEditingController: _nimController,
            ),
            LoginTextBox(
              isenabled: true,
              hintText: 'Masukan Program Studi',
              icon: Icons.class_,
              obsecure: false,
              textEditingController: _prodiController,
            ),
            LoginButton(onTap: updatedatadiri, namatombol: 'Simpan')
          ],
        ),
      ),
    );
  }
}
