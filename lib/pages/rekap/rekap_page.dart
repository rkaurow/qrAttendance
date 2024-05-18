import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viko_absensi/pages/rekap/export_rekap.dart';
import 'package:viko_absensi/pages/rekap/rekap_check.dart';
import 'package:viko_absensi/services/constant/constant.dart';

class RekapPage extends StatefulWidget {
  final String kelasId;
  const RekapPage({super.key, required this.kelasId});

  @override
  State<RekapPage> createState() => _RekapPageState();
}

class _RekapPageState extends State<RekapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.grey.shade700,
        title: Text(
          'Rekap Absen',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Rekap')
                  .doc(widget.kelasId)
                  .collection('Tanggal')
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

                return Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot data = items[index];
                      final String timestampid = data['timestampId'];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RekapCheck(
                                    idTimestamp: timestampid,
                                    tanggal: timestampid,
                                    docid: widget.kelasId),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Container(
                            height: screenHeight(context) * 0.25,
                            width: screenWidth(context),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tanggal',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    ),
                                    Text(
                                      timestampid,
                                      style: GoogleFonts.poppins(
                                          color: Colors.deepPurple.shade300,
                                          fontSize: 20),
                                    ),
                                    const Divider(
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Total Mahasiswa',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white),
                                            ),
                                            StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Rekap')
                                                  .doc(widget.kelasId)
                                                  .collection('Tanggal')
                                                  .doc(data.id)
                                                  .collection('Mahasiswa')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError) {
                                                  return const Text('ERROR');
                                                }
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                var items = snapshot.data!.docs;
                                                return Text(
                                                  items.length.toString(),
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Hadir',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white),
                                            ),
                                            StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Rekap')
                                                  .doc(widget.kelasId)
                                                  .collection('Tanggal')
                                                  .doc(data.id)
                                                  .collection('Mahasiswa')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError) {
                                                  return const Text('ERROR');
                                                }
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }

                                                return StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('Rekap')
                                                      .doc(widget.kelasId)
                                                      .collection('Tanggal')
                                                      .doc(data.id)
                                                      .collection('Mahasiswa')
                                                      .where('kehadiran',
                                                          isEqualTo: 'Hadir')
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data?.docs ==
                                                        null) {
                                                      return const Text(
                                                          'Loading');
                                                    }
                                                    var items =
                                                        snapshot.data!.docs;
                                                    return Text(
                                                        items.length.toString(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold));
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Tidak Hadir',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white),
                                            ),
                                            StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Rekap')
                                                  .doc(widget.kelasId)
                                                  .collection('Tanggal')
                                                  .doc(data.id)
                                                  .collection('Mahasiswa')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError) {
                                                  return const Text('ERROR');
                                                }
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }

                                                return StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('Rekap')
                                                      .doc(widget.kelasId)
                                                      .collection('Tanggal')
                                                      .doc(data.id)
                                                      .collection('Mahasiswa')
                                                      .where('kehadiran',
                                                          isEqualTo:
                                                              'Tidak Hadir')
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data?.docs ==
                                                        null) {
                                                      return const Text(
                                                          'Loading');
                                                    }
                                                    var items =
                                                        snapshot.data!.docs;
                                                    return Text(
                                                        items.length.toString(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold));
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExportRekap(
                          kelasid: widget.kelasId,
                        ),
                      ));
                },
                child: Container(
                  height: screenHeight(context) * 0.08,
                  width: screenWidth(context),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: Text(
                    'Export Rekap',
                    style: GoogleFonts.poppins(color: Colors.white),
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
