// lib/data/seed_data.dart
// [DB] Saat backend SQLite terhubung, ganti list ini dengan query dari database.
// Struktur data sama persis dengan tabel DB yang akan dibuat.

import '../models/models.dart';

final List<Pasien> seedPasien = [
  Pasien(id:'TBC-2024-001',nama:'Siti Aminah',   umur:42,fase:'Fase Lanjutan', hari:87, kepatuhan:61,status:'Putus Obat',  dahak:'Darah',       kontrol:'08:00',risiko:'KRITIS',diagnosa:'TBC Paru (Kambuh)',   dokter:'dr. Rina Sari',   alamat:'Jl. Piere Tendean No.12',telp:'0812-0001',noRm:'RM-001'),
  Pasien(id:'TBC-2024-002',nama:'Budi Wahyono',  umur:55,fase:'Fase Intensif',hari:34, kepatuhan:73,status:'Dalam Terapi',dahak:'Kuning-Hijau',  kontrol:'09:30',risiko:'Tinggi', diagnosa:'TBC Paru (Baru)',     dokter:'dr. Rina Sari',   alamat:'Jl. Sam Ratulangi No.45',telp:'0813-0002',noRm:'RM-002'),
  Pasien(id:'TBC-2024-003',nama:'Rahmat Hidayat',umur:31,fase:'Fase Intensif',hari:19, kepatuhan:88,status:'Dalam Terapi',dahak:'Hijau',         kontrol:'10:30',risiko:'Sedang', diagnosa:'TBC Paru (Baru)',     dokter:'dr. Budi Santoso',alamat:'Jl. Walanda Maramis No.7',telp:'0814-0003',noRm:'RM-003'),
  Pasien(id:'TBC-2024-004',nama:'Maria Nengsih', umur:28,fase:'Fase Lanjutan', hari:122,kepatuhan:95,status:'Dalam Terapi',dahak:'Bening',        kontrol:'10:30',risiko:'Rendah', diagnosa:'TBC Paru (Baru)',     dokter:'dr. Rina Sari',   alamat:'Jl. Diponegoro No.33',   telp:'0815-0004',noRm:'RM-004'),
  Pasien(id:'TBC-2024-005',nama:'Yusuf Pratama', umur:47,fase:'Kambuh',        hari:11, kepatuhan:82,status:'Dalam Terapi',dahak:'Kuning',        kontrol:'13:00',risiko:'Sedang', diagnosa:'TBC Ekstra Paru',     dokter:'dr. Budi Santoso',alamat:'Jl. Bethesda No.18',      telp:'0816-0005',noRm:'RM-005'),
  Pasien(id:'TBC-2024-006',nama:'Dewi Fitriani', umur:36,fase:'Fase Intensif',hari:57, kepatuhan:79,status:'Dalam Terapi',dahak:'Hijau',         kontrol:'15:00',risiko:'Tinggi', diagnosa:'TBC + HIV Komorbid',  dokter:'dr. Rina Sari',   alamat:'Jl. Monginsidi No.9',     telp:'0817-0006',noRm:'RM-006'),
  Pasien(id:'TBC-2024-007',nama:'Ahmad Maulana', umur:23,fase:'Fase Intensif',hari:42, kepatuhan:91,status:'Dalam Terapi',dahak:'Bening',        kontrol:'11:00',risiko:'Rendah', diagnosa:'TBC Paru (Baru)',     dokter:'dr. Budi Santoso',alamat:'Jl. Arie Lasut No.55',    telp:'0818-0007',noRm:'RM-007'),
  Pasien(id:'TBC-2024-008',nama:'Nona Rompas',   umur:61,fase:'Fase Lanjutan', hari:155,kepatuhan:98,status:'Selesai',     dahak:'Bening',        kontrol:'-',    risiko:'Rendah', diagnosa:'TBC Paru (Baru)',     dokter:'dr. Rina Sari',   alamat:'Jl. Sudirman No.22',      telp:'0819-0008',noRm:'RM-008'),
];

