import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viko_absensi/components/logintextbox.dart';
import 'package:viko_absensi/core/bloc/regist/auth_regist_bloc.dart';
import 'package:viko_absensi/services/constant/constant.dart';
import 'package:viko_absensi/services/data_services.dart';

class EditProfilMahasiswa extends StatefulWidget {
  const EditProfilMahasiswa({super.key});

  @override
  State<EditProfilMahasiswa> createState() => _EditProfilMahasiswaState();
}

class _EditProfilMahasiswaState extends State<EditProfilMahasiswa> {
  final picker = ImagePicker();
  String pathgambar = '';
  final DataService dataService = DataService();

  Future<void> pilihgambar() async {
    var pickedfile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      // ignore: use_build_context_synchronously
      context.read<AuthRegistBloc>().add(AuthRegistEvent.uploadPP(
          fotoprofil: File(pickedfile.path),
          namafile: FirebaseAuth.instance.currentUser!.uid));
    } else {
      // ignore: avoid_print
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
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
                  if (snapshot.hasData) {
                    final TextEditingController namacontroller =
                        TextEditingController();
                    final TextEditingController nimcontroller =
                        TextEditingController();

                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final String fotoprofil = data['fotoprofil'];
                    namacontroller.text = data['nama'];
                    nimcontroller.text = data['nim'];
                    return Column(
                      children: [
                        fotoprofil == ''
                            ? CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                radius: screenHeight(context) * 0.15,
                                child: BlocListener<AuthRegistBloc,
                                    AuthRegistState>(
                                  listener: (context, state) {
                                    state.maybeWhen(
                                      upload: (downloadurl) {
                                        dataService.uploadfoto(downloadurl);
                                      },
                                      error: (message) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(message)));
                                      },
                                      orElse: () {},
                                    );
                                  },
                                  child: BlocBuilder<AuthRegistBloc,
                                      AuthRegistState>(
                                    builder: (context, state) {
                                      return state.maybeWhen(loading: () {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }, orElse: () {
                                        return GestureDetector(
                                          onTap: () {
                                            pilihgambar();
                                          },
                                          child: Icon(
                                            CupertinoIcons.person,
                                            size: screenHeight(context) * 0.15,
                                            color: Colors.white,
                                          ),
                                        );
                                      });
                                    },
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                radius: screenHeight(context) * 0.15,
                                backgroundImage: NetworkImage(fotoprofil),
                                child: BlocListener<AuthRegistBloc,
                                    AuthRegistState>(
                                  listener: (context, state) {
                                    state.maybeWhen(
                                      upload: (downloadurl) {
                                        dataService.uploadfoto(downloadurl);
                                      },
                                      error: (message) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(message)));
                                      },
                                      orElse: () {},
                                    );
                                  },
                                  child: BlocBuilder<AuthRegistBloc,
                                      AuthRegistState>(
                                    builder: (context, state) {
                                      return state.maybeWhen(loading: () {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }, orElse: () {
                                        return GestureDetector(
                                          onTap: () {
                                            pilihgambar();
                                          },
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                        LoginTextBox(
                          hintText: 'Nama',
                          icon: CupertinoIcons.person,
                          obsecure: false,
                          textEditingController: namacontroller,
                          isenabled: true,
                        ),
                        LoginTextBox(
                          hintText: 'Nim',
                          icon: CupertinoIcons.number_circle_fill,
                          obsecure: false,
                          textEditingController: nimcontroller,
                          isenabled: true,
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                        BlocListener<AuthRegistBloc, AuthRegistState>(
                          listener: (context, state) {
                            state.maybeWhen(
                                success: (authService) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Berhasil Di Update'),
                                    backgroundColor: Colors.green,
                                  ));
                                },
                                orElse: () {});
                          },
                          child: BlocBuilder<AuthRegistBloc, AuthRegistState>(
                            builder: (context, state) {
                              return state.maybeWhen(loading: () {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }, orElse: () {
                                return GestureDetector(
                                  onTap: () {
                                    context.read<AuthRegistBloc>().add(
                                        AuthRegistEvent.updatemahasiswa(
                                            nama: namacontroller.text,
                                            nim: nimcontroller.text));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      height: screenHeight(context) * 0.1,
                                      width: screenWidth(context),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.deepPurple),
                                      child: Center(
                                        child: Text(
                                          'Update Profil',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return Center();
                })
          ],
        ),
      ),
    );
  }
}
