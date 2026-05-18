// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_state.dart';
import '../data/seed_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Greeting
        Text('Selamat Pagi, dr. Rina Sari 👋',
            style: GoogleFonts.playfairDisplay(fontSize: 20,
                fontWeight: FontWeight.w800, color: AppColors.textDark)),
        SizedBox(height: 4),
        Text('Ringkasan kondisi layanan TBC & antrian poliklinik hari ini.',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMid)),
        SizedBox(height: 20),

        // Stat Cards
        Row(children: [
          Expanded(child: StatCard(
              label:'Pasien TBC Aktif', value:'${state.totalAktif}',
              sub:'Dalam terapi DOTS', trend:'+ 12 bulan ini',
              color:AppColors.evergreen)),
          SizedBox(width:10),
          Expanded(child: StatCard(
              label:'Kepatuhan Rata-rata',
              value:'${state.kepatuhanRataRata.toStringAsFixed(0)}%',
              sub:'Minum obat 30 hari', trend:'+ 4% vs bulan lalu',
              color:AppColors.terracotta)),
          SizedBox(width:10),
          Expanded(child: StatCard(
              label:'Antrian Hari Ini', value:'${state.totalAntrian}',
              sub:'Dari 5 poliklinik', trend:'Terkini jam ini',
              color:AppColors.antrian)),
          SizedBox(width:10),
          Expanded(child: StatCard(
              label:'Selesai Pengobatan', value:'${state.totalSelesai}',
              sub:'Bulan April 2026', trend:'+ Target tercapai',
              color:AppColors.green)),
        ]),
        SizedBox(height:20),

        // Antrian per Poli
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
              SectionHeader(title:'Status Antrian Poliklinik — Saat Ini'),
              SizedBox(height:12),
              Row(
                children: poliList.map((poli) {
                  final data   = state.antrian[poli.kode] ?? [];
                  final tunggu = data.where((a) => a.status=='Menunggu').length;
                  final dipang = data.where((a) => a.status=='Dipanggil'||a.status=='URGENT').length;
                  final nowList = data.where((a) => a.status=='Dipanggil'||a.status=='URGENT').toList();
                  final nowNo  = nowList.isNotEmpty ? nowList.first.no : '-';
                  final clr    = Color(poli.warna);

                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal:4),
                      decoration: BoxDecoration(
                        color: AppColors.ivory,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color:clr, width:2),
                      ),
                      child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
                        Container(height:3,
                            decoration:BoxDecoration(color:clr,
                                borderRadius:BorderRadius.vertical(top:Radius.circular(8)))),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
                            Text('${poli.ikon} ${poli.nama}',
                                style:GoogleFonts.inter(fontSize:10,color:clr,
                                    fontWeight:FontWeight.w700)),
                            SizedBox(height:4),
                            Text(nowNo,
                                style:GoogleFonts.inter(fontSize:20,
                                    fontWeight:FontWeight.w800,color:AppColors.textDark)),
                            Text('Dipanggil: $dipang  |  Tunggu: $tunggu',
                                style:GoogleFonts.inter(fontSize:9,color:AppColors.textLight)),
                          ]),
                        ),
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ]),
          ),
        ),
        SizedBox(height:16),

        // Two columns
        Row(crossAxisAlignment:CrossAxisAlignment.start, children:[
          // Patient priority list
          Expanded(flex:6, child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
                SectionHeader(title:'Pasien TBC — Butuh Perhatian',
                    action:'Lihat semua →'),
                SizedBox(height:8),
                ...(() {
                  final sorted = [...state.pasien]..sort((a,b) {
                    const o = {'KRITIS':0,'Tinggi':1,'Sedang':2,'Rendah':3};
                    return (o[a.risiko]??9).compareTo(o[b.risiko]??9);
                  });
                  return sorted.take(6).map((px) {
                    final clr = AppColors.riskColor(px.risiko);
                    final blt = AppColors.riskLightColor(px.risiko);
                    return Column(children:[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical:6),
                        child: Row(children:[
                          Container(width:3,height:40,color:clr,
                              margin:EdgeInsets.only(right:10)),
                          AvatarInitials(name:px.nama,bgColor:blt,textColor:clr),
                          SizedBox(width:10),
                          Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                            Text('${px.nama}, ${px.umur} th',
                                style:GoogleFonts.inter(fontSize:12,
                                    fontWeight:FontWeight.w700,color:AppColors.textDark)),
                            Text('${px.fase}  ·  Hari ke-${px.hari}  ·  ${px.diagnosa}',
                                style:GoogleFonts.inter(fontSize:10,color:AppColors.textLight)),
                          ])),
                          RiskBadge(px.risiko),
                        ]),
                      ),
                      Divider(height:1,color:AppColors.border),
                    ]);
                  }).toList();
                })(),
              ]),
            ),
          )),
          SizedBox(width:12),

          // Right column
          Expanded(flex:4, child:Column(children:[
            // Dahak indicator card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
                  Text('Indikator Warna Dahak',
                      style:GoogleFonts.inter(fontSize:13,fontWeight:FontWeight.w700,
                          color:AppColors.textDark)),
                  SizedBox(height:8),
                  Divider(color:AppColors.border),
                  ...[
                    (_clrBox(0xFFF0F0EC), 'Bening/Putih', 'Batuk biasa',       'Monitor',  AppColors.sage),
                    (_clrBox(0xFFC9B84C), 'Kuning',       'Infeksi bakteri',   'Waspada',  AppColors.yellow),
                    (_clrBox(0xFF7A9B52), 'Hijau-Kuning', 'Indikasi kuat TBC', 'Prioritas',AppColors.green),
                    (_clrBox(0xFF4d7a2a), 'Hijau Gelap',  'Infeksi parah',     'Segera',   AppColors.evergreen),
                    (_clrBox(0xFFA63228), 'Bercampur Darah','Hemoptisis',      'KRITIS',   AppColors.blood),
                  ].map((d) => Padding(
                    padding: EdgeInsets.symmetric(vertical:5),
                    child: Row(children:[
                      d.$1, SizedBox(width:8),
                      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                        Text(d.$2,style:GoogleFonts.inter(fontSize:11,
                            fontWeight:FontWeight.w700,color:AppColors.textDark)),
                        Text(d.$3,style:GoogleFonts.inter(fontSize:9,color:AppColors.textLight)),
                      ])),
                      Container(
                        padding:EdgeInsets.symmetric(horizontal:8,vertical:3),
                        decoration:BoxDecoration(color:d.$5,borderRadius:BorderRadius.circular(6)),
                        child:Text(d.$4,style:GoogleFonts.inter(fontSize:9,color:Colors.white,
                            fontWeight:FontWeight.w700)),
                      ),
                    ]),
                  )).toList(),
                ]),
              ),
            ),
            SizedBox(height:12),

            // Today's schedule card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
                  Text('Jadwal Kontrol Hari Ini',
                      style:GoogleFonts.inter(fontSize:13,fontWeight:FontWeight.w700,
                          color:AppColors.textDark)),
                  SizedBox(height:8),
                  Divider(color:AppColors.border),
                  ...state.jadwal.take(6).map((j) => Padding(
                    padding: EdgeInsets.symmetric(vertical:5),
                    child: Row(children:[
                      SizedBox(width:42,
                          child:Text(j.pukul,style:GoogleFonts.inter(fontSize:10,
                              color:AppColors.textLight))),
                      Container(width:7,height:7,decoration:BoxDecoration(
                          color:j.status=='Terjadwal'?AppColors.green:AppColors.blood,
                          shape:BoxShape.circle)),
                      SizedBox(width:8),
                      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                        Text(j.nama,style:GoogleFonts.inter(fontSize:11,
                            fontWeight:FontWeight.w700,color:AppColors.textDark)),
                        Text(j.poli,style:GoogleFonts.inter(fontSize:9,
                            color:AppColors.textLight)),
                      ])),
                    ]),
                  )).toList(),
                ]),
              ),
            ),
          ])),
        ]),
        SizedBox(height:16),

        // Kepatuhan trend bar
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
              Text('Tren Kepatuhan — 6 Bulan Terakhir',
                  style:GoogleFonts.inter(fontSize:13,fontWeight:FontWeight.w700,
                      color:AppColors.textDark)),
              SizedBox(height:8),
              Divider(color:AppColors.border),
              SizedBox(height:8),
              ...[
                ('TBC Paru Baru', 0.91, AppColors.green),
                ('TBC Kambuh',    0.73, AppColors.terracotta),
                ('MDR-TBC',       0.68, AppColors.blood),
              ].map((d) => Padding(
                padding: EdgeInsets.only(bottom:12),
                child: Row(children:[
                  SizedBox(width:130,
                      child:Text(d.$1,style:GoogleFonts.inter(fontSize:11,
                          color:AppColors.textMid))),
                  Expanded(child:ProgressBar(value:d.$2,color:d.$3)),
                  SizedBox(width:8),
                  SizedBox(width:40,
                      child:Text('${(d.$2*100).toStringAsFixed(0)}%',
                          style:GoogleFonts.inter(fontSize:11,
                              fontWeight:FontWeight.w700,color:d.$3),
                          textAlign:TextAlign.right)),
                ]),
              )).toList(),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _clrBox(int hex) => Container(
    width:18, height:18,
    decoration: BoxDecoration(
        color:Color(hex),
        borderRadius:BorderRadius.circular(3),
        border:Border.all(color:AppColors.border)));
}
