// lib/data/app_state.dart
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'seed_data.dart';

class AppState extends ChangeNotifier {
  // ── Runtime data — [DB] ganti dengan SQLite query saat backend terhubung ──
  late List<Pasien>        pasien;
  late List<StokObat>      stok;
  late List<HasilLab>      lab;
  late List<JadwalKontrol> jadwal;
  late List<Peringatan>    peringatan;
  late List<KontenEdukasi> edukasi;
  late Map<String, List<AntrianItem>> antrian;

  String poliAktif       = 'TBC';
  String filterPasien    = 'Semua Status';
  String filterPeringatan= 'Semua';
  String filterEdukasi   = 'Semua';
  int    pasienCounter   = 8;

  AppState() {
    _loadSeedData();
  }

  void _loadSeedData() {
    // [DB] Saat SQLite tersedia, ganti ini dengan:
    //   pasien    = await db.loadPasien();
    //   stok      = await db.loadStok();
    //   dll.
    pasien     = List<Pasien>.from(seedPasien);
    stok       = List<StokObat>.from(seedStok);
    lab        = List<HasilLab>.from(seedLab);
    jadwal     = List<JadwalKontrol>.from(seedJadwal);
    peringatan = List<Peringatan>.from(seedPeringatan);
    edukasi    = List<KontenEdukasi>.from(seedEdukasi);
    antrian    = {
      for (var e in seedAntrian.entries)
        e.key: List<AntrianItem>.from(e.value)
    };
  }

  // ── Pasien ────────────────────────────────────────────────────────────────
  List<Pasien> get filteredPasien {
    return pasien.where((px) {
      if (filterPasien == 'Semua Status') return true;
      return px.status == filterPasien;
    }).toList();
  }

  void addPasien(Pasien p) {
    pasien.add(p);
    // [DB] INSERT INTO pasien …
    notifyListeners();
  }

  void updatePasien(Pasien p) {
    final idx = pasien.indexWhere((x) => x.id == p.id);
    if (idx >= 0) pasien[idx] = p;
    // [DB] UPDATE pasien SET … WHERE id=p.id
    notifyListeners();
  }

  void deletePasien(String id) {
    pasien.removeWhere((px) => px.id == id);
    // [DB] DELETE FROM pasien WHERE id=id
    notifyListeners();
  }

  String nextPasienId() {
    pasienCounter++;
    return 'TBC-2024-${pasienCounter.toString().padLeft(3, '0')}';
  }

  // ── Stok ──────────────────────────────────────────────────────────────────
  void updateStok(String nama, int jumlah, String aksi) {
    final ob = stok.firstWhere((o) => o.nama == nama);
    if      (aksi == 'Set Nilai Baru') ob.stok  = jumlah;
    else if (aksi == 'Tambah Stok')    ob.stok += jumlah;
    else if (aksi == 'Kurangi Stok')   ob.stok  = (ob.stok - jumlah).clamp(0, ob.maks);
    // [DB] UPDATE stok SET stok=… WHERE nama=…
    notifyListeners();
  }

  // ── Jadwal ────────────────────────────────────────────────────────────────
  void addJadwal(JadwalKontrol j) {
    jadwal.add(j);
    // [DB] INSERT INTO jadwal …
    notifyListeners();
  }

  void updateStatusJadwal(JadwalKontrol j, String status, String catatan) {
    j.status  = status;
    j.catatan = catatan;
    // [DB] UPDATE jadwal SET status=… WHERE …
    notifyListeners();
  }

  // ── Peringatan ────────────────────────────────────────────────────────────
  List<Peringatan> get filteredPeringatan {
    if (filterPeringatan == 'Semua') return peringatan;
    return peringatan.where((pw) => pw.level == filterPeringatan).toList();
  }

  void selesaikanPeringatan(Peringatan pw) {
    peringatan.removeWhere((p) => p.idPasien == pw.idPasien && p.isu == pw.isu);
    // [DB] UPDATE peringatan SET status='selesai' WHERE …
    notifyListeners();
  }

  // ── Lab ───────────────────────────────────────────────────────────────────
  void addLab(HasilLab hl) {
    lab.add(hl);
    // [DB] INSERT INTO lab …
    notifyListeners();
  }

  // ── Edukasi ───────────────────────────────────────────────────────────────
  List<KontenEdukasi> get filteredEdukasi {
    if (filterEdukasi == 'Semua') return edukasi;
    return edukasi.where((e) => e.kategori == filterEdukasi).toList();
  }

  void addEdukasi(KontenEdukasi e) {
    edukasi.add(e);
    notifyListeners();
  }

  void updateEdukasi(KontenEdukasi e, String judul, String kat, String dur, String isi) {
    e.judul    = judul;
    e.kategori = kat;
    e.durasi   = dur;
    e.isi      = isi;
    notifyListeners();
  }

  void incrementViews(KontenEdukasi e) {
    e.views++;
    // [DB] UPDATE edukasi SET views=views+1 WHERE …
    notifyListeners();
  }

  // ── Antrian ───────────────────────────────────────────────────────────────
  List<AntrianItem> get antrianAktif => antrian[poliAktif] ?? [];

  AntrianItem? get nowServed {
    final list = antrianAktif.where((a) => a.status == 'Dipanggil' || a.status == 'URGENT').toList();
    return list.isEmpty ? null : list.first;
  }

  void panggilBerikutnya() {
    final data = antrian[poliAktif]!;
    for (var a in data) {
      if (a.status == 'Dipanggil' || a.status == 'URGENT') {
        a.status = 'Selesai'; break;
      }
    }
    final order = {'URGENT':0,'Tinggi':1,'Lansia':2,'Normal':3};
    final waiting = data.where((a) => a.status == 'Menunggu').toList()
      ..sort((a,b) => (order[a.prioritas]??9).compareTo(order[b.prioritas]??9));
    if (waiting.isNotEmpty) waiting.first.status = 'Dipanggil';
    // [DB] UPDATE antrian SET status=… WHERE …
    notifyListeners();
  }

  void selesaikanAntrian() {
    final a = nowServed;
    if (a != null) { a.status = 'Selesai'; notifyListeners(); }
  }

  void tundaAntrian() {
    final a = nowServed;
    if (a != null) { a.status = 'Menunggu'; a.prioritas = 'Normal'; notifyListeners(); }
  }

  void resetAntrian(String kode) {
    antrian[kode] = [];
    notifyListeners();
  }

  void addAntrian(AntrianItem item, String kode) {
    antrian.putIfAbsent(kode, () => []);
    antrian[kode]!.add(item);
    // [DB] INSERT INTO antrian …
    notifyListeners();
  }

  String nextAntrianNo(String kode) {
    final prefix = {'UMUM':'A','PARU':'B','TBC':'C','LAB':'D','RAD':'E'}[kode] ?? 'X';
    final n = (antrian[kode]?.length ?? 0) + 1;
    return '$prefix-${n.toString().padLeft(3,'0')}';
  }

  // ── Computed stats ────────────────────────────────────────────────────────
  int get totalAktif     => pasien.where((px) => px.status=='Dalam Terapi').length;
  int get totalSelesai   => pasien.where((px) => px.status=='Selesai').length;
  int get totalPutusObat => pasien.where((px) => px.status=='Putus Obat').length;
  int get totalAntrian   => antrian.values.fold(0, (s,v) => s+v.length);

  double get kepatuhanRataRata {
    if (pasien.isEmpty) return 0;
    return pasien.map((px) => px.kepatuhan).reduce((a,b)=>a+b) / pasien.length;
  }
}
