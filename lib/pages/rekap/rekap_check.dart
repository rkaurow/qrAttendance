import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RekapCheck extends StatefulWidget {
  final String docid;
  final String idTimestamp;
  final String tanggal;
  const RekapCheck(
      {super.key,
      required this.idTimestamp,
      required this.tanggal,
      required this.docid});

  @override
  State<RekapCheck> createState() => _RekapCheckState();
}

class _RekapCheckState extends State<RekapCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.grey.shade700,
        title: Text(
          widget.tanggal,
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Column(
        children: [
          Text(
            'Tanggal : ${widget.tanggal}',
            style:
                GoogleFonts.poppins(color: Colors.grey.shade700, fontSize: 20),
          ),
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Rekap')
                .doc(widget.docid)
                .collection('Tanggal')
                .doc(widget.idTimestamp)
                .collection('Mahasiswa')
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
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data = doc.data();
                    return Card(
                      color: data['kehadiran'] == 'Hadir'
                          ? Colors.green
                          : Colors.red,
                      child: ListTile(
                        title: Text(
                          data['nama'],
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        subtitle: Text(
                          data['kehadiran'],
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
