import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viko_absensi/components/admin_detail_card.dart';
import 'package:viko_absensi/pages/admin/detail_pengajar_admin.dart';

class DataPengajar extends StatefulWidget {
  const DataPengajar({super.key});

  @override
  State<DataPengajar> createState() => _DataPengajarState();
}

class _DataPengajarState extends State<DataPengajar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.deepPurple,
        title: Text(
          'Data Pengajar',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('status', isEqualTo: 'Dosen')
                  .snapshots(),
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
                      DocumentSnapshot data = items[index];
                      final String nama = data['nama'];
                      final String status = data['status'];
                      final String email = data['email'];
                      final String uid = data['uid'];
                      final String fotoprofil = data['fotoprofil'];
                      return status == 'Dosen'
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPengajarAdmin(uid: uid)));
                              },
                              child: AdminDetailCard(
                                  fotoprofil: fotoprofil,
                                  onTap: () {},
                                  nama: nama,
                                  email: email,
                                  semeornidn: data['nidn'],
                                  validasi: data['validasi']),
                            )
                          : const Center(
                              child: Text('Belum Ada Data'),
                            );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
