// lib/data/app_state.dart
import 'package:flutter/material.dart';
import 'database_helper.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  // 1. Data Utama (List)
  List<Pasien> pasien = [];
  List<StokObat> stok = []; 
  List<JadwalKontrol> jadwal = [];
  List<Peringatan> peringatan = [];
  List<HasilLab> lab = [];
  List<KontenEdukasi> edukasi = [];
  Map<String, List<AntrianItem>> antrian = {};

  // 2. State Helper
  String filterPasien = 'Semua Status';
  String filterPeringatan = 'Semua';
  String filterEdukasi = 'Semua';
  String poliAktif = 'UMUM';
  int pasienCounter = 0;

  // ── [DB] Fungsi Inisialisasi ──────────────────────────────────────────────
  Future<void> loadSemuaData() async {
    final db = await DatabaseHelper.database;
    
    // Load tabel pasien
    final pasienMaps = await db.query('pasien');
    pasien = pasienMaps.map((e) => Pasien.fromMap(e)).toList();

    /* Catatan buat Frontend: 
      Kalau lu udah bikin fungsi `fromMap` di file models.dart untuk tabel-tabel 
      di bawah ini, lu bisa buka (uncomment) blok kode ini biar datanya langsung ke-load.
      
      final stokMaps = await db.query('stok_obat');
      stok = stokMaps.map((e) => StokObat.fromMap(e)).toList();

      final jadwalMaps = await db.query('jadwal_kontrol');
      jadwal = jadwalMaps.map((e) => JadwalKontrol.fromMap(e)).toList();

      final labMaps = await db.query('hasil_lab');
      lab = labMaps.map((e) => HasilLab.fromMap(e)).toList();
      
      final peringatanMaps = await db.query('peringatan');
      peringatan = peringatanMaps.map((e) => Peringatan.fromMap(e)).toList();

      final edukasiMaps = await db.query('edukasi');
      edukasi = edukasiMaps.map((e) => KontenEdukasi.fromMap(e)).toList();
    */
    
    notifyListeners();
  }

  // ── Pasien ────────────────────────────────────────────────────────────────
  List<Pasien> get filteredPasien {
    return pasien.where((px) {
      if (filterPasien == 'Semua Status') return true;
      return px.status == filterPasien;
    }).toList();
  }

  Future<void> addPasien(Pasien p) async {
    final db = await DatabaseHelper.database;
    await db.insert('pasien', p.toMap());
    pasien.add(p);
    notifyListeners();
  }

  Future<void> updatePasien(Pasien p) async {
    final db = await DatabaseHelper.database;
    await db.update('pasien', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
    final idx = pasien.indexWhere((x) => x.id == p.id);
    if (idx >= 0) pasien[idx] = p;
    notifyListeners();
  }

  Future<void> deletePasien(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete('pasien', where: 'id = ?', whereArgs: [id]);
    pasien.removeWhere((px) => px.id == id);
    notifyListeners();
  }

  String nextPasienId() {
    pasienCounter++;
    return 'TBC-2024-${pasienCounter.toString().padLeft(3, '0')}';
  }

  // ── Stok ──────────────────────────────────────────────────────────────────
  Future<void> updateStok(String nama, int jumlah, String aksi) async {
    final ob = stok.firstWhere((o) => o.nama == nama);
    if (aksi == 'Set Nilai Baru') {
      ob.stok = jumlah;
    } else if (aksi == 'Tambah Stok') {
      ob.stok += jumlah;
    } else if (aksi == 'Kurangi Stok') {
      ob.stok = (ob.stok - jumlah).clamp(0, ob.maks);
    }
    
    final db = await DatabaseHelper.database;
    // Asumsi di models.dart, StokObat udah ada fungsi toMap()
    await db.update('stok_obat', ob.toMap(), where: 'id = ?', whereArgs: [ob.id]);
    notifyListeners();
  }

  // ── Jadwal ────────────────────────────────────────────────────────────────
  Future<void> addJadwal(JadwalKontrol j) async {
    final db = await DatabaseHelper.database;
    await db.insert('jadwal_kontrol', j.toMap());
    jadwal.add(j);
    notifyListeners();
  }

  Future<void> updateStatusJadwal(JadwalKontrol j, String status, String catatan) async {
    j.status = status;
    j.catatan = catatan;
    final db = await DatabaseHelper.database;
    await db.update('jadwal_kontrol', j.toMap(), where: 'id = ?', whereArgs: [j.id]);
    notifyListeners();
  }

  // ── Peringatan ────────────────────────────────────────────────────────────
  List<Peringatan> get filteredPeringatan {
    if (filterPeringatan == 'Semua') return peringatan;
    return peringatan.where((pw) => pw.level == filterPeringatan).toList();
  }

  Future<void> selesaikanPeringatan(Peringatan pw) async {
    final db = await DatabaseHelper.database;
    await db.delete('peringatan', where: 'id = ?', whereArgs: [pw.id]);
    peringatan.removeWhere((p) => p.idPasien == pw.idPasien && p.isu == pw.isu);
    notifyListeners();
  }

  // ── Lab ───────────────────────────────────────────────────────────────────
  Future<void> addLab(HasilLab hl) async {
    final db = await DatabaseHelper.database;
    await db.insert('hasil_lab', hl.toMap());
    lab.add(hl);
    notifyListeners();
  }

  // ── Edukasi ───────────────────────────────────────────────────────────────
  List<KontenEdukasi> get filteredEdukasi {
    if (filterEdukasi == 'Semua') return edukasi;
    return edukasi.where((e) => e.kategori == filterEdukasi).toList();
  }

  Future<void> addEdukasi(KontenEdukasi e) async {
    final db = await DatabaseHelper.database;
    await db.insert('edukasi', e.toMap());
    edukasi.add(e);
    notifyListeners();
  }

  Future<void> updateEdukasi(KontenEdukasi e, String judul, String kat, String dur, String isi) async {
    e.judul = judul;
    e.kategori = kat;
    e.durasi = dur;
    e.isi = isi;
    final db = await DatabaseHelper.database;
    await db.update('edukasi', e.toMap(), where: 'id = ?', whereArgs: [e.id]);
    notifyListeners();
  }

  Future<void> incrementViews(KontenEdukasi e) async {
    e.views++;
    final db = await DatabaseHelper.database;
    await db.update('edukasi', e.toMap(), where: 'id = ?', whereArgs: [e.id]);
    notifyListeners();
  }

  // ── Antrian ───────────────────────────────────────────────────────────────
  List<AntrianItem> get antrianAktif => antrian[poliAktif] ?? [];

  AntrianItem? get nowServed {
    final list = antrianAktif.where((a) => a.status == 'Dipanggil' || a.status == 'URGENT').toList();
    return list.isEmpty ? null : list.first;
  }

  Future<void> panggilBerikutnya() async {
    final data = antrian[poliAktif] ?? [];
    final db = await DatabaseHelper.database;

    for (var a in data) {
      if (a.status == 'Dipanggil' || a.status == 'URGENT') {
        a.status = 'Selesai'; 
        await db.update('antrian', {'status': 'Selesai'}, where: 'id = ?', whereArgs: [a.id]);
        break;
      }
    }
    
    final order = {'URGENT':0, 'Tinggi':1, 'Lansia':2, 'Normal':3};
    final waiting = data.where((a) => a.status == 'Menunggu').toList()
      ..sort((a,b) => (order[a.prioritas] ?? 9).compareTo(order[b.prioritas] ?? 9));
      
    if (waiting.isNotEmpty) {
      waiting.first.status = 'Dipanggil';
      await db.update('antrian', {'status': 'Dipanggil'}, where: 'id = ?', whereArgs: [waiting.first.id]);
    }
    notifyListeners();
  }

  Future<void> selesaikanAntrian() async {
    final a = nowServed;
    if (a != null) { 
      a.status = 'Selesai'; 
      final db = await DatabaseHelper.database;
      await db.update('antrian', {'status': 'Selesai'}, where: 'id = ?', whereArgs: [a.id]);
      notifyListeners(); 
    }
  }

  Future<void> tundaAntrian() async {
    final a = nowServed;
    if (a != null) { 
      a.status = 'Menunggu'; 
      a.prioritas = 'Normal'; 
      final db = await DatabaseHelper.database;
      await db.update('antrian', {'status': 'Menunggu', 'prioritas': 'Normal'}, where: 'id = ?', whereArgs: [a.id]);
      notifyListeners(); 
    }
  }

  Future<void> resetAntrian(String kode) async {
    antrian[kode] = [];
    final db = await DatabaseHelper.database;
    // Mengosongkan data antrian khusus poli terkait di database
    await db.delete('antrian', where: 'poli = ?', whereArgs: [kode]);
    notifyListeners();
  }

  Future<void> addAntrian(AntrianItem item, String kode) async {
    antrian.putIfAbsent(kode, () => []);
    antrian[kode]!.add(item);
    final db = await DatabaseHelper.database;
    await db.insert('antrian', item.toMap());
    notifyListeners();
  }

  String nextAntrianNo(String kode) {
    final prefix = {'UMUM':'A','PARU':'B','TBC':'C','LAB':'D','RAD':'E'}[kode] ?? 'X';
    final n = (antrian[kode]?.length ?? 0) + 1;
    return '$prefix-${n.toString().padLeft(3,'0')}';
  }

  // ── Computed stats ────────────────────────────────────────────────────────
  int get totalAktif => pasien.where((px) => px.status=='Dalam Terapi').length;
  int get totalSelesai => pasien.where((px) => px.status=='Selesai').length;
  int get totalPutusObat => pasien.where((px) => px.status=='Putus Obat').length;
  int get totalAntrian => antrian.values.fold(0, (s,v) => s + v.length);

  double get kepatuhanRataRata {
    if (pasien.isEmpty) return 0;
    return pasien.map((px) => px.kepatuhan).reduce((a,b) => a + b) / pasien.length;
  }
}