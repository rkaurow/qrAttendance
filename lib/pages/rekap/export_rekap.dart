import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportRekap extends StatefulWidget {
  final String kelasid;
  const ExportRekap({super.key, required this.kelasid});

  @override
  State<ExportRekap> createState() => _ExportRekapState();
}

class _ExportRekapState extends State<ExportRekap> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 1));
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Future<Map<String, Map<String, dynamic>>> _getAttendanceReport(
      String idkelas) async {
    Map<String, Map<String, dynamic>> report = {};

    for (DateTime date = _startDate;
        date.isBefore(_endDate.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
      String formattedDate = DateFormat('dd-MMMM-yyyy').format(date);
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('Rekap')
          .doc(idkelas)
          .collection('Tanggal')
          .doc(formattedDate)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        CollectionReference mahasiswaCollection = _firestore
            .collection('Rekap')
            .doc(idkelas)
            .collection('Tanggal')
            .doc(formattedDate)
            .collection('Mahasiswa');
        QuerySnapshot mahasiswaSnapshot = await mahasiswaCollection.get();
        Map<String, dynamic> attendanceData = {};
        for (var doc in mahasiswaSnapshot.docs) {
          attendanceData[doc.id] = doc.data();
        }
        report[formattedDate] = attendanceData;
      }
    }
    return report;
  }

  Future<void> _generatePdf(Map<String, Map<String, dynamic>> report) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: 3);
    grid.headers.add(1);

    final PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Tanggal';
    header.cells[1].value = 'Nama Siswa';
    header.cells[2].value = 'Kehadiran';

    report.forEach((date, attendance) {
      attendance.forEach((uid, data) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = date;
        row.cells[1].value = data['nama'];
        row.cells[2].value = data['kehadiran'];
      });
    });

    final List<int> bytes = await document.save();
    document.dispose();
    final String datenama = DateFormat('dd-MMMM-yyyy').format(DateTime.now());

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/AttendanceReport.pdf');
    await file.writeAsBytes(bytes, flush: true);
    final imagepath = 'report/${datenama}.pdf';
    final uploadtask =
        FirebaseStorage.instance.ref().child(imagepath).putFile(file);
    final snapshot = await uploadtask.whenComplete(() => null);
    final downloadurl = await snapshot.ref.getDownloadURL();
    print(downloadurl);
    final url = Uri.parse(downloadurl);
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      print('can launch $url');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('PDF Report Generated: $path/AttendanceReport.pdf')),
    );
  }

  Future<void> _showDateSelector(BuildContext context, bool isStart) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Column(
            children: [
              SizedBox(height: 8.0),
              Text(
                isStart ? 'Pilih Tanggal Mulai' : 'Pilih Tanggal Akhir',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: TableCalendar(
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2100),
                  focusedDay: isStart ? _startDate : _endDate,
                  selectedDayPredicate: (day) {
                    return isStart
                        ? isSameDay(day, _startDate)
                        : isSameDay(day, _endDate);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      if (isStart) {
                        _startDate = selectedDay;
                      } else {
                        _endDate = selectedDay;
                      }
                    });
                    Navigator.pop(context);
                  },
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, date, events) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleGenerateReport(String idkelas) async {
    Map<String, Map<String, dynamic>> report =
        await _getAttendanceReport(widget.kelasid);
    if (report.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Tidak ada data absensi untuk tanggal yang dipilih')),
      );
    } else {
      await _generatePdf(report);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ganti dengan ID kelas yang relevan

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text(
          'Export',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showDateSelector(context, true);
                },
                child: Text('Pilih Tanggal Mulai'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showDateSelector(context, false);
                },
                child: Text('Pilih Tanggal Akhir'),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text('Tanggal Mulai: ${DateFormat('yyyy-MM-dd').format(_startDate)}'),
          Text('Tanggal Akhir: ${DateFormat('yyyy-MM-dd').format(_endDate)}'),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () async {
              await _handleGenerateReport(widget.kelasid);
            },
            child: Text('Generate PDF'),
          ),
          Expanded(
            child: FutureBuilder<Map<String, Map<String, dynamic>>>(
              future: _getAttendanceReport(widget.kelasid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  Map<String, Map<String, dynamic>>? report = snapshot.data;
                  if (report == null || report.isEmpty) {
                    return Center(child: Text('Tidak ada data'));
                  }

                  return ListView(
                    children: report.entries.map((entry) {
                      return Card(
                        child: ListTile(
                          title: Text(entry.key),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: entry.value.entries.map((e) {
                              return Text(
                                  '${e.value['nama']}: ${e.value['kehadiran']}');
                            }).toList(),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
