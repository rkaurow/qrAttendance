import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:viko_absensi/components/buttonlogin.dart';
import 'package:viko_absensi/components/logintextbox.dart';
import 'package:viko_absensi/core/bloc/login/auth_login_bloc.dart';
import 'package:viko_absensi/pages/auth/register_gate.dart';
import 'package:viko_absensi/services/constant/constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginTextBox(
              isenabled: true,
              hintText: 'Masukan Email',
              icon: Icons.person,
              obsecure: false,
              textEditingController: _emailController,
            ),
            LoginTextBox(
              isenabled: true,
              hintText: 'Masukan Password',
              icon: Icons.key,
              obsecure: true,
              textEditingController: _passwordController,
            ),
            const SizedBox(
              height: 20,
            ),
            BlocListener<AuthLoginBloc, AuthLoginState>(
              listener: (context, state) {
                state.maybeWhen(loading: () {}, orElse: () {});
              },
              child: BlocListener<AuthLoginBloc, AuthLoginState>(
                listener: (context, state) {
                  state.maybeWhen(
                      success: (authService) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Berhasil Masuk'),
                          ),
                        );
                      },
                      loading: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                  child: LottieBuilder.asset(
                                      height: screenHeight(context) * 0.2,
                                      'assets/loading.json'));
                            });
                      },
                      error: (message) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Email/Password Salah')));
                      },
                      orElse: () {});
                },
                child: BlocBuilder<AuthLoginBloc, AuthLoginState>(
                  builder: (context, state) {
                    return state.maybeWhen(orElse: () {
                      return LoginButton(
                        onTap: () {
                          context.read<AuthLoginBloc>().add(
                                AuthLoginEvent.login(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                        },
                        namatombol: 'Masuk',
                      );
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Belum Punya Akun?',
                  style: GoogleFonts.poppins(color: Colors.grey.shade600),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterGate(),
                        ));
                  },
                  child: Text(
                    'Daftar Sekarang',
                    style: GoogleFonts.poppins(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
