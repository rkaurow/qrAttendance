// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Kelas {
  final String namaKelas;
  final String iDKelas;
  final String namaDosen;
  final String uIdDosen;
  Kelas({
    required this.namaKelas,
    required this.iDKelas,
    required this.namaDosen,
    required this.uIdDosen,
  });

  Kelas copyWith({
    String? namaKelas,
    String? iDKelas,
    String? namaDosen,
    String? uIdDosen,
  }) {
    return Kelas(
      namaKelas: namaKelas ?? this.namaKelas,
      iDKelas: iDKelas ?? this.iDKelas,
      namaDosen: namaDosen ?? this.namaDosen,
      uIdDosen: uIdDosen ?? this.uIdDosen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nama Kelas': namaKelas,
      'iD Kelas': iDKelas,
      'nama Dosen': namaDosen,
      'uId Dosen': uIdDosen,
    };
  }

  factory Kelas.fromMap(Map<String, dynamic> map) {
    return Kelas(
      namaKelas: map['nama Kelas'] as String,
      iDKelas: map['iD Kelas'] as String,
      namaDosen: map['nama Dosen'] as String,
      uIdDosen: map['uId Dosen'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Kelas.fromJson(String source) =>
      Kelas.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Kelas(namaKelas: $namaKelas, iDKelas: $iDKelas, namaDosen: $namaDosen, uIdDosen: $uIdDosen)';
  }

  @override
  bool operator ==(covariant Kelas other) {
    if (identical(this, other)) return true;

    return other.namaKelas == namaKelas &&
        other.iDKelas == iDKelas &&
        other.namaDosen == namaDosen &&
        other.uIdDosen == uIdDosen;
  }

  @override
  int get hashCode {
    return namaKelas.hashCode ^
        iDKelas.hashCode ^
        namaDosen.hashCode ^
        uIdDosen.hashCode;
  }
}
