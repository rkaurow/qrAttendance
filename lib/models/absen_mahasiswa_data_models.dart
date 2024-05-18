// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Absen {
  final String nama;
  final String nim;
  final String prodi;
  final String uid;
  final String kehadiran;
  Absen({
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.uid,
    required this.kehadiran,
  });

  Absen copyWith({
    String? nama,
    String? nim,
    String? prodi,
    String? uid,
    String? kehadiran,
  }) {
    return Absen(
      nama: nama ?? this.nama,
      nim: nim ?? this.nim,
      prodi: prodi ?? this.prodi,
      uid: uid ?? this.uid,
      kehadiran: kehadiran ?? this.kehadiran,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nama': nama,
      'nim': nim,
      'prodi': prodi,
      'uid': uid,
      'kehadiran': kehadiran,
    };
  }

  factory Absen.fromMap(Map<String, dynamic> map) {
    return Absen(
      nama: map['nama'] as String,
      nim: map['nim'] as String,
      prodi: map['prodi'] as String,
      uid: map['uid'] as String,
      kehadiran: map['kehadiran'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Absen.fromJson(String source) =>
      Absen.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Absen(nama: $nama, nim: $nim, prodi: $prodi, uid: $uid, kehadiran: $kehadiran)';
  }

  @override
  bool operator ==(covariant Absen other) {
    if (identical(this, other)) return true;

    return other.nama == nama &&
        other.nim == nim &&
        other.prodi == prodi &&
        other.uid == uid &&
        other.kehadiran == kehadiran;
  }

  @override
  int get hashCode {
    return nama.hashCode ^
        nim.hashCode ^
        prodi.hashCode ^
        uid.hashCode ^
        kehadiran.hashCode;
  }
}
