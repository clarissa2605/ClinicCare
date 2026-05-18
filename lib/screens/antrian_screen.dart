// lib/screens/antrian_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_state.dart';
import '../data/seed_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class AntrianScreen extends StatelessWidget {
  const AntrianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final poli  = poliList.firstWhere((p) => p.kode == state.poliAktif);
    final clr   = Color(poli.warna);

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        // Header
        Row(children:[
          Text('Sistem Antrian Poliklinik',style:GoogleFonts.inter(
              fontSize:15,fontWeight:FontWeight.w800,color:AppColors.textDark)),
          Spacer(),
          CCButton(label:'🖨  Cetak Nomor',color:AppColors.evergreen,
              onPressed:()=>_showCetakDialog(context)),
          SizedBox(width:8),
          CCButton(label:'📺  Layar Display',color:AppColors.antrian,
              onPressed:()=>_showDisplayDialog(context)),
          SizedBox(width:8),
          CCButton(label:'Daftarkan Pasien',icon:Icons.add,
              onPressed:()=>_showTambahDialog(context)),
        ]),
        SizedBox(height:8),
        InfoBanner(
            text:'💻  Modul ini memerlukan aplikasi desktop native: akses printer termal loket, '
                 'kontrol layar display ruang tunggu, dan operasional real-time tanpa internet.',
            bgColor:Color(0xFFe8f4ec), textColor:AppColors.darkGreen),
        SizedBox(height:16),

        // Poli tabs
        SingleChildScrollView(
          scrollDirection:Axis.horizontal,
          child:Row(children:poliList.map((p){
            final isAct = p.kode == state.poliAktif;
            final tunggu = (state.antrian[p.kode]??[])
                .where((a)=>a.status=='Menunggu').length;
            return Padding(
              padding:EdgeInsets.only(right:8),
              child:InkWell(
                borderRadius:BorderRadius.circular(8),
                onTap:(){ state.poliAktif = p.kode; state.notifyListeners(); },
                child:Container(
                  padding:EdgeInsets.symmetric(horizontal:14,vertical:10),
                  decoration:BoxDecoration(
                    color: isAct ? Color(p.warna) : AppColors.card,
                    borderRadius:BorderRadius.circular(8),
                    border:Border.all(color:Color(p.warna), width:2),
                  ),
                  child:Text('${p.ikon} ${p.nama}  ($tunggu)',
                      style:GoogleFonts.inter(fontSize:12,fontWeight:FontWeight.w600,
                          color:isAct?Colors.white:AppColors.textDark)),
                ),
              ),
            );
          }).toList()),
        ),
        SizedBox(height:16),

        // Now serving panel
        Container(
          width:double.infinity,
          padding:EdgeInsets.all(20),
          decoration:BoxDecoration(color:clr,borderRadius:BorderRadius.circular(14)),
          child:() {
            final now = state.nowServed;
            if(now != null){
              return Column(children:[
                Text('Sedang Dilayani — ${poli.nama}',
                    style:GoogleFonts.inter(fontSize:12,color:Colors.white70)),
                SizedBox(height:4),
                Text(now.no,style:GoogleFonts.inter(fontSize:48,
                    fontWeight:FontWeight.w900,color:Colors.white)),
                Text('${now.nama}  |  ${now.keperluan}  |  Est. ${now.estimasi}'
                     '${now.status=="URGENT"?"  🚨 URGENT":""}',
                    style:GoogleFonts.inter(fontSize:13,color:Colors.white70)),
              ]);
            } else {
              return Column(children:[
                Text('— ${poli.nama} —',style:GoogleFonts.inter(
                    fontSize:12,color:Colors.white70)),
                SizedBox(height:4),
                Text('Tidak ada pasien aktif',style:GoogleFonts.inter(
                    fontSize:20,fontWeight:FontWeight.w700,color:Colors.white)),
              ]);
            }
          }(),
        ),
        SizedBox(height:12),

        // Action buttons
        Row(children:[
          for(var (lbl,clr2,fn) in [
            ('▶  Panggil Berikutnya', clr,            ()=>_panggilBerikutnya(context)),
            ('✔  Selesai & Tutup',   AppColors.green, ()=>state.selesaikanAntrian()),
            ('⏸  Tunda',            AppColors.yellow, ()=>state.tundaAntrian()),
            ('🔄  Reset',            AppColors.blood,  ()=>_confirmReset(context)),
          ]) ...[
            Expanded(child:ElevatedButton(
              style:ElevatedButton.styleFrom(backgroundColor:clr2,elevation:0,
                  shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(8))),
              onPressed:fn,
              child:Text(lbl,style:GoogleFonts.inter(fontSize:11,
                  fontWeight:FontWeight.w600,color:Colors.white)),
            )),
            SizedBox(width:8),
          ],
        ]),
        SizedBox(height:16),

        // Stats
        Row(children: (){
          final data = state.antrianAktif;
          return [
            ('Total Antrian',    '${data.length}',                                       clr),
            ('Sudah Dilayani',   '${data.where((a)=>a.status=="Selesai").length}',        AppColors.green),
            ('Menunggu',         '${data.where((a)=>a.status=="Menunggu").length}',       AppColors.yellow),
            ('Prioritas/Urgent', '${data.where((a)=>a.status=="URGENT").length}',         AppColors.blood),
          ].expand((d)=>[
            Expanded(child:Card(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Container(height:3,decoration:BoxDecoration(color:d.$3,
                  borderRadius:BorderRadius.vertical(top:Radius.circular(12)))),
              Padding(padding:EdgeInsets.fromLTRB(12,8,12,10),child:Column(
                crossAxisAlignment:CrossAxisAlignment.start, children:[
                  Text(d.$1.toUpperCase(),style:GoogleFonts.inter(fontSize:9,
                      color:AppColors.textLight,fontWeight:FontWeight.w600)),
                  Text(d.$2,style:GoogleFonts.inter(fontSize:22,fontWeight:FontWeight.w800,
                      color:AppColors.textDark)),
                ])),
            ]))),
            SizedBox(width:10),
          ]).toList();
        }()),
        SizedBox(height:16),

        // Queue table
        Text('Daftar Antrian — ${poli.nama}',style:GoogleFonts.inter(
            fontSize:13,fontWeight:FontWeight.w700,color:AppColors.textDark)),
        SizedBox(height:8),
        Card(child:Column(children:[
          _tableHeader(),
          ...state.antrianAktif.asMap().entries.map((e)=>_tableRow(e.value,e.key)),
        ])),
        SizedBox(height:16),

        // Desktop-only features panel
        Card(child:Padding(padding:EdgeInsets.all(16),child:Column(
          crossAxisAlignment:CrossAxisAlignment.start, children:[
            Text('ℹ️  Fitur Eksklusif Desktop Native',style:GoogleFonts.inter(
                fontSize:12,fontWeight:FontWeight.w700,color:AppColors.darkGreen)),
            SizedBox(height:8),Divider(color:AppColors.border),SizedBox(height:8),
            GridView.count(shrinkWrap:true,physics:NeverScrollableScrollPhysics(),
              crossAxisCount:2,childAspectRatio:4,mainAxisSpacing:8,crossAxisSpacing:8,
              children:[
                for(var (ico,desc) in [
                  ('🖨  Cetak Nomor Antrian','Kirim langsung ke printer termal fisik di loket RS'),
                  ('📺  Layar Display Antrian','Pancarkan nomor ke monitor TV ruang tunggu via output video lokal'),
                  ('🔔  Bunyi Notifikasi','Keluarkan suara panggilan dari speaker komputer loket'),
                  ('📶  Mode Offline Penuh','Antrian tetap berjalan walau internet putus — SQLite lokal'),
                ])
                  Container(
                    padding:EdgeInsets.symmetric(horizontal:12,vertical:8),
                    decoration:BoxDecoration(color:AppColors.ivory,
                        borderRadius:BorderRadius.circular(8)),
                    child:Row(children:[
                      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                        Text(ico,style:GoogleFonts.inter(fontSize:11,
                            fontWeight:FontWeight.w700,color:AppColors.darkGreen)),
                        Text(desc,style:GoogleFonts.inter(fontSize:10,
                            color:AppColors.textMid)),
                      ])),
                    ]),
                  ),
              ],
            ),
          ],
        ))),
      ]),
    );
  }

  Widget _tableHeader() => Container(
    padding:EdgeInsets.symmetric(horizontal:12,vertical:10),
    decoration:BoxDecoration(color:AppColors.ivory,
        borderRadius:BorderRadius.vertical(top:Radius.circular(12))),
    child:Row(children:[
      for(var (h,w) in [('No.',80),('Nama',150),('Usia',50),('Daftar',70),
                         ('Keperluan',200),('Prioritas',90),('Est.',80),('Status',110)])
        SizedBox(width:w.toDouble(),child:Text(h,style:GoogleFonts.inter(
            fontSize:10,fontWeight:FontWeight.w700,color:AppColors.textMid))),
    ]),
  );

  Widget _tableRow(AntrianItem a, int idx) {
    final clr = a.status=='URGENT'    ? AppColors.blood
               :a.status=='Dipanggil' ? AppColors.antrian
               :a.status=='Selesai'   ? AppColors.green
               : AppColors.textDark;
    return Column(children:[
      Divider(height:1,color:AppColors.border),
      Padding(padding:EdgeInsets.symmetric(horizontal:12,vertical:10),
        child:Row(children:[
          SizedBox(width:80,child:Text(a.no,style:GoogleFonts.inter(
              fontSize:11,fontWeight:FontWeight.w700,color:clr))),
          SizedBox(width:150,child:Text(a.nama,style:GoogleFonts.inter(
              fontSize:11,fontWeight:FontWeight.w600,color:AppColors.textDark),
              overflow:TextOverflow.ellipsis)),
          SizedBox(width:50,child:Text('${a.umur} th',style:GoogleFonts.inter(
              fontSize:10,color:AppColors.textMid))),
          SizedBox(width:70,child:Text(a.tglDaftar,style:GoogleFonts.inter(
              fontSize:10,color:AppColors.textLight))),
          SizedBox(width:200,child:Text(a.keperluan,style:GoogleFonts.inter(
              fontSize:10,color:AppColors.textMid),overflow:TextOverflow.ellipsis)),
          SizedBox(width:90,child:StatusBadge(a.prioritas,
              color:a.prioritas=='URGENT'?AppColors.blood:
                    a.prioritas=='Tinggi'?AppColors.terracotta:
                    a.prioritas=='Lansia'?AppColors.yellow:AppColors.evergreen)),
          SizedBox(width:80,child:Text(a.estimasi,style:GoogleFonts.inter(
              fontSize:10,color:AppColors.textLight))),
          SizedBox(width:110,child:StatusBadge(a.status,color:clr)),
        ]),
      ),
    ]);
  }

  void _panggilBerikutnya(BuildContext context) {
    final state = context.read<AppState>();
    final before = state.nowServed;
    state.panggilBerikutnya();
    final after = state.nowServed;
    if(after != null && after != before){
      showDialog(context:context, builder:(_)=>AlertDialog(
        title:Text('📢 Antrian Dipanggil'),
        content:Column(mainAxisSize:MainAxisSize.min,
          crossAxisAlignment:CrossAxisAlignment.start, children:[
          Text('Nomor  : ${after.no}',style:GoogleFonts.inter(fontSize:14,
              fontWeight:FontWeight.w800,color:AppColors.darkGreen)),
          Text('Nama   : ${after.nama}'),
          Text('Keperluan: ${after.keperluan}'),
        ]),
        actions:[
          ElevatedButton(onPressed:()=>Navigator.pop(context),
              child:Text('OK')),
        ],
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:Text('Tidak ada pasien yang menunggu'),
          backgroundColor:AppColors.yellow));
    }
  }

  void _confirmReset(BuildContext context) {
    final state = context.read<AppState>();
    showDialog(context:context, builder:(_)=>AlertDialog(
      title:Text('Reset Antrian?'),
      content:Text('Semua data antrian ${state.poliAktif} hari ini akan dihapus.'),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context),child:Text('Batal')),
        ElevatedButton(
          style:ElevatedButton.styleFrom(backgroundColor:AppColors.blood),
          onPressed:(){
            state.resetAntrian(state.poliAktif);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:Text('Antrian direset'),backgroundColor:AppColors.blood));
          },
          child:Text('Reset'),
        ),
      ],
    ));
  }

  void _showTambahDialog(BuildContext context) {
    final state = context.read<AppState>();
    final cNama = TextEditingController();
    final cUmur = TextEditingController();
    final cKepl = TextEditingController();
    final cEst  = TextEditingController(text:'-');
    String vKode = state.poliAktif;
    String vPrio = 'Normal';

    showDialog(context:context, builder:(ctx)=>StatefulBuilder(
      builder:(ctx,setSt)=>CCDialog(
        title:'Daftarkan Antrian Baru',
        content:Column(mainAxisSize:MainAxisSize.min, children:[
          LabeledField(label:'Nama / ID Pasien *', controller:cNama),
          LabeledField(label:'Usia', controller:cUmur, keyboardType:TextInputType.number),
          LabeledField(label:'Keperluan *', controller:cKepl),
          LabeledDropdown(label:'Poliklinik', value:vKode,
              items:poliList.map((p)=>p.kode).toList(),
              onChanged:(v)=>setSt(()=>vKode=v!)),
          LabeledDropdown(label:'Prioritas', value:vPrio,
              items:['Normal','Lansia','Tinggi','URGENT'],
              onChanged:(v)=>setSt(()=>vPrio=v!)),
          LabeledField(label:'Estimasi Pukul', controller:cEst),
          InfoBanner(text:'💡 Nomor antrian dapat langsung dicetak ke printer termal loket.',
              bgColor:Color(0xFFe8f4ec), textColor:AppColors.darkGreen,
              icon:Icons.print_outlined),
        ]),
        actions:[
          CCButton(label:'Batal',outline:true,color:AppColors.sage,
              textColor:AppColors.sage,onPressed:()=>Navigator.pop(ctx)),
          CCButton(label:'🖨  Daftarkan & Cetak',color:AppColors.antrian,
              onPressed:(){
                if(cNama.text.trim().isEmpty||cKepl.text.trim().isEmpty){
                  ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content:Text('Nama dan keperluan wajib diisi')));
                  return;
                }
                final no = state.nextAntrianNo(vKode);
                state.addAntrian(AntrianItem(
                    no:no, nama:cNama.text.trim(),
                    umur:int.tryParse(cUmur.text.trim())??0,
                    keperluan:cKepl.text.trim(),
                    tglDaftar:'${DateTime.now().hour.toString().padLeft(2,'0')}:${DateTime.now().minute.toString().padLeft(2,'0')}',
                    status:'Menunggu', prioritas:vPrio,
                    estimasi:cEst.text.trim().isEmpty?'-':cEst.text.trim()), vKode);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:Text('Nomor $no berhasil didaftarkan & dicetak'),
                    backgroundColor:AppColors.green));
              }),
        ],
      ),
    ));
  }

  void _showCetakDialog(BuildContext context) {
    final state = context.read<AppState>();
    final poli  = poliList.firstWhere((p)=>p.kode==state.poliAktif);
    final nowList = state.antrianAktif.where((a) => a.status == 'Dipanggil' || a.status == 'URGENT').toList();
    final now   = nowList.isNotEmpty ? nowList.first : (state.antrianAktif.isNotEmpty ? state.antrianAktif.first : null);

    showDialog(context:context, builder:(_)=>CCDialog(
      title:'Cetak Nomor Antrian — Printer Termal',
      content:Column(children:[
        Container(
          padding:EdgeInsets.all(20),
          decoration:BoxDecoration(color:AppColors.ivory,
              borderRadius:BorderRadius.circular(12),
              border:Border.all(color:AppColors.border,width:2)),
          child:Column(children:[
            Text('RS UMUM DAERAH MANADO',style:GoogleFonts.inter(
                fontSize:13,fontWeight:FontWeight.w800,color:AppColors.textDark)),
            Text('Poliklinik: ${poli.nama}',style:GoogleFonts.inter(
                fontSize:11,color:AppColors.textMid)),
            Divider(color:AppColors.border),
            Text(now?.no ?? '—',style:GoogleFonts.playfairDisplay(
                fontSize:56,fontWeight:FontWeight.w900,
                color:Color(poli.warna))),
            Text(now?.nama ?? 'Tidak ada antrian',style:GoogleFonts.inter(
                fontSize:13,fontWeight:FontWeight.w700,color:AppColors.textDark)),
            if(now!=null) Text('Estimasi: ${now.estimasi}',
                style:GoogleFonts.inter(fontSize:11,color:AppColors.textLight)),
            SizedBox(height:4),
            Text('${DateTime.now().day.toString().padLeft(2,'0')}/'
                 '${DateTime.now().month.toString().padLeft(2,'0')}/'
                 '${DateTime.now().year}',
                style:GoogleFonts.inter(fontSize:10,color:AppColors.textLight)),
          ]),
        ),
        SizedBox(height:12),
        Text('Dikirim ke: Printer Termal — Loket Pendaftaran',
            style:GoogleFonts.inter(fontSize:11,color:AppColors.textLight)),
      ]),
      actions:[
        CCButton(label:'Batal',outline:true,color:AppColors.sage,
            textColor:AppColors.sage,onPressed:()=>Navigator.pop(context)),
        CCButton(label:'🖨  Cetak Sekarang',onPressed:(){
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:Text('Nomor antrian berhasil dikirim ke printer termal!'),
              backgroundColor:AppColors.green));
        }),
      ],
    ));
  }

  void _showDisplayDialog(BuildContext context) {
    final state = context.read<AppState>();
    showDialog(context:context, builder:(_)=>Dialog(
      backgroundColor:Color(0xFF0a1a0e),
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)),
      child:ConstrainedBox(
        constraints:BoxConstraints(maxWidth:700,maxHeight:480),
        child:Padding(padding:EdgeInsets.all(24),child:Column(children:[
          Text('ANTRIAN POLIKLINIK',style:GoogleFonts.playfairDisplay(
              fontSize:22,fontWeight:FontWeight.w800,color:Color(0xFF7adf8a))),
          Text('${DateTime.now().day.toString().padLeft(2,'0')}/'
               '${DateTime.now().month.toString().padLeft(2,'0')}/'
               '${DateTime.now().year}',
               style:GoogleFonts.inter(fontSize:12,color:Color(0xFF4a6e52))),
          SizedBox(height:12),
          Divider(color:Color(0xFF1c3a22)),
          SizedBox(height:12),
          Expanded(child:GridView.count(
            crossAxisCount:3, childAspectRatio:2,
            mainAxisSpacing:10, crossAxisSpacing:10,
            children:poliList.map((poli){
              final data = state.antrian[poli.kode]??[];
              final nowList2 = data.where((a)=>a.status=='Dipanggil'||a.status=='URGENT').toList();
              final now  = nowList2.isNotEmpty ? nowList2.first : null;
              return Container(
                padding:EdgeInsets.all(12),
                decoration:BoxDecoration(
                    color:Color(0xFF0f2a14),
                    borderRadius:BorderRadius.circular(10)),
                child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Text('${poli.ikon} ${poli.nama}',style:GoogleFonts.inter(
                      fontSize:10,fontWeight:FontWeight.w700,
                      color:Color(poli.warna))),
                  SizedBox(height:4),
                  Text(now?.no ?? '—',style:GoogleFonts.inter(
                      fontSize:28,fontWeight:FontWeight.w900,color:Colors.white)),
                  Text(now!=null?(now.nama.length>14?'${now.nama.substring(0,14)}…':now.nama):'Menunggu',
                      style:GoogleFonts.inter(fontSize:10,color:Color(0xFF8aaa90))),
                ]),
              );
            }).toList(),
          )),
          SizedBox(height:8),
          Text('📺  Simulasi layar. Di RS nyata, output dikirim ke monitor TV ruang tunggu via port video lokal.',
              style:GoogleFonts.inter(fontSize:10,color:Color(0xFF4a6e52)),
              textAlign:TextAlign.center),
          SizedBox(height:8),
          TextButton(onPressed:()=>Navigator.pop(context),
              child:Text('Tutup',style:GoogleFonts.inter(
                  fontSize:12,color:Color(0xFF7adf8a)))),
        ])),
      ),
    ));
  }
}