final List<StokObat> seedStok = [
  StokObat(nama:'Rifampisin 150mg',   stok:2400,maks:3000,sat:'tablet'),
  StokObat(nama:'Isoniazid 300mg',    stok:1860,maks:3000,sat:'tablet'),
  StokObat(nama:'Pirazinamid 500mg',  stok:980, maks:3000,sat:'tablet'),
  StokObat(nama:'Etambutol 250mg',    stok:320, maks:3000,sat:'tablet'),
  StokObat(nama:'FDC 4-in-1 (HRZE)', stok:4200,maks:4500,sat:'tablet'),
  StokObat(nama:'Streptomisin inj.',  stok:150, maks:400, sat:'vial'),
];

final List<HasilLab> seedLab = [
  HasilLab(idPasien:'TBC-2024-001',nama:'Siti Aminah',   jenis:'BTA Sputum',   hasil:'BTA +3',                    tgl:'02/04/2026',status:'Kritis'),
  HasilLab(idPasien:'TBC-2024-002',nama:'Budi Wahyono',  jenis:'TCM GeneXpert',hasil:'MTB Detected-RIF Resistant',tgl:'01/04/2026',status:'MDR'),
  HasilLab(idPasien:'TBC-2024-003',nama:'Rahmat Hidayat',jenis:'Foto Toraks',  hasil:'Infiltrat bilateral',       tgl:'31/03/2026',status:'Abnormal'),
  HasilLab(idPasien:'TBC-2024-004',nama:'Maria Nengsih', jenis:'BTA Sputum',   hasil:'BTA Negatif',               tgl:'28/03/2026',status:'Normal'),
  HasilLab(idPasien:'TBC-2024-006',nama:'Dewi Fitriani', jenis:'CD4 Count',    hasil:'185 sel/uL',                tgl:'30/03/2026',status:'Rendah'),
  HasilLab(idPasien:'TBC-2024-007',nama:'Ahmad Maulana', jenis:'TCM GeneXpert',hasil:'MTB Detected-RIF Sensitive',tgl:'29/03/2026',status:'Positif'),
];

final List<JadwalKontrol> seedJadwal = [
  JadwalKontrol(tgl:'15/04/2026',pukul:'08:00',nama:'Siti Aminah',   idPasien:'TBC-2024-001',poli:'Poli TBC', dokter:'dr. Rina Sari',   catatan:'Evaluasi hemoptisis',  status:'Terjadwal'),
  JadwalKontrol(tgl:'15/04/2026',pukul:'09:30',nama:'Budi Wahyono',  idPasien:'TBC-2024-002',poli:'Poli Paru',dokter:'dr. Rina Sari',   catatan:'Cek hasil TCM',        status:'Terjadwal'),
  JadwalKontrol(tgl:'15/04/2026',pukul:'10:30',nama:'Rahmat Hidayat',idPasien:'TBC-2024-003',poli:'Poli TBC', dokter:'dr. Budi Santoso',catatan:'Kontrol rutin',        status:'Terjadwal'),
  JadwalKontrol(tgl:'16/04/2026',pukul:'10:00',nama:'Maria Nengsih', idPasien:'TBC-2024-004',poli:'Poli TBC', dokter:'dr. Rina Sari',   catatan:'Kontrol bulan ke-4',   status:'Terjadwal'),
  JadwalKontrol(tgl:'16/04/2026',pukul:'13:00',nama:'Yusuf Pratama', idPasien:'TBC-2024-005',poli:'Poli TBC', dokter:'dr. Budi Santoso',catatan:'Evaluasi terapi',      status:'Terjadwal'),
  JadwalKontrol(tgl:'17/04/2026',pukul:'09:00',nama:'Dewi Fitriani', idPasien:'TBC-2024-006',poli:'Poli Paru',dokter:'dr. Rina Sari',   catatan:'Evaluasi ARV+OAT',     status:'Tidak Hadir'),
  JadwalKontrol(tgl:'17/04/2026',pukul:'11:00',nama:'Ahmad Maulana', idPasien:'TBC-2024-007',poli:'Poli TBC', dokter:'dr. Budi Santoso',catatan:'Kontrol rutin',        status:'Terjadwal'),
];

