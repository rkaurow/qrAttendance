import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:viko_absensi/models/dosen_data_models.dart';
import 'package:viko_absensi/models/mahasiswa_data_models.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UserCredential> masuk(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> keluar() async {
    return await _firebaseAuth.signOut();
  }

  Future<UserCredential> daftarmahasiswa(String nama, String nim, String prodi,
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final String uid = _firebaseAuth.currentUser!.uid;

      await _firestore.collection('users').doc(uid).set(
            Mahasiswa(
                    status: 'mahasiswa',
                    semester: '2',
                    email: email,
                    uid: uid,
                    nama: nama,
                    nim: nim,
                    prodi: prodi,
                    fotoprofil: '',
                    validasi: 'invalid')
                .toMap(),
          );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> daftardosen(
      String nama, String nidn, String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final String uid = _firebaseAuth.currentUser!.uid;

      await _firestore.collection('users').doc(uid).set(Dosen(
            nama: nama,
            nidn: nidn,
            status: 'Dosen',
            uid: uid,
            email: email,
            validasi: 'invalid',
            fotoprofil: '',
          ).toMap());

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> updateDosen(String uid, String nama, String nidn) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'nama': nama, 'nidn': nidn});
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> validasiDosen(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'validasi': 'valid',
    });
  }

  Future<void> unvalidasiDosen(String uid) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'validasi': 'invalid'});
  }

  Future<void> updateprofilmahasiswa(String nama, String nim) async {
    await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      'nama': nama,
      'nim': nim,
    });
  }

  Future<void> uploadfoto(File image) async {
    final imgref = _storage.ref().child('img');
    try {
      await imgref.putFile(image);
    } on FirebaseException catch (e) {
      throw e.toString();
    }
  }
}
