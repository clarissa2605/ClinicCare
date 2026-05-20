// lib/screens/lab_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class LabScreen extends StatelessWidget {
  const LabScreen({super.key});

  Color _statusColor(String s) {
    switch(s){
      case 'Kritis':   return AppColors.blood;
      case 'MDR':      return Color(0xFF7a0000);
      case 'Abnormal': return AppColors.yellow;
      case 'Positif':  return AppColors.terracotta;
      case 'Rendah':   return AppColors.yellow;
      default:         return AppColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return SingleChildScrollView(
      padding:EdgeInsets.all(20),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Row(children:[
          Text('Lab & Diagnostik',style:GoogleFonts.inter(fontSize:15,
              fontWeight:FontWeight.w800,color:AppColors.textDark)),
          Spacer(),
          CCButton(label:'Input Hasil Lab',icon:Icons.add,
              onPressed:()=>_showInputDialog(context)),
        ]),
        SizedBox(height:16),
        Card(child:Column(children:[
          _header(),
          ...state.lab.asMap().entries.map((e)=>_row(e.value)),
        ])),
      ]),
    );
  }

  Widget _header() => Container(
    padding:EdgeInsets.symmetric(horizontal:12,vertical:10),
    decoration:BoxDecoration(color:AppColors.ivory,
        borderRadius:BorderRadius.vertical(top:Radius.circular(12))),
    child:Row(children:[
      for(var (h,w) in [('ID Pasien',110),('Nama',150),('Jenis Pemeriksaan',170),
                         ('Hasil',220),('Tanggal',100),('Status',90)])
        SizedBox(width:w.toDouble(),child:Text(h,style:GoogleFonts.inter(
            fontSize:10,fontWeight:FontWeight.w700,color:AppColors.textMid))),
    ]),
  );

  Widget _row(HasilLab hl) {
    final clr = _statusColor(hl.status);
    return Column(children:[
      Divider(height:1,color:AppColors.border),
      Padding(padding:EdgeInsets.symmetric(horizontal:12,vertical:10),
        child:Row(children:[
          SizedBox(width:110,child:Text(hl.idPasien,style:GoogleFonts.inter(
              fontSize:10,color:AppColors.textLight),overflow:TextOverflow.ellipsis)),
          SizedBox(width:150,child:Text(hl.nama,style:GoogleFonts.inter(
              fontSize:11,fontWeight:FontWeight.w600,color:AppColors.textDark),
              overflow:TextOverflow.ellipsis)),
          SizedBox(width:170,child:Text(hl.jenis,style:GoogleFonts.inter(
              fontSize:10,color:AppColors.textMid),overflow:TextOverflow.ellipsis)),
          SizedBox(width:220,child:Text(hl.hasil,style:GoogleFonts.inter(
              fontSize:10,color:AppColors.textMid),overflow:TextOverflow.ellipsis)),
          SizedBox(width:100,child:Text(hl.tgl,style:GoogleFonts.inter(
              fontSize:10,color:AppColors.textLight))),
          SizedBox(width:90,child:StatusBadge(hl.status,color:clr)),
        ]),
      ),
    ]);
  }

  void _showInputDialog(BuildContext context) {
    final state  = context.read<AppState>();
    
    // Safety check kalau data pasien masih kosong
    if (state.pasien.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content:Text('Data pasien kosong! Tambahkan pasien terlebih dahulu.')));
      return;
    }
    
    final namalist = state.pasien.map((p)=>p.nama).toList();
    String vNama  = namalist.first;
    String vJenis = 'BTA Sputum';
    String vStatus= 'Normal';
    final cHasil  = TextEditingController();
    final cTgl    = TextEditingController(
        text:'${DateTime.now().day.toString().padLeft(2,'0')}/'
             '${DateTime.now().month.toString().padLeft(2,'0')}/'
             '${DateTime.now().year}');

    showDialog(context:context, builder:(ctx)=>StatefulBuilder(
      builder:(ctx,setSt)=>CCDialog(
        title:'Input Hasil Lab / Diagnostik',
        content:Column(mainAxisSize:MainAxisSize.min, children:[
          LabeledDropdown(label:'Nama Pasien *', value:vNama,
              items:namalist, onChanged:(v)=>setSt(()=>vNama=v!)),
          LabeledDropdown(label:'Jenis Pemeriksaan *', value:vJenis,
              items:const ['BTA Sputum','TCM GeneXpert','Foto Toraks','CD4 Count',
                     'Darah Rutin','Fungsi Hati (SGOT/SGPT)','Kultur Sputum'],
              onChanged:(v)=>setSt(()=>vJenis=v!)),
          LabeledField(label:'Hasil Pemeriksaan *', controller:cHasil),
          LabeledDropdown(label:'Status Hasil', value:vStatus,
              items:const ['Normal','Abnormal','Positif','Kritis','MDR','Rendah'],
              onChanged:(v)=>setSt(()=>vStatus=v!)),
          LabeledField(label:'Tanggal (DD/MM/YYYY)', controller:cTgl),
        ]),
        actions:[
          CCButton(label:'Batal',outline:true,color:AppColors.sage,
              textColor:AppColors.sage,onPressed:()=>Navigator.pop(ctx)),
          CCButton(label:'Simpan',onPressed:() async {
            if(cHasil.text.trim().isEmpty){
              ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content:Text('Hasil pemeriksaan wajib diisi')));
              return;
            }
            final px=state.pasien.firstWhere((p)=>p.nama==vNama);
            
            // PENAMBAHAN ID GENERATE & AWAIT DI SINI
            await state.addLab(HasilLab(
                id: 'L-${DateTime.now().millisecondsSinceEpoch}',
                idPasien:px.id, nama:vNama, jenis:vJenis,
                hasil:cHasil.text.trim(),
                tgl:cTgl.text.trim(), status:vStatus));
                
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:Text('Hasil lab berhasil disimpan'),
                backgroundColor:AppColors.green));
          }),
        ],
      ),
    ));
  }
}