final List<Peringatan> seedPeringatan = [
  Peringatan(nama:'Siti Aminah',   idPasien:'TBC-2024-001',isu:'Putus obat 3 hari + hemoptisis',      level:'KRITIS',aksi:'Hubungi Pasien'),
  Peringatan(nama:'Budi Wahyono',  idPasien:'TBC-2024-002',isu:'Resistensi Rifampisin terdeteksi',    level:'Tinggi',aksi:'Jadwalkan Kontrol'),
  Peringatan(nama:'Yusuf Pratama', idPasien:'TBC-2024-005',isu:'TCM belum selesai 4 hari',            level:'Sedang',aksi:'Follow-up Lab'),
  Peringatan(nama:'Dewi Fitriani', idPasien:'TBC-2024-006',isu:'CD4 rendah, risiko infeksi oportunis',level:'Tinggi',aksi:'Konsultasi Dokter'),
  Peringatan(nama:'Rahmat Hidayat',idPasien:'TBC-2024-003',isu:'Kepatuhan turun minggu ini',          level:'Sedang',aksi:'Kirim Reminder'),
  Peringatan(nama:'Ahmad Maulana', idPasien:'TBC-2024-007',isu:'Jadwal kontrol terlewat',             level:'Rendah',aksi:'Jadwalkan Kontrol'),
];

final List<KontenEdukasi> seedEdukasi = [
  KontenEdukasi(judul:'Apa itu Tuberkulosis?',                          kategori:'Pengenalan TBC',durasi:'5 mnt',views:234,isi:'Tuberkulosis (TBC) adalah penyakit infeksi menular yang disebabkan oleh bakteri Mycobacterium tuberculosis. Penyakit ini menyerang paru-paru dan organ lain. Penularan terjadi melalui udara ketika penderita batuk atau bersin.'),
  KontenEdukasi(judul:'Panduan Minum Obat TBC Tidak Boleh Terputus',    kategori:'Pengobatan',    durasi:'8 mnt',views:189,isi:'Pengobatan TBC harus dijalani minimal 6 bulan tanpa putus. Berhenti di tengah jalan menyebabkan kekambuhan dan resistensi obat. Minum obat setiap hari di waktu yang sama untuk membangun kebiasaan.'),
  KontenEdukasi(judul:'Cara Mencegah Penularan TBC di Rumah',           kategori:'Pencegahan',    durasi:'6 mnt',views:142,isi:'Gunakan masker saat batuk atau bersin. Ventilasi rumah harus baik dan sinar matahari masuk. Pisahkan peralatan makan. Anggota keluarga serumah perlu skrining TBC secara rutin.'),
  KontenEdukasi(judul:'Pola Makan Sehat Mendukung Kesembuhan TBC',      kategori:'Nutrisi',       durasi:'7 mnt',views:97, isi:'Konsumsi protein tinggi seperti ikan, telur, dan kacang-kacangan. Sayur dan buah kaya vitamin C membantu sistem imun. Hindari alkohol selama pengobatan.'),
  KontenEdukasi(judul:'Efek Samping Obat TBC dan Cara Mengatasinya',    kategori:'Pengobatan',    durasi:'9 mnt',views:215,isi:'Efek samping umum: mual, urine berwarna oranye (Rifampisin), kesemutan. Segera lapor ke dokter jika kulit kuning atau gangguan penglihatan.'),
  KontenEdukasi(judul:'Tips Membangun Kebiasaan Minum Obat Setiap Hari',kategori:'Kepatuhan',     durasi:'4 mnt',views:178,isi:'Gunakan alarm HP sebagai pengingat. Letakkan obat di tempat yang mudah terlihat. Minta anggota keluarga mengingatkan. Tandai kalender setiap kali minum obat.'),
];

final List<PoliInfo> poliList = [
  PoliInfo(kode:'UMUM',nama:'Poli Umum',   warna:0xFF5b8dd9,ikon:'🏥',dokter:'dr. Samuel Wenas'),
  PoliInfo(kode:'PARU',nama:'Poli Paru',   warna:0xFF3d4a41,ikon:'🫁',dokter:'dr. Rina Sari'),
  PoliInfo(kode:'TBC', nama:'Poli TBC',    warna:0xFFB57B66,ikon:'💊',dokter:'dr. Budi Santoso'),
  PoliInfo(kode:'LAB', nama:'Laboratorium',warna:0xFF7A9B52,ikon:'🧪',dokter:'Analis Kesehatan'),
  PoliInfo(kode:'RAD', nama:'Radiologi',   warna:0xFF9b5b8d,ikon:'📡',dokter:'dr. Yolanda Karwur'),
];

