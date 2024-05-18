import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:viko_absensi/pages/admin/admin_dashboard.dart';
import 'package:viko_absensi/pages/home_page.dart';
import 'package:viko_absensi/pages/auth/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.email == 'admin@gmail.com') {
              return const DashboardAdmin();
            } else {
              return const HomePage();
            }
          }
          // if(snapshot.data.){
          // }
          else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
