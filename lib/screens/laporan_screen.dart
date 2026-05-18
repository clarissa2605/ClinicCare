// lib/screens/laporan_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class LaporanScreen extends StatelessWidget {
  const LaporanScreen({super.key});

  static const _rows = [
    ('Pasien ART Terdaftar',           '100%','22/27','63%',  'Tercapai'),
    ('Rata-rata Kepatuhan Minum Obat', '≥85%','94%',  '98.8%','Mendekati'),
    ('Pasien Putus Obat',              '≤5%', '6.2%', '98.7%','Perlu Perbaikan'),
    ('Keberhasilan Terapi',            '≥90%','87%',  '96.7%','Mendekati'),
    ('Konversi BTA Bulan 2',           '≥80%','88%',  '110%', 'Tercapai'),
    ('Pasien dengan Efek Samping',     '-',   '88',   '-',    'Terpantau'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return SingleChildScrollView(
      padding:EdgeInsets.all(20),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Row(children:[
          Text('Laporan Bulanan — April 2026',style:GoogleFonts.inter(
              fontSize:15,fontWeight:FontWeight.w800,color:AppColors.textDark)),
          Spacer(),
          CCButton(label:'🖨  Cetak',color:AppColors.darkGreen,
              onPressed:()=>_showEksporDialog(context)),
          SizedBox(width:8),
          CCButton(label:'📊  Ekspor CSV',color:AppColors.evergreen,
              onPressed:(){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:Text('Laporan diekspor ke CSV'),
                    backgroundColor:AppColors.green));
              }),
        ]),
        SizedBox(height:16),
        Row(children:[
          for(var (lbl,val,sub,clr) in [
            ('Total Pasien','${state.pasien.length}','Terdaftar',AppColors.terracotta),
            ('Kepatuhan',
             '${state.kepatuhanRataRata.toStringAsFixed(0)}%','Rata-rata',AppColors.green),
            ('Putus Obat','${state.totalPutusObat}','Perlu intervensi',AppColors.blood),
            ('Selesai','${state.totalSelesai}','Bulan ini',AppColors.evergreen),
          ]) ...[
            Expanded(child:Card(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Container(height:3,decoration:BoxDecoration(color:clr,
                  borderRadius:BorderRadius.vertical(top:Radius.circular(12)))),
              Padding(padding:EdgeInsets.fromLTRB(14,10,14,12),child:Column(
                crossAxisAlignment:CrossAxisAlignment.start, children:[
                  Text(lbl,style:GoogleFonts.inter(fontSize:11,color:AppColors.textLight)),
                  Text(val,style:GoogleFonts.inter(fontSize:24,fontWeight:FontWeight.w800,
                      color:AppColors.textDark)),
                  Text(sub,style:GoogleFonts.inter(fontSize:10,color:clr)),
                ])),
            ]))),
            SizedBox(width:10),
          ],
        ]),
        SizedBox(height:16),
        Card(child:Column(children:[
          // Table header
          Container(
            padding:EdgeInsets.symmetric(horizontal:12,vertical:10),
            decoration:BoxDecoration(color:AppColors.ivory,
                borderRadius:BorderRadius.vertical(top:Radius.circular(12))),
            child:Row(children:[
              for(var (h,w) in [('Indikator',230),('Target',80),('Bulan Lalu',90),
                                 ('Bulan Ini',80),('Pencapaian',100),('Status',130)])
                SizedBox(width:w.toDouble(),child:Text(h,style:GoogleFonts.inter(
                    fontSize:10,fontWeight:FontWeight.w700,color:AppColors.textMid))),
            ]),
          ),
          ..._rows.map((r){
            final stClr = r.$5=='Tercapai' ? AppColors.green
                        : r.$5=='Perlu Perbaikan' ? AppColors.blood
                        : AppColors.yellow;
            return Column(children:[
              Divider(height:1,color:AppColors.border),
              Padding(padding:EdgeInsets.symmetric(horizontal:12,vertical:10),
                child:Row(children:[
                  SizedBox(width:230,child:Text(r.$1,style:GoogleFonts.inter(
                      fontSize:11,color:AppColors.textDark),overflow:TextOverflow.ellipsis)),
                  SizedBox(width:80,child:Text(r.$2,style:GoogleFonts.inter(
                      fontSize:11,color:AppColors.textMid),textAlign:TextAlign.center)),
                  SizedBox(width:90,child:Text(r.$3,style:GoogleFonts.inter(
                      fontSize:11,color:AppColors.textMid),textAlign:TextAlign.center)),
                  SizedBox(width:80,child:Text(r.$4,style:GoogleFonts.inter(
                      fontSize:11,color:AppColors.textMid),textAlign:TextAlign.center)),
                  SizedBox(width:100,child:Text(r.$4,style:GoogleFonts.inter(
                      fontSize:11,color:AppColors.textMid),textAlign:TextAlign.center)),
                  SizedBox(width:130,child:StatusBadge(r.$5,color:stClr)),
                ]),
              ),
            ]);
          }).toList(),
        ])),
      ]),
    );
  }

  void _showEksporDialog(BuildContext context) {
    String vFormat = 'PDF';
    String vPeriode = 'April 2026';
    String vScope   = 'Semua Pasien';

    showDialog(context:context, builder:(ctx)=>StatefulBuilder(
      builder:(ctx,setSt)=>CCDialog(
        title:'Ekspor Laporan',
        content:Column(mainAxisSize:MainAxisSize.min, children:[
          LabeledDropdown(label:'Format Ekspor', value:vFormat,
              items:['PDF','Excel (XLSX)','CSV','Word (DOCX)'],
              onChanged:(v)=>setSt(()=>vFormat=v!)),
          LabeledDropdown(label:'Periode', value:vPeriode,
              items:['April 2026','Maret 2026','Q1 2026','Tahunan 2026'],
              onChanged:(v)=>setSt(()=>vPeriode=v!)),
          LabeledDropdown(label:'Cakupan Data', value:vScope,
              items:['Semua Pasien','Pasien Aktif','Pasien TBC Paru','MDR-TBC'],
              onChanged:(v)=>setSt(()=>vScope=v!)),
          InfoBanner(
              text:'📁 File akan disimpan di folder: /ClinicCare/Laporan/',
              bgColor:AppColors.greenLt, textColor:AppColors.darkGreen,
              icon:Icons.folder_outlined),
        ]),
        actions:[
          CCButton(label:'Batal',outline:true,color:AppColors.sage,
              textColor:AppColors.sage,onPressed:()=>Navigator.pop(ctx)),
          CCButton(label:'📤  Ekspor Sekarang',onPressed:(){
            Navigator.pop(ctx);
            final now = DateTime.now();
            final fname='laporan_${vPeriode.replaceAll(' ','_')}_'
                '${now.day.toString().padLeft(2,'0')}${now.month.toString().padLeft(2,'0')}${now.year}';
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:Text('✅ Laporan $fname.$vFormat berhasil diekspor!'),
                backgroundColor:AppColors.green));
          }),
        ],
      ),
    ));
  }
}
