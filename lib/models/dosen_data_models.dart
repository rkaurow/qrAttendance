// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Dosen {
  final String nama;
  final String nidn;
  final String status;
  final String uid;
  final String email;
  final String validasi;
  final String fotoprofil;
  Dosen({
    required this.nama,
    required this.nidn,
    required this.status,
    required this.uid,
    required this.email,
    required this.validasi,
    required this.fotoprofil,
  });

  Dosen copyWith({
    String? nama,
    String? nidn,
    String? status,
    String? uid,
    String? email,
    String? validasi,
    String? fotoprofil,
  }) {
    return Dosen(
      nama: nama ?? this.nama,
      nidn: nidn ?? this.nidn,
      status: status ?? this.status,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      validasi: validasi ?? this.validasi,
      fotoprofil: fotoprofil ?? this.fotoprofil,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nama': nama,
      'nidn': nidn,
      'status': status,
      'uid': uid,
      'email': email,
      'validasi': validasi,
      'fotoprofil': fotoprofil,
    };
  }

  factory Dosen.fromMap(Map<String, dynamic> map) {
    return Dosen(
      nama: map['nama'] as String,
      nidn: map['nidn'] as String,
      status: map['status'] as String,
      uid: map['uid'] as String,
      email: map['email'] as String,
      validasi: map['validasi'] as String,
      fotoprofil: map['fotoprofil'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Dosen.fromJson(String source) =>
      Dosen.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Dosen(nama: $nama, nidn: $nidn, status: $status, uid: $uid, email: $email, validasi: $validasi, fotoprofil: $fotoprofil)';
  }

  @override
  bool operator ==(covariant Dosen other) {
    if (identical(this, other)) return true;

    return other.nama == nama &&
        other.nidn == nidn &&
        other.status == status &&
        other.uid == uid &&
        other.email == email &&
        other.validasi == validasi &&
        other.fotoprofil == fotoprofil;
  }

  @override
  int get hashCode {
    return nama.hashCode ^
        nidn.hashCode ^
        status.hashCode ^
        uid.hashCode ^
        email.hashCode ^
        validasi.hashCode ^
        fotoprofil.hashCode;
  }
}
