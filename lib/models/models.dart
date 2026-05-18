// lib/models/models.dart
// ─── Data models — ganti field ini dengan kolom SQLite saat backend terhubung ───

class Pasien {
  final String id;
  String nama;
  int umur;
  String fase;
  int hari;
  int kepatuhan;
  String status;
  String dahak;
  String kontrol;
  String risiko;
  String diagnosa;
  String dokter;
  String alamat;
  String telp;
  String noRm;

  Pasien({
    required this.id,
    required this.nama,
    required this.umur,
    required this.fase,
    required this.hari,
    required this.kepatuhan,
    required this.status,
    required this.dahak,
    required this.kontrol,
    required this.risiko,
    required this.diagnosa,
    required this.dokter,
    required this.alamat,
    required this.telp,
    required this.noRm,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'nama': nama, 'umur': umur, 'fase': fase, 'hari': hari,
    'kepatuhan': kepatuhan, 'status': status, 'dahak': dahak,
    'kontrol': kontrol, 'risiko': risiko, 'diagnosa': diagnosa,
    'dokter': dokter, 'alamat': alamat, 'telp': telp, 'no_rm': noRm,
  };

  factory Pasien.fromMap(Map<String, dynamic> m) => Pasien(
    id: m['id'], nama: m['nama'], umur: m['umur'], fase: m['fase'],
    hari: m['hari'], kepatuhan: m['kepatuhan'], status: m['status'],
    dahak: m['dahak'], kontrol: m['kontrol'], risiko: m['risiko'],
    diagnosa: m['diagnosa'], dokter: m['dokter'], alamat: m['alamat'],
    telp: m['telp'] ?? '', noRm: m['no_rm'] ?? m['id'],
  );
}

class StokObat {
  String nama;
  int stok;
  int maks;
  String sat;

  StokObat({required this.nama, required this.stok, required this.maks, required this.sat});

  double get persen => stok / maks;
  bool get menipis  => persen < 0.25;
  bool get waspada  => persen < 0.60;
}

class HasilLab {
  final String idPasien;
  final String nama;
  final String jenis;
  final String hasil;
  final String tgl;
  final String status;

  const HasilLab({
    required this.idPasien, required this.nama, required this.jenis,
    required this.hasil, required this.tgl, required this.status,
  });
}

class JadwalKontrol {
  String tgl;
  String pukul;
  String nama;
  String idPasien;
  String poli;
  String dokter;
  String catatan;
  String status;

  JadwalKontrol({
    required this.tgl, required this.pukul, required this.nama,
    required this.idPasien, required this.poli, required this.dokter,
    required this.catatan, required this.status,
  });
}

class Peringatan {
  String nama;
  String idPasien;
  String isu;
  String level;
  String aksi;

  Peringatan({
    required this.nama, required this.idPasien,
    required this.isu, required this.level, required this.aksi,
  });
}

class KontenEdukasi {
  String judul;
  String kategori;
  String durasi;
  int views;
  String isi;

  KontenEdukasi({
    required this.judul, required this.kategori,
    required this.durasi, required this.views, required this.isi,
  });
}

class AntrianItem {
  String no;
  String nama;
  int umur;
  String keperluan;
  String tglDaftar;
  String status;
  String prioritas;
  String estimasi;

  AntrianItem({
    required this.no, required this.nama, required this.umur,
    required this.keperluan, required this.tglDaftar, required this.status,
    required this.prioritas, required this.estimasi,
  });
}

class PoliInfo {
  final String kode;
  final String nama;
  final int warna;      // Color value
  final String ikon;
  final String dokter;

  const PoliInfo({
    required this.kode, required this.nama, required this.warna,
    required this.ikon, required this.dokter,
  });
}
