import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viko_absensi/core/bloc/kelas/kelas_bloc.dart';
import 'package:viko_absensi/pages/kelas/absen_page.dart';
import 'package:viko_absensi/pages/kelas/tambah_kelas.dart';

class KelasPage extends StatefulWidget {
  const KelasPage({super.key});

  @override
  State<KelasPage> createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  @override
  void initState() {
    context.read<KelasBloc>().add(const KelasEvent.getkelas());
    super.initState();
  }

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
                          builder: (context) => const TambahKelas()));
                },
                icon: const Icon(Icons.add))
          ],
          foregroundColor: Colors.grey.shade700,
          title: Text(
            'Halaman Kelas',
            style: GoogleFonts.poppins(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: BlocConsumer<KelasBloc, KelasState>(
            listener: (context, state) {
              state.maybeWhen(orElse: () {});
            },
            builder: (context, state) {
              return state.maybeWhen(loaded: (kelas) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: kelas.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.deepPurple,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AbsenPageDosen(
                                      kelasid: kelas[index].iDKelas),
                                ));
                          },
                          title: Text(
                            kelas[index].namaKelas,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            kelas[index].namaDosen,
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                          trailing: Text(
                            '${index + 1}'.toString(),
                            style: GoogleFonts.poppins(
                                color: Colors.deepPurple.shade200),
                          ),
                        ),
                      );
                    });
              }, orElse: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
            },
          ),
        ));
  }
}
