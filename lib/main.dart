// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/pasien_screen.dart';
import 'screens/kepatuhan_screen.dart';
import 'screens/jadwal_screen.dart';
import 'screens/antrian_screen.dart';
import 'screens/peringatan_screen.dart';
import 'screens/lab_screen.dart';
import 'screens/stok_screen.dart';
import 'screens/laporan_screen.dart';
import 'screens/edukasi_screen.dart';

void main() {
  // Pastikan Flutter binding sudah siap sebelum load database (Wajib untuk FFI Desktop)
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ChangeNotifierProvider(
      // Disini kita trigger loadSemuaData() agar narik data dari SQLite saat app jalan
      create: (_) => AppState()..loadSemuaData(),
      child: const ClinicCareApp(),
    ),
  );
}

class ClinicCareApp extends StatelessWidget {
  const ClinicCareApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'ClinicCare',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    home: const AppShell(),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// App Shell — Sidebar + Content area (NavigationRail on desktop/tablet)
// ─────────────────────────────────────────────────────────────────────────────
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const _destinations = [
    _NavDest(icon: Icons.dashboard_outlined,      activeIcon: Icons.dashboard,          label: 'Dashboard'),
    _NavDest(icon: Icons.people_outline,          activeIcon: Icons.people,             label: 'Data Pasien'),
    _NavDest(icon: Icons.medication_outlined,     activeIcon: Icons.medication,         label: 'Kepatuhan'),
    _NavDest(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month,     label: 'Jadwal Kontrol'),
    _NavDest(icon: Icons.queue_outlined,          activeIcon: Icons.queue,              label: 'Antrian Poli'),
    _NavDest(icon: Icons.warning_amber_outlined,  activeIcon: Icons.warning_amber,      label: 'Peringatan', badge: '6'),
    _NavDest(icon: Icons.science_outlined,        activeIcon: Icons.science,            label: 'Lab & Diagnostik'),
    _NavDest(icon: Icons.inventory_2_outlined,    activeIcon: Icons.inventory_2,        label: 'Stok Obat'),
    _NavDest(icon: Icons.bar_chart_outlined,      activeIcon: Icons.bar_chart,          label: 'Laporan'),
    _NavDest(icon: Icons.menu_book_outlined,      activeIcon: Icons.menu_book,          label: 'Edukasi Pasien'),
  ];

  final List<Widget> _screens = [
    const DashboardScreen(),
    const PasienScreen(),
    const KepatuhanScreen(),
    const JadwalScreen(),
    const AntrianScreen(),
    const PeringatanScreen(),
    const LabScreen(),
    const StokScreen(),
    const LaporanScreen(),
    const EdukasiScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      body: Row(
        children: [
          // ── Sidebar ────────────────────────────────────────────────────────
          Container(
            width: isWide ? 220 : 72,
            color: AppColors.sidebar,
            child: Column(
              children: [
                // Logo
                _buildLogo(isWide),
                const Divider(height: 1, color: Color(0xFF3d4a41)),
                // Nav items
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    children: [
                      if (isWide) _sectionLabel('UTAMA'),
                      ..._destinations.sublist(0, 5).asMap().entries.map(
                          (e) => _navItem(e.key, e.value, isWide)),
                      if (isWide) _sectionLabel('KLINIS'),
                      ..._destinations.sublist(5, 8).asMap().entries.map(
                          (e) => _navItem(e.key + 5, e.value, isWide)),
                      if (isWide) _sectionLabel('LAPORAN'),
                      ..._destinations.sublist(8, 10).asMap().entries.map(
                          (e) => _navItem(e.key + 8, e.value, isWide)),
                    ],
                  ),
                ),
                // User info
                _buildUserFooter(isWide),
              ],
            ),
          ),
          // ── Main content ───────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: _screens[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isWide) => Container(
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    child: Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.terracotta,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: const Text('🏥', style: TextStyle(fontSize: 18)),
        ),
        if (isWide) ...[
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('ClinicCare',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                    color: AppColors.ivory, letterSpacing: 0.5)),
            Text('Sistem Informasi Kesehatan RS',
                style: TextStyle(fontSize: 9, color: AppColors.sage)),
          ]),
        ],
      ],
    ),
  );

  Widget _sectionLabel(String label) => Padding(
    padding: EdgeInsets.fromLTRB(18, 12, 0, 2),
    child: Text(label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
            color: AppColors.sage, letterSpacing: 1)),
  );

  Widget _navItem(int index, _NavDest dest, bool isWide) {
    final isActive = _selectedIndex == index;
    return Tooltip(
      message: isWide ? '' : dest.label,
      preferBelow: false,
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.activeNav : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(children: [
            Icon(isActive ? dest.activeIcon : dest.icon,
                size: 18, color: isActive ? Colors.white : AppColors.sage),
            if (isWide) ...[
              SizedBox(width: 10),
              Expanded(child: Text(dest.label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                      color: isActive ? Colors.white : const Color(0xFFaabba4)))),
              if (dest.badge != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: AppColors.blood,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(dest.badge!,
                      style: TextStyle(fontSize: 9, color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
            ],
          ]),
        ),
      ),
    );
  }

  Widget _buildUserFooter(bool isWide) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.sidebarHover))),
    child: Row(children: [
      CircleAvatar(radius: 16, backgroundColor: AppColors.evergreen,
          child: Text('DR', style: TextStyle(fontSize: 10, color: Colors.white,
              fontWeight: FontWeight.w700))),
      if (isWide) ...[
        SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('dr. Rina Sari',
              style: TextStyle(fontSize: 11, color: AppColors.ivory,
                  fontWeight: FontWeight.w600)),
          Text('Dokter Paru — Admin',
              style: TextStyle(fontSize: 9, color: AppColors.sage)),
        ]),
      ],
    ]),
  );

  Widget _buildTopBar(BuildContext context) {
    final state  = context.watch<AppState>();
    final titles = [
      'Dashboard','Data Pasien TBC','Kepatuhan Obat','Jadwal Kontrol',
      'Antrian Poliklinik','Peringatan Dini','Lab & Diagnostik',
      'Stok Obat','Laporan Bulanan','Edukasi Pasien',
    ];
    final today = DateTime.now();
    final dayStr = ['Minggu','Senin','Selasa','Rabu','Kamis','Jumat','Sabtu'][today.weekday % 7];
    final dateStr = '$dayStr, ${today.day.toString().padLeft(2,'0')} '
        '${['','Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember'][today.month]} '
        '${today.year}';

    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(children: [
        Text(titles[_selectedIndex],
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
                color: AppColors.textDark, fontFamily: 'Georgia')),
        SizedBox(width: 12),
        Text(dateStr, style: TextStyle(fontSize: 11, color: AppColors.textLight)),
        Spacer(),
        // Alert badge
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setState(() => _selectedIndex = 5),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: const Color(0xFFf5e6e5),
                borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              Icon(Icons.warning_amber, size: 14, color: AppColors.blood),
              SizedBox(width: 4),
              Text('${state.peringatan.length} Peringatan',
                  style: TextStyle(fontSize: 11, color: AppColors.blood,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
        SizedBox(width: 8),
        // Search
        SizedBox(
          width: 180,
          child: TextField(
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: 'Cari pasien...',
              prefixIcon: Icon(Icons.search, size: 16),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              isDense: true,
            ),
          ),
        ),
      ]),
    );
  }
}

class _NavDest {
  final IconData icon;
  final IconData activeIcon;
  final String   label;
  final String?  badge;

  const _NavDest({
      required this.icon, required this.activeIcon,
      required this.label, this.badge});
}