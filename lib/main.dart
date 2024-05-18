import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viko_absensi/core/bloc/kelas/kelas_bloc.dart';
import 'package:viko_absensi/core/bloc/login/auth_login_bloc.dart';
import 'package:viko_absensi/core/bloc/mahasiswa/mahasiswa_bloc.dart';
import 'package:viko_absensi/core/bloc/qrscan/qrscan_bloc.dart';
import 'package:viko_absensi/core/bloc/regist/auth_regist_bloc.dart';
import 'package:viko_absensi/core/bloc/rekap/rekap_reset_bloc.dart';
import 'package:viko_absensi/firebase_options.dart';
import 'package:viko_absensi/services/auth_gate.dart';
import 'package:viko_absensi/services/auth_service.dart';
import 'package:viko_absensi/services/data_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MahasiswaBloc(DataService()),
        ),
        BlocProvider(
          create: (context) => AuthRegistBloc(AuthService()),
        ),
        BlocProvider(
          create: (context) => AuthLoginBloc(AuthService()),
        ),
        BlocProvider(
          create: (context) => KelasBloc(DataService()),
        ),
        BlocProvider(
          create: (context) => QrscanBloc(DataService()),
        ),
        BlocProvider(
          create: (context) => RekapResetBloc(DataService()),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const AuthGate()),
    );
  }
}
