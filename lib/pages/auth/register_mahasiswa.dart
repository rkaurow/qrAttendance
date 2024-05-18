import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viko_absensi/components/buttonlogin.dart';
import 'package:viko_absensi/components/logintextbox.dart';
import 'package:viko_absensi/core/bloc/regist/auth_regist_bloc.dart';

class RegisterMahasiswa extends StatefulWidget {
  const RegisterMahasiswa({super.key});

  @override
  State<RegisterMahasiswa> createState() => _RegisterMahasiswaState();
}

class _RegisterMahasiswaState extends State<RegisterMahasiswa> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _kpasswordController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();

  final String prodi = 'INFORMATIKA';

  @override
  void initState() {
    _prodiController.text = prodi;
    super.initState();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _nimController.dispose();
    _prodiController.dispose();
    _passwordController.dispose();
    _kpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'Silahkan Isi Data Diri',
                style: GoogleFonts.poppins(
                    fontSize: 20, color: Colors.grey.shade800),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Divider(),
              ),
              LoginTextBox(
                isenabled: true,
                hintText: 'Masukkan Nama',
                icon: Icons.person,
                obsecure: false,
                textEditingController: _namaController,
              ),
              LoginTextBox(
                isenabled: true,
                hintText: 'Masukkan NIM',
                icon: Icons.numbers,
                obsecure: false,
                textEditingController: _nimController,
              ),
              LoginTextBox(
                isenabled: false,
                hintText: 'Informatika'.toUpperCase(),
                icon: Icons.menu_book_rounded,
                obsecure: false,
                textEditingController: _prodiController,
              ),
              LoginTextBox(
                isenabled: true,
                hintText: 'Masukkan Email',
                icon: Icons.email,
                obsecure: false,
                textEditingController: _emailController,
              ),
              LoginTextBox(
                isenabled: true,
                hintText: 'Masukkan Password',
                icon: Icons.lock,
                obsecure: true,
                textEditingController: _passwordController,
              ),
              LoginTextBox(
                isenabled: true,
                hintText: 'Konfirmasi Password',
                icon: Icons.lock_outline,
                obsecure: true,
                textEditingController: _kpasswordController,
              ),
              const SizedBox(
                height: 20,
              ),
              BlocListener<AuthRegistBloc, AuthRegistState>(
                listener: (context, state) {
                  state.maybeWhen(
                      success: (authService) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      orElse: () {});
                },
                child: BlocBuilder<AuthRegistBloc, AuthRegistState>(
                  builder: (context, state) {
                    return state.maybeWhen(error: (message) {
                      return Center(child: Text(message));
                    }, loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }, orElse: () {
                      return LoginButton(
                          onTap: () {
                            if (_passwordController.text ==
                                _kpasswordController.text) {
                              context.read<AuthRegistBloc>().add(
                                    AuthRegistEvent.registeruser(
                                      nama: _namaController.text,
                                      email: _emailController.text,
                                      nim: _nimController.text,
                                      prodi: _prodiController.text,
                                      password: _passwordController.text,
                                      kpassword: _kpasswordController.text,
                                    ),
                                  );
                            } else {
                              const Center(
                                child: Text('Error'),
                              );
                            }
                          },
                          namatombol: 'Daftar');
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
