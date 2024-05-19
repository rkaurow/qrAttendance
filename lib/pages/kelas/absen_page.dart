import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:viko_absensi/core/bloc/rekap/rekap_reset_bloc.dart';
import 'package:viko_absensi/pages/kelas/tambah_siswa.dart';
import 'package:viko_absensi/pages/rekap/rekap_page.dart';
import 'package:viko_absensi/services/constant/constant.dart';
import 'package:viko_absensi/services/data_services.dart';

class AbsenPageDosen extends StatefulWidget {
  final String kelasid;
  const AbsenPageDosen({super.key, required this.kelasid});

  @override
  State<AbsenPageDosen> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPageDosen> {
  final DataService dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RekapPage(kelasId: widget.kelasid),
                  ));
            },
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahSiswa(kelasId: widget.kelasid),
                  ));
            },
            icon: const Icon(Icons.add),
          ),
        ],
        foregroundColor: Colors.grey.shade700,
        title: Text(
          'Absen',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Kelas')
                .doc(widget.kelasid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('ERROR');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              final String statuskelas = data['statuskelas'];
              return statuskelas == 'mulai'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: QrImageView(
                            data: widget.kelasid,
                            version: QrVersions.auto,
                            size: 200,
                          ),
                        ),
                        Text(
                          'Kode Kelas : ${widget.kelasid}',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        Expanded(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Kelas')
                                  .doc(widget.kelasid)
                                  .collection('Mahasiswa')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Error');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: ListView(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: snapshot.data!.docs.map((doc) {
                                        Map<String, dynamic> data = doc.data();
                                        return Card(
                                          color: data['kehadiran'] == 'Hadir'
                                              ? Colors.green
                                              : Colors.red,
                                          child: ListTile(
                                            title: Text(
                                              data['nama'],
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white),
                                            ),
                                            subtitle: Text(
                                              data['kehadiran'],
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }).toList()),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BlocListener<RekapResetBloc, RekapResetState>(
                          listener: (context, state) {
                            state.maybeWhen(
                                success: (dataService) {
                                  dataService.updatestatuskelas(
                                      widget.kelasid, 'belum');
                                  Navigator.pop(context);
                                },
                                orElse: () {});
                          },
                          child: BlocBuilder<RekapResetBloc, RekapResetState>(
                            builder: (context, state) {
                              return state.maybeWhen(loading: () {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }, orElse: () {
                                return InkWell(
                                  onTap: () {
                                    context.read<RekapResetBloc>().add(
                                          RekapResetEvent.rekap(
                                            idkelas: widget.kelasid,
                                          ),
                                        );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      height: 70,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.deepPurple),
                                      child: Center(
                                          child: Text(
                                        'Kelas Selesai',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 20),
                                      )),
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text('Kelas Belum Mulai!')),
                                Text(
                                    textAlign: TextAlign.center,
                                    'Silahkan Mulai Kelas Dengan Menekan Tombol Mulai Kelas!'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                dataService.updatestatuskelas(
                                    widget.kelasid, 'mulai');
                              },
                              child: Container(
                                height: screenHeight(context) * 0.1,
                                width: screenWidth(context),
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: Text(
                                    'Mulai Kelas',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
            },
          )
        ],
      ),
    );
  }
}
