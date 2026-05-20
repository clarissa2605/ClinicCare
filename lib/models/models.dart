// lib/models/models.dart

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
    required this.id, required this.nama, required this.umur, required this.fase,
    required this.hari, required this.kepatuhan, required this.status, required this.dahak,
    required this.kontrol, required this.risiko, required this.diagnosa, required this.dokter,
    required this.alamat, required this.telp, required this.noRm,
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
  String id; // Tambahan wajib
  String nama;
  int stok;
  int maks;
  String sat;

  StokObat({
    required this.id, required this.nama, required this.stok, 
    required this.maks, required this.sat
  });

  double get persen => stok / maks;
  bool get menipis  => persen < 0.25;
  bool get waspada  => persen < 0.60;

  Map<String, dynamic> toMap() => {
    'id': id, 'nama': nama, 'stok': stok, 'maks': maks, 'sat': sat,
  };

  factory StokObat.fromMap(Map<String, dynamic> m) => StokObat(
    id: m['id'] ?? '', nama: m['nama'] ?? '', 
    stok: m['stok'] ?? 0, maks: m['maks'] ?? 0, sat: m['sat'] ?? '',
  );
}

class HasilLab {
  final String id; // Tambahan wajib
  final String idPasien;
  final String nama;
  final String jenis;
  final String hasil;
  final String tgl;
  final String status;

  const HasilLab({
    required this.id, required this.idPasien, required this.nama, required this.jenis,
    required this.hasil, required this.tgl, required this.status,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'idPasien': idPasien, 'nama': nama, 'jenis': jenis,
    'hasil': hasil, 'tgl': tgl, 'status': status,
  };

  factory HasilLab.fromMap(Map<String, dynamic> m) => HasilLab(
    id: m['id'] ?? '', idPasien: m['idPasien'] ?? '', nama: m['nama'] ?? '',
    jenis: m['jenis'] ?? '', hasil: m['hasil'] ?? '',
    tgl: m['tgl'] ?? '', status: m['status'] ?? '',
  );
}

class JadwalKontrol {
  String id; // Tambahan wajib
  String tgl;
  String pukul;
  String nama;
  String idPasien;
  String poli;
  String dokter;
  String catatan;
  String status;

  JadwalKontrol({
    required this.id, required this.tgl, required this.pukul, required this.nama,
    required this.idPasien, required this.poli, required this.dokter,
    required this.catatan, required this.status,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'tgl': tgl, 'pukul': pukul, 'nama': nama, 'idPasien': idPasien,
    'poli': poli, 'dokter': dokter, 'catatan': catatan, 'status': status,
  };

  factory JadwalKontrol.fromMap(Map<String, dynamic> m) => JadwalKontrol(
    id: m['id'] ?? '', tgl: m['tgl'] ?? '', pukul: m['pukul'] ?? '',
    nama: m['nama'] ?? '', idPasien: m['idPasien'] ?? '', poli: m['poli'] ?? '',
    dokter: m['dokter'] ?? '', catatan: m['catatan'] ?? '', status: m['status'] ?? '',
  );
}

class Peringatan {
  String id; // Tambahan wajib
  String nama;
  String idPasien;
  String isu;
  String level;
  String aksi;

  Peringatan({
    required this.id, required this.nama, required this.idPasien,
    required this.isu, required this.level, required this.aksi,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'nama': nama, 'idPasien': idPasien, 'isu': isu,
    'level': level, 'aksi': aksi,
  };

  factory Peringatan.fromMap(Map<String, dynamic> m) => Peringatan(
    id: m['id'] ?? '', nama: m['nama'] ?? '', idPasien: m['idPasien'] ?? '',
    isu: m['isu'] ?? '', level: m['level'] ?? '', aksi: m['aksi'] ?? '',
  );
}

class KontenEdukasi {
  String id; // Tambahan wajib
  String judul;
  String kategori;
  String durasi;
  int views;
  String isi;

  KontenEdukasi({
    required this.id, required this.judul, required this.kategori,
    required this.durasi, required this.views, required this.isi,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'judul': judul, 'kategori': kategori, 'durasi': durasi,
    'views': views, 'isi': isi,
  };

  factory KontenEdukasi.fromMap(Map<String, dynamic> m) => KontenEdukasi(
    id: m['id'] ?? '', judul: m['judul'] ?? '', kategori: m['kategori'] ?? '',
    durasi: m['durasi'] ?? '', views: m['views'] ?? 0, isi: m['isi'] ?? '',
  );
}

class AntrianItem {
  String id; // Tambahan wajib
  String no;
  String nama;
  int umur;
  String keperluan;
  String tglDaftar;
  String status;
  String prioritas;
  String estimasi;

  AntrianItem({
    required this.id, required this.no, required this.nama, required this.umur,
    required this.keperluan, required this.tglDaftar, required this.status,
    required this.prioritas, required this.estimasi,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'no': no, 'nama': nama, 'umur': umur, 'keperluan': keperluan,
    'tglDaftar': tglDaftar, 'status': status, 'prioritas': prioritas, 'estimasi': estimasi,
  };

  factory AntrianItem.fromMap(Map<String, dynamic> m) => AntrianItem(
    id: m['id'] ?? '', no: m['no'] ?? '', nama: m['nama'] ?? '',
    umur: m['umur'] ?? 0, keperluan: m['keperluan'] ?? '',
    tglDaftar: m['tglDaftar'] ?? '', status: m['status'] ?? '',
    prioritas: m['prioritas'] ?? '', estimasi: m['estimasi'] ?? '',
  );
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
  // PoliInfo sifatnya konstan/statis, nggak perlu masuk DB
}