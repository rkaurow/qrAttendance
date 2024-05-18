import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:viko_absensi/models/absen_mahasiswa_data_models.dart';
import 'package:viko_absensi/models/kelas_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DataService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final timestamp = Timestamp.now();
  // timestampID, bisa ganti
  final String timestampId = Timestamp.now().toDate().toString();
  final String tanggalId = DateFormat('dd-MMMM-yyyy').format(DateTime.now());

// Fungsi tambah kelas
  Future<void> tambahkelas(String namakelas) async {
    final uid = _auth.currentUser!.uid;
    DocumentReference getdata = _firestore.collection('users').doc(uid);
    DocumentSnapshot namaSnap = await getdata.get();
    String namaDosen = namaSnap.get('nama');

    final String kid = _firestore.collection('Kelas').doc().id;
    await _firestore.collection('Kelas').doc(kid).set(Kelas(
            namaKelas: namakelas,
            iDKelas: kid,
            namaDosen: namaDosen,
            uIdDosen: uid)
        .toMap());
  }

  Future<void> updateprofilmahasiswa(String nama, String nim) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'nama': nama,
      'nim': nim,
    });
  }

  Future<void> tambahsiswa(
    String idkelas,
    String nama,
    String nim,
    String prodi,
    String uid,
  ) async {
    await _firestore
        .collection('Kelas')
        .doc(idkelas)
        .collection('Mahasiswa')
        .doc(uid)
        .set(
          Absen(
            nama: nama,
            nim: nim,
            prodi: prodi,
            uid: uid,
            kehadiran: 'Tidak Hadir',
          ).toMap(),
        );
  }

  Future<List<Kelas>> getKelas() async {
    List<Kelas> kelas = [];
    try {
      final initkelas = await _firestore
          .collection('Kelas')
          .where('uId Dosen', isEqualTo: _auth.currentUser!.uid)
          .get();
      initkelas.docs.forEach((element) {
        return kelas.add(
          Kelas.fromMap(
            element.data(),
          ),
        );
      });
      return kelas;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateAbsen(String kelasid, String uid) async {
    await _firestore
        .collection('Kelas')
        .doc(kelasid)
        .collection('Mahasiswa')
        .doc(uid)
        .update({'kehadiran': 'Hadir'});
  }

  Future<void> rekap(String idkelas) async {
    await _firestore.collection('Rekap').doc(idkelas).set({
      'idkelas': idkelas,
      'timestamp': timestamp,
    });

    await _firestore
        .collection('Rekap')
        .doc(idkelas)
        .collection('Tanggal')
        .doc(tanggalId)
        .set({'timestampId': tanggalId});

    CollectionReference mahasiswaCollection =
        _firestore.collection('Kelas').doc(idkelas).collection('Mahasiswa');

    // Get all documents from the 'Mahasiswa' collection
    QuerySnapshot mahasiswaQuery = await mahasiswaCollection.get();

    for (QueryDocumentSnapshot mahasiswadoc in mahasiswaQuery.docs) {
      String namaMahasiswa = mahasiswadoc.get('nama');
      String kehadiranMahasiswa = mahasiswadoc.get('kehadiran');
      String uid = mahasiswadoc.get('uid');

      await _firestore
          .collection('Rekap')
          .doc(idkelas)
          .collection('Tanggal')
          .doc(tanggalId)
          .collection('Mahasiswa')
          .doc(uid)
          .set({
        'nama': namaMahasiswa,
        'kehadiran': kehadiranMahasiswa,
      });

      await _firestore
          .collection('Kelas')
          .doc(idkelas)
          .collection('Mahasiswa')
          .doc(uid)
          .update({'kehadiran': 'Tidak Hadir'});
    }
  }

  Future<void> uploadfoto(String urldownload) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({'foto profil': urldownload});
  }
}
