// lib/screens/kepatuhan_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class KepatuhanScreen extends StatelessWidget {
  const KepatuhanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state  = context.watch<AppState>();
    final aktif  = state.pasien.where((px) => px.status == 'Dalam Terapi').toList();
    final kAvg   = aktif.isEmpty ? 0 : aktif.map((px) => px.kepatuhan).reduce((a,b)=>a+b) ~/ aktif.length;
    final patuh  = aktif.where((px) => px.kepatuhan >= 85).length;
    final tindak = aktif.where((px) => px.kepatuhan < 70).length;
    final total  = state.pasien.length;
    final nPatuh = state.pasien.where((px) => px.kepatuhan >= 90).length;
    final nCukup = state.pasien.where((px) => px.kepatuhan >= 50 && px.kepatuhan < 90).length;
    final nTdk   = state.pasien.where((px) => px.kepatuhan < 50).length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        Text('Monitoring Kepatuhan Minum Obat',
            style:GoogleFonts.inter(fontSize:15,fontWeight:FontWeight.w800,
                color:AppColors.textDark)),
        SizedBox(height:16),

        // Stat cards
        Row(children:[
          Expanded(child:_miniCard('Kepatuhan Rata-rata','$kAvg%','Pasien aktif saat ini',AppColors.green)),
          SizedBox(width:10),
          Expanded(child:_miniCard('Patuh (≥85%)','$patuh','Kepatuhan baik',AppColors.terracotta)),
          SizedBox(width:10),
          Expanded(child:_miniCard('Perlu Tindak Lanjut','$tindak','Kepatuhan <70%',AppColors.blood)),
        ]),
        SizedBox(height:16),

        // Distribution
        Card(child:Padding(padding:EdgeInsets.all(16),child:Column(
          crossAxisAlignment:CrossAxisAlignment.start, children:[
            Text('Distribusi Kepatuhan',style:GoogleFonts.inter(fontSize:13,
                fontWeight:FontWeight.w700,color:AppColors.textDark)),
            SizedBox(height:8), Divider(color:AppColors.border), SizedBox(height:8),
            for(var (lbl, n, clr) in [
              ('Patuh (≥90%)',       nPatuh, AppColors.green),
              ('Cukup Patuh (50–89%)',nCukup,AppColors.terracotta),
              ('Tidak Patuh (<50%)', nTdk,   AppColors.blood),
            ])
              Padding(padding:EdgeInsets.only(bottom:12),child:Row(children:[
                SizedBox(width:200,child:Text(lbl,style:GoogleFonts.inter(
                    fontSize:12,color:AppColors.textMid))),
                Expanded(child:ProgressBar(value:total>0?n/total:0,color:clr)),
                SizedBox(width:8),
                Text('$n pasien',style:GoogleFonts.inter(fontSize:11,
                    fontWeight:FontWeight.w700,color:clr)),
              ])),
          ],
        ))),
        SizedBox(height:16),

        // Table
        Card(child:Column(children:[
          _tblHeader(),
          ...state.pasien.map((px) {
            final st = px.kepatuhan>=85 ? '✅ Konfirmasi'
                     : px.kepatuhan>=70 ? '⚠ Parsial' : '❌ Terlewat';
            final stClr = px.kepatuhan>=85 ? AppColors.green
                        : px.kepatuhan>=70 ? AppColors.yellow : AppColors.blood;
            return Column(children:[
              Divider(height:1,color:AppColors.border),
              InkWell(
                onTap:()=>_showReminderDialog(context, px),
                child:Padding(padding:EdgeInsets.symmetric(horizontal:12,vertical:10),
                  child:Row(children:[
                    SizedBox(width:100,child:Text(px.id,style:GoogleFonts.inter(
                        fontSize:10,color:AppColors.textLight),overflow:TextOverflow.ellipsis)),
                    SizedBox(width:150,child:Text(px.nama,style:GoogleFonts.inter(
                        fontSize:11,fontWeight:FontWeight.w600,color:AppColors.textDark),
                        overflow:TextOverflow.ellipsis)),
                    SizedBox(width:130,child:Text(px.fase,style:GoogleFonts.inter(
                        fontSize:10,color:AppColors.textMid),overflow:TextOverflow.ellipsis)),
                    SizedBox(width:90,child:Text('${px.kepatuhan}%',style:GoogleFonts.inter(
                        fontSize:12,fontWeight:FontWeight.w700,
                        color:px.kepatuhan>=85?AppColors.green:
                              px.kepatuhan>=70?AppColors.yellow:AppColors.blood))),
                    SizedBox(width:130,child:Text(st,style:GoogleFonts.inter(
                        fontSize:10,fontWeight:FontWeight.w600,color:stClr))),
                    SizedBox(width:140,child:CCButton(label:'Kirim Reminder',
                        color:AppColors.antrian,
                        onPressed:()=>_showReminderDialog(context,px))),
                  ]),
                ),
              ),
            ]);
          }).toList(),
        ])),
      ]),
    );
  }

  Widget _miniCard(String lbl, String val, String sub, Color clr) => Card(
    child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      Container(height:3,decoration:BoxDecoration(color:clr,
          borderRadius:BorderRadius.vertical(top:Radius.circular(12)))),
      Padding(padding:EdgeInsets.fromLTRB(14,10,14,12),child:Column(
        crossAxisAlignment:CrossAxisAlignment.start, children:[
          Text(lbl.toUpperCase(),style:GoogleFonts.inter(fontSize:9,
              color:AppColors.textLight,fontWeight:FontWeight.w600)),
          SizedBox(height:4),
          Text(val,style:GoogleFonts.inter(fontSize:24,fontWeight:FontWeight.w800,
              color:AppColors.textDark)),
          Text(sub,style:GoogleFonts.inter(fontSize:10,color:clr)),
        ])),
    ]),
  );

  Widget _tblHeader() => Container(
    padding:EdgeInsets.symmetric(horizontal:12,vertical:10),
    decoration:BoxDecoration(color:AppColors.ivory,
        borderRadius:BorderRadius.vertical(top:Radius.circular(12))),
    child:Row(children:[
      for(var (h,w) in [('ID',100),('Nama',150),('Fase',130),('Kepatuhan',90),
                         ('Status',130),('Aksi',140)])
        SizedBox(width:w.toDouble(),child:Text(h,style:GoogleFonts.inter(
            fontSize:10,fontWeight:FontWeight.w700,color:AppColors.textMid))),
    ]),
  );

  void _showReminderDialog(BuildContext context, Pasien px) {
    String cara = 'WhatsApp';
    final msgCtrl = TextEditingController(
        text:'Yth. ${px.nama},\nJangan lupa minum obat TBC Anda hari ini sesuai jadwal. '
             'Kepatuhan minum obat sangat penting untuk kesembuhan Anda. Terima kasih.');

    showDialog(context:context, builder:(_)=>StatefulBuilder(
      builder:(_,setSt)=>CCDialog(
        title:'Kirim Reminder — ${px.nama}',
        content:Column(mainAxisSize:MainAxisSize.min, children:[
          InfoBanner(text:'Kepatuhan: ${px.kepatuhan}%  |  ${px.fase}',
              bgColor:AppColors.greenLt, textColor:AppColors.darkGreen,
              icon:Icons.info_outline),
          SizedBox(height:12),
          LabeledDropdown(label:'Cara Pengiriman', value:cara,
              items:['WhatsApp','SMS','Telepon Langsung','Email'],
              onChanged:(v)=>setSt(()=>cara=v!)),
          LabeledField(label:'Pesan',controller:msgCtrl,maxLines:4),
        ]),
        actions:[
          CCButton(label:'Batal',outline:true,color:AppColors.sage,
              textColor:AppColors.sage,onPressed:()=>Navigator.pop(context)),
          CCButton(label:'Kirim',icon:Icons.send,onPressed:(){
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:Text('Reminder berhasil dikirim via $cara ke ${px.nama}'),
                backgroundColor:AppColors.green));
          }),
        ],
      ),
    ));
  }
}
