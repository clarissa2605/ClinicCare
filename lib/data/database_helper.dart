// lib/data/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io' show Platform;

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    // Wajib untuk Flutter Desktop (Windows/macOS/Linux)
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final path = join(await getDatabasesPath(), 'cliniccare.db');
    return openDatabase(
      path, 
      version: 1, 
      onCreate: _onCreate
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // 1. Tabel Pasien
    await db.execute('''
      CREATE TABLE pasien (
        id TEXT PRIMARY KEY, nama TEXT, umur INTEGER, fase TEXT, hari INTEGER,
        kepatuhan INTEGER, status TEXT, dahak TEXT, kontrol TEXT, risiko TEXT,
        diagnosa TEXT, dokter TEXT, alamat TEXT, telp TEXT, no_rm TEXT
      )
    ''');

    // 2. Tabel Stok Obat
    await db.execute('''
      CREATE TABLE stok_obat (
        id TEXT PRIMARY KEY, nama TEXT, stok INTEGER, maks INTEGER, sat TEXT
      )
    ''');

    // 3. Tabel Hasil Lab
    await db.execute('''
      CREATE TABLE hasil_lab (
        id TEXT PRIMARY KEY, idPasien TEXT, nama TEXT, jenis TEXT, hasil TEXT, 
        tgl TEXT, status TEXT
      )
    ''');

    // 4. Tabel Jadwal Kontrol
    await db.execute('''
      CREATE TABLE jadwal_kontrol (
        id TEXT PRIMARY KEY, tgl TEXT, pukul TEXT, nama TEXT, idPasien TEXT, 
        poli TEXT, dokter TEXT, catatan TEXT, status TEXT
      )
    ''');

    // 5. Tabel Peringatan
    await db.execute('''
      CREATE TABLE peringatan (
        id TEXT PRIMARY KEY, nama TEXT, idPasien TEXT, isu TEXT, level TEXT, aksi TEXT
      )
    ''');

    // 6. Tabel Edukasi
    await db.execute('''
      CREATE TABLE edukasi (
        id TEXT PRIMARY KEY, judul TEXT, kategori TEXT, durasi TEXT, 
        views INTEGER, isi TEXT
      )
    ''');

    // 7. Tabel Antrian
    await db.execute('''
      CREATE TABLE antrian (
        id TEXT PRIMARY KEY, no TEXT, nama TEXT, umur INTEGER, keperluan TEXT, 
        tglDaftar TEXT, status TEXT, prioritas TEXT, estimasi TEXT, poli TEXT
      )
    ''');
  }
}