// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Kelas {
  final String namaKelas;
  final String iDKelas;
  final String namaDosen;
  final String uIdDosen;
  final String statuskelas;
  Kelas({
    required this.namaKelas,
    required this.iDKelas,
    required this.namaDosen,
    required this.uIdDosen,
    required this.statuskelas,
  });

  Kelas copyWith({
    String? namaKelas,
    String? iDKelas,
    String? namaDosen,
    String? uIdDosen,
    String? statuskelas,
  }) {
    return Kelas(
      namaKelas: namaKelas ?? this.namaKelas,
      iDKelas: iDKelas ?? this.iDKelas,
      namaDosen: namaDosen ?? this.namaDosen,
      uIdDosen: uIdDosen ?? this.uIdDosen,
      statuskelas: statuskelas ?? this.statuskelas,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'namaKelas': namaKelas,
      'iDKelas': iDKelas,
      'namaDosen': namaDosen,
      'uIdDosen': uIdDosen,
      'statuskelas': statuskelas,
    };
  }

  factory Kelas.fromMap(Map<String, dynamic> map) {
    return Kelas(
      namaKelas: map['namaKelas'] as String,
      iDKelas: map['iDKelas'] as String,
      namaDosen: map['namaDosen'] as String,
      uIdDosen: map['uIdDosen'] as String,
      statuskelas: map['statuskelas'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Kelas.fromJson(String source) =>
      Kelas.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Kelas(namaKelas: $namaKelas, iDKelas: $iDKelas, namaDosen: $namaDosen, uIdDosen: $uIdDosen, statuskelas: $statuskelas)';
  }

  @override
  bool operator ==(covariant Kelas other) {
    if (identical(this, other)) return true;

    return other.namaKelas == namaKelas &&
        other.iDKelas == iDKelas &&
        other.namaDosen == namaDosen &&
        other.uIdDosen == uIdDosen &&
        other.statuskelas == statuskelas;
  }

  @override
  int get hashCode {
    return namaKelas.hashCode ^
        iDKelas.hashCode ^
        namaDosen.hashCode ^
        uIdDosen.hashCode ^
        statuskelas.hashCode;
  }
}