final Map<String, List<AntrianItem>> seedAntrian = {
  'UMUM': [
    AntrianItem(no:'A-001',nama:'Hendro Saputra',umur:35,keperluan:'Kontrol tekanan darah',tglDaftar:'08:22',status:'Dipanggil',prioritas:'Normal',estimasi:'09:00'),
    AntrianItem(no:'A-002',nama:'Lina Mokoagow', umur:29,keperluan:'Demam 3 hari',         tglDaftar:'08:45',status:'Menunggu', prioritas:'Normal',estimasi:'09:30'),
    AntrianItem(no:'A-003',nama:'Ruben Tilaar',  umur:67,keperluan:'Sakit kepala kronis',  tglDaftar:'09:00',status:'Menunggu', prioritas:'Lansia',estimasi:'09:45'),
    AntrianItem(no:'A-004',nama:'Yanti Mandagi', umur:23,keperluan:'Konsultasi gizi',      tglDaftar:'09:10',status:'Menunggu', prioritas:'Normal',estimasi:'10:00'),
  ],
  'PARU': [
    AntrianItem(no:'B-001',nama:'Budi Wahyono',umur:55,keperluan:'Sesak nafas/evaluasi',tglDaftar:'08:00',status:'Dipanggil',prioritas:'Tinggi',estimasi:'09:30'),
    AntrianItem(no:'B-002',nama:'Grace Tumewu',umur:48,keperluan:'Batuk kronis',        tglDaftar:'08:30',status:'Menunggu', prioritas:'Normal',estimasi:'10:00'),
    AntrianItem(no:'B-003',nama:'Jefri Pondaag',umur:61,keperluan:'Kontrol asma',      tglDaftar:'08:55',status:'Menunggu', prioritas:'Normal',estimasi:'10:30'),
  ],
  'TBC': [
    AntrianItem(no:'C-001',nama:'Siti Aminah',  umur:42,keperluan:'Evaluasi hemoptisis',  tglDaftar:'08:00',status:'URGENT',   prioritas:'URGENT',estimasi:'08:00'),
    AntrianItem(no:'C-002',nama:'Budi Wahyono', umur:55,keperluan:'Ambil hasil TCM',      tglDaftar:'09:00',status:'Menunggu', prioritas:'Tinggi',estimasi:'09:30'),
    AntrianItem(no:'C-003',nama:'Maria Nengsih',umur:28,keperluan:'Kontrol bulan ke-4',   tglDaftar:'10:00',status:'Menunggu', prioritas:'Normal',estimasi:'10:30'),
    AntrianItem(no:'C-004',nama:'Yusuf Pratama',umur:47,keperluan:'Konsultasi awal terapi',tglDaftar:'12:30',status:'Menunggu',prioritas:'Normal',estimasi:'13:00'),
    AntrianItem(no:'C-005',nama:'Dewi Fitriani',umur:36,keperluan:'Evaluasi ARV + OAT',   tglDaftar:'14:30',status:'Menunggu', prioritas:'Tinggi',estimasi:'15:00'),
  ],
  'LAB': [
    AntrianItem(no:'D-001',nama:'Ahmad Maulana', umur:23,keperluan:'TCM GeneXpert',  tglDaftar:'08:00',status:'Dipanggil',prioritas:'Normal',estimasi:'08:30'),
    AntrianItem(no:'D-002',nama:'Nona Rompas',   umur:61,keperluan:'Cek darah rutin',tglDaftar:'08:40',status:'Menunggu', prioritas:'Lansia',estimasi:'09:00'),
    AntrianItem(no:'D-003',nama:'Dewi Fitriani', umur:36,keperluan:'CD4 Count',      tglDaftar:'09:00',status:'Menunggu', prioritas:'Tinggi',estimasi:'09:30'),
  ],
  'RAD': [
    AntrianItem(no:'E-001',nama:'Budi Wahyono',  umur:55,keperluan:'Foto Toraks PA',tglDaftar:'09:00',status:'Dipanggil',prioritas:'Normal',estimasi:'09:30'),
    AntrianItem(no:'E-002',nama:'Rahmat Hidayat',umur:31,keperluan:'CT Scan Thorax', tglDaftar:'09:30',status:'Menunggu', prioritas:'Normal',estimasi:'10:00'),
  ],
};
