// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Mahasiswa {
  final String uid;
  final String email;
  final String nama;
  final String nim;
  final String prodi;
  final String status;
  final String semester;
  final String fotoprofil;
  final String validasi;
  Mahasiswa({
    required this.uid,
    required this.email,
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.status,
    required this.semester,
    required this.fotoprofil,
    required this.validasi,
  });

  Mahasiswa copyWith({
    String? uid,
    String? email,
    String? nama,
    String? nim,
    String? prodi,
    String? status,
    String? semester,
    String? fotoprofil,
    String? validasi,
  }) {
    return Mahasiswa(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      nama: nama ?? this.nama,
      nim: nim ?? this.nim,
      prodi: prodi ?? this.prodi,
      status: status ?? this.status,
      semester: semester ?? this.semester,
      fotoprofil: fotoprofil ?? this.fotoprofil,
      validasi: validasi ?? this.validasi,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'nama': nama,
      'nim': nim,
      'prodi': prodi,
      'status': status,
      'semester': semester,
      'fotoprofil': fotoprofil,
      'validasi': validasi,
    };
  }

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      uid: map['uid'] as String,
      email: map['email'] as String,
      nama: map['nama'] as String,
      nim: map['nim'] as String,
      prodi: map['prodi'] as String,
      status: map['status'] as String,
      semester: map['semester'] as String,
      fotoprofil: map['fotoprofil'] as String,
      validasi: map['validasi'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Mahasiswa.fromJson(String source) =>
      Mahasiswa.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Mahasiswa(uid: $uid, email: $email, nama: $nama, nim: $nim, prodi: $prodi, status: $status, semester: $semester, fotoprofil: $fotoprofil, validasi: $validasi)';
  }

  @override
  bool operator ==(covariant Mahasiswa other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.nama == nama &&
        other.nim == nim &&
        other.prodi == prodi &&
        other.status == status &&
        other.semester == semester &&
        other.fotoprofil == fotoprofil &&
        other.validasi == validasi;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        nama.hashCode ^
        nim.hashCode ^
        prodi.hashCode ^
        status.hashCode ^
        semester.hashCode ^
        fotoprofil.hashCode ^
        validasi.hashCode;
  }
}
