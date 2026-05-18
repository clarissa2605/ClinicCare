// lib/screens/peringatan_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class PeringatanScreen extends StatelessWidget {
  const PeringatanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Text('Peringatan Dini & Tindak Lanjut',style:GoogleFonts.inter(
            fontSize:15,fontWeight:FontWeight.w800,color:AppColors.textDark)),
        SizedBox(height:12),
        FilterChipRow(
            options:['Semua','KRITIS','Tinggi','Sedang','Rendah'],
            selected:state.filterPeringatan,
            onSelect:(v){ state.filterPeringatan=v; state.notifyListeners(); }),
        SizedBox(height:16),
        if(state.filteredPeringatan.isEmpty)
          Center(child:Padding(padding:EdgeInsets.all(40),child:Text(
              'Tidak ada peringatan untuk filter ini.',
              style:GoogleFonts.inter(fontSize:13,color:AppColors.textLight))))
        else
          ...state.filteredPeringatan.map((pw) => _PeringatanCard(pw:pw,state:state)),
      ]),
    );
  }
}

class _PeringatanCard extends StatelessWidget {
  final Peringatan pw;
  final AppState   state;
  const _PeringatanCard({required this.pw, required this.state});

  @override
  Widget build(BuildContext context) {
    final clr = AppColors.riskColor(pw.level);
    return Card(
      margin:EdgeInsets.only(bottom:10),
      shape:RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(12),
          side:BorderSide(color:clr,width:1.5)),
      child:Padding(padding:EdgeInsets.all(14),child:Column(
        crossAxisAlignment:CrossAxisAlignment.start, children:[
          Row(children:[
            RiskBadge(pw.level),
            SizedBox(width:10),
            Text(pw.nama,style:GoogleFonts.inter(fontSize:13,
                fontWeight:FontWeight.w700,color:AppColors.textDark)),
            SizedBox(width:8),
            Text(pw.idPasien,style:GoogleFonts.inter(fontSize:10,
                color:AppColors.textLight)),
            Spacer(),
            Text('${DateTime.now().day.toString().padLeft(2,'0')}/'
                 '${DateTime.now().month.toString().padLeft(2,'0')}/'
                 '${DateTime.now().year}',
                style:GoogleFonts.inter(fontSize:10,color:AppColors.textLight)),
          ]),
          SizedBox(height:8),
          Container(
            padding:EdgeInsets.symmetric(horizontal:10,vertical:6),
            decoration:BoxDecoration(color:clr.withOpacity(0.1),
                borderRadius:BorderRadius.circular(6)),
            child:Row(children:[
              Icon(Icons.warning_amber,size:14,color:clr),
              SizedBox(width:6),
              Expanded(child:Text(pw.isu,style:GoogleFonts.inter(
                  fontSize:12,color:AppColors.textMid))),
            ]),
          ),
          SizedBox(height:10),
          Row(children:[
            CCButton(label:pw.aksi,color:clr,
                onPressed:()=>_showAksiDialog(context, pw)),
            SizedBox(width:8),
            CCButton(label:'Lihat Detail',outline:true,color:AppColors.evergreen,
                textColor:AppColors.evergreen,
                onPressed:(){
                  final pxList = state.pasien.where((p)=>p.id==pw.idPasien).toList();
                  final px = pxList.isNotEmpty ? pxList.first : null;
                  if(px==null) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:Text('${px.nama} — ${px.diagnosa} — Hari ke-${px.hari}')));
                }),
            Spacer(),
            CCButton(label:'✓ Tandai Selesai',outline:true,
                color:AppColors.green,textColor:AppColors.green,
                onPressed:(){
                  state.selesaikanPeringatan(pw);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:Text('Peringatan ${pw.nama} selesai ditangani'),
                      backgroundColor:AppColors.green));
                }),
          ]),
        ],
      )),
    );
  }

  void _showAksiDialog(BuildContext context, Peringatan pw) {
    final aksiOpts = {
      'Hubungi Pasien':   ['WhatsApp','Telepon','SMS'],
      'Jadwalkan Kontrol':['Poli TBC','Poli Paru','Poli Umum'],
      'Follow-up Lab':    ['BTA Sputum','TCM GeneXpert','Foto Toraks'],
      'Konsultasi Dokter':['dr. Rina Sari','dr. Budi Santoso'],
      'Kirim Reminder':   ['WhatsApp','SMS','Email'],
    };
    final opts = aksiOpts[pw.aksi] ?? ['Tindakan'];
    String vOpt = opts.first;
    final cCat  = TextEditingController();

    showDialog(context:context, builder:(ctx)=>StatefulBuilder(
      builder:(ctx,setSt)=>CCDialog(
        title:'Tindak Lanjut: ${pw.aksi}',
        content:Column(mainAxisSize:MainAxisSize.min, children:[
          InfoBanner(
              text:'${pw.nama}  |  ${pw.idPasien}',
              bgColor:AppColors.riskLightColor(pw.level),
              textColor:AppColors.riskColor(pw.level),
              icon:Icons.warning_amber),
          SizedBox(height:8),
          Container(
            padding:EdgeInsets.all(10),
            decoration:BoxDecoration(
                color:AppColors.riskColor(pw.level).withOpacity(0.08),
                borderRadius:BorderRadius.circular(8)),
            child:Text(pw.isu,style:GoogleFonts.inter(fontSize:12,
                color:AppColors.riskColor(pw.level))),
          ),
          SizedBox(height:12),
          LabeledDropdown(label:opts.length>1?'Pilih Opsi':'Tindakan',
              value:vOpt, items:opts, onChanged:(v)=>setSt(()=>vOpt=v!)),
          LabeledField(label:'Catatan', controller:cCat),
        ]),
        actions:[
          CCButton(label:'Batal',outline:true,color:AppColors.sage,
              textColor:AppColors.sage,onPressed:()=>Navigator.pop(ctx)),
          CCButton(label:'✅  Eksekusi',
              color:AppColors.riskColor(pw.level),onPressed:(){
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:Text("'${pw.aksi}' untuk ${pw.nama} via $vOpt dicatat."),
                    backgroundColor:AppColors.green));
              }),
        ],
      ),
    ));
  }
}
