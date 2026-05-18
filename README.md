# ClinicCare — Sistem Informasi Kesehatan & Antrian Poliklinik

Flutter app converted from TBCare (Python/CustomTkinter).
**Kelompok A7 — TIK3182_A — UNSRAT 2026**

---

## Struktur Project

```
cliniccare/
├── lib/
│   ├── main.dart                    ← Entry point + App Shell (sidebar, topbar)
│   ├── theme/
│   │   └── app_theme.dart           ← Semua warna, typography, tema Material
│   ├── models/
│   │   └── models.dart              ← Data class: Pasien, StokObat, HasilLab, dll.
│   ├── data/
│   │   ├── seed_data.dart           ← Data dummy (ganti dengan SQLite saat backend)
│   │   └── app_state.dart           ← ChangeNotifier provider — semua state & CRUD
│   ├── widgets/
│   │   └── common_widgets.dart      ← Reusable: StatCard, CCButton, CCDialog, dll.
│   └── screens/
│       ├── dashboard_screen.dart    ← Overview: stat cards, antrian, pasien prioritas
│       ├── pasien_screen.dart       ← CRUD pasien + detail dialog + hapus
│       ├── kepatuhan_screen.dart    ← Monitoring kepatuhan + kirim reminder
│       ├── jadwal_screen.dart       ← Jadwal kontrol — tambah & update status
│       ├── antrian_screen.dart      ← Antrian multi-poli + cetak + layar display
│       ├── peringatan_screen.dart   ← Peringatan dini + tindak lanjut dialog
│       ├── lab_screen.dart          ← Input hasil lab + tabel diagnostik
│       ├── stok_screen.dart         ← Stok obat + update stok dialog
│       ├── laporan_screen.dart      ← Laporan bulanan + ekspor dialog
│       └── edukasi_screen.dart      ← Grid edukasi + baca + tambah + edit
└── pubspec.yaml
```

---

## Cara Menjalankan

### 1. Prasyarat
- Flutter SDK ≥ 3.0.0 (https://flutter.dev/docs/get-started/install)
- Dart SDK ≥ 3.0.0 (sudah termasuk di Flutter)
- Android Studio / VS Code dengan extension Flutter

### 2. Install dependencies
```bash
cd cliniccare
flutter pub get
```

### 3. Jalankan aplikasi
```bash
# Desktop (Windows/macOS/Linux)
flutter run -d windows      # atau macos / linux
flutter run -d chrome       # Web (layout desktop)

# Mobile
flutter run -d android
flutter run -d ios
```

---

## Menambahkan Backend SQLite

Cari komentar `// [DB]` di seluruh project — itulah titik integrasi database.

### 1. Buat DatabaseHelper
```dart
// lib/data/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'cliniccare.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pasien (
        id TEXT PRIMARY KEY, nama TEXT, umur INTEGER, fase TEXT, hari INTEGER,
        kepatuhan INTEGER, status TEXT, dahak TEXT, kontrol TEXT, risiko TEXT,
        diagnosa TEXT, dokter TEXT, alamat TEXT, telp TEXT, no_rm TEXT
      )
    ''');
    // Tambahkan tabel lain: stok, lab, jadwal, peringatan, antrian, edukasi
  }
}
```

### 2. Ganti seed data di app_state.dart
```dart
// Contoh mengganti loadPasien():
Future<void> loadFromDB() async {
  final db = await DatabaseHelper.database;
  final rows = await db.query('pasien');
  pasien = rows.map(Pasien.fromMap).toList();
  // ... load tabel lain
  notifyListeners();
}
```

### 3. Ganti operasi CRUD
```dart
// addPasien()
final db = await DatabaseHelper.database;
await db.insert('pasien', p.toMap());

// updatePasien()
await db.update('pasien', p.toMap(), where:'id=?', whereArgs:[p.id]);

// deletePasien()
await db.delete('pasien', where:'id=?', whereArgs:[id]);
```

---

## Fitur Lengkap

| Modul              | Fitur                                                          |
|--------------------|----------------------------------------------------------------|
| Dashboard          | Stat cards, ringkasan antrian 5 poli, pasien prioritas, jadwal |
| Data Pasien        | CRUD lengkap, search, filter status, detail dialog             |
| Kepatuhan Obat     | Distribusi bar, tabel kepatuhan, dialog kirim reminder         |
| Jadwal Kontrol     | Tambah jadwal, update status kunjungan                         |
| Antrian Poliklinik | 5 poli, panggil/selesai/tunda/reset, cetak nomor, layar display|
| Peringatan Dini    | Filter level, tindak lanjut dialog, tandai selesai             |
| Lab & Diagnostik   | Input hasil lab, tabel dengan warna status                     |
| Stok Obat          | Stok bar, update stok (set/tambah/kurangi)                     |
| Laporan Bulanan    | Tabel indikator, ekspor PDF/Excel/CSV/Word                     |
| Edukasi Pasien     | Grid dengan filter kategori, baca materi, tambah/edit konten   |

---

## Justifikasi Desktop Native (Flutter Desktop)

Meskipun ini Flutter (cross-platform), justifikasi **desktop native** tetap berlaku:
- **Printer termal loket** → `printing` package akses printer lokal langsung
- **Layar display ruang tunggu** → multi-window Flutter atau socket local output
- **Mode offline** → `sqflite` / `sqflite_common_ffi` database lokal
- **Performa** → Flutter compile ke native x64, tidak butuh browser/VM
- **Keamanan data** → data pasien tidak pernah meninggalkan jaringan RS

---

*ClinicCare — Kelompok A7 | Universitas Sam Ratulangi | 2026*
