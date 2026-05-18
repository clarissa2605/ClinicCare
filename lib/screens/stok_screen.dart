// lib/screens/stok_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class StokScreen extends StatelessWidget {
  const StokScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state   = context.watch<AppState>();
    final kritis  = state.stok.where((o)=>o.menipis).toList();

    return SingleChildScrollView(
      padding:EdgeInsets.all(20),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Row(children:[
          Text('Manajemen Stok Obat',style:GoogleFonts.inter(fontSize:15,
              fontWeight:FontWeight.w800,color:AppColors.textDark)),
          Spacer(),
          CCButton(label:'Update Stok',icon:Icons.add,
              onPressed:()=>_showUpdateDialog(context,null)),
        ]),
        SizedBox(height:12),
        if(kritis.isNotEmpty)
          InfoBanner(
              text:'⚠  ${kritis.length} obat stok menipis: ${kritis.map((o)=>o.nama).join(", ")}',
              bgColor:AppColors.bloodLt,textColor:AppColors.blood,
              icon:Icons.warning_amber),
        SizedBox(height:16),
        ...state.stok.map((ob)=>_StokCard(ob:ob,onEdit:()=>_showUpdateDialog(context,ob))),
      ]),
    );
  }

  void _showUpdateDialog(BuildContext context, StokObat? ob) {
    final state   = context.read<AppState>();
    final namaList= state.stok.map((o)=>o.nama).toList();
    String vNama  = ob?.nama ?? namaList.first;
    String vAksi  = 'Set Nilai Baru';
    final cStok   = TextEditingController(text: ob!=null?'${ob.stok}':'');
    final cMaks   = TextEditingController(text: ob!=null?'${ob.maks}':'');
    final cCat    = TextEditingController();

    showDialog(context:context, builder:(ctx)=>StatefulBuilder(
      builder:(ctx,setSt)=>CCDialog(
        title:'Update Stok Obat',
        content:Column(mainAxisSize:MainAxisSize.min, children:[
          LabeledDropdown(label:'Nama Obat *', value:vNama,
              items:namaList, onChanged:(v)=>setSt(()=>vNama=v!)),
          LabeledDropdown(label:'Jenis Update', value:vAksi,
              items:['Set Nilai Baru','Tambah Stok','Kurangi Stok'],
              onChanged:(v)=>setSt(()=>vAksi=v!)),
          LabeledField(label:'Jumlah / Stok Baru *', controller:cStok,
              keyboardType:TextInputType.number),
          LabeledField(label:'Kapasitas Maksimum', controller:cMaks,
              keyboardType:TextInputType.number),
          LabeledField(label:'Keterangan / No. Batch', controller:cCat),
        ]),
        actions:[
          CCButton(label:'Batal',outline:true,color:AppColors.sage,
              textColor:AppColors.sage,onPressed:()=>Navigator.pop(ctx)),
          CCButton(label:'Simpan',onPressed:(){
            final jml = int.tryParse(cStok.text.trim());
            if(jml==null){
              ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content:Text('Jumlah harus berupa angka')));
              return;
            }
            final target=state.stok.firstWhere((o)=>o.nama==vNama);
            final mksBaru=int.tryParse(cMaks.text.trim());
            if(mksBaru!=null) target.maks=mksBaru;
            state.updateStok(vNama, jml, vAksi);
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:Text('Stok $vNama diperbarui'),
                backgroundColor:AppColors.green));
          }),
        ],
      ),
    ));
  }
}

class _StokCard extends StatelessWidget {
  final StokObat   ob;
  final VoidCallback onEdit;
  const _StokCard({required this.ob, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final clr = ob.menipis ? AppColors.blood
               :ob.waspada ? AppColors.yellow : AppColors.green;
    return Card(
      margin:EdgeInsets.only(bottom:10),
      child:Padding(padding:EdgeInsets.fromLTRB(14,12,14,12),child:Column(children:[
        Row(children:[
          Expanded(child:Text(ob.nama,style:GoogleFonts.inter(
              fontSize:13,fontWeight:FontWeight.w700,color:AppColors.textDark))),
          Text('${ob.stok.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'),(m)=>'${m[1]}.')} / '
               '${ob.maks.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'),(m)=>'${m[1]}.')} '
               '${ob.sat}',
               style:GoogleFonts.inter(fontSize:12,color:AppColors.textMid)),
          SizedBox(width:12),
          if(ob.menipis)
            Container(padding:EdgeInsets.symmetric(horizontal:8,vertical:3),
                decoration:BoxDecoration(color:AppColors.bloodLt,
                    borderRadius:BorderRadius.circular(6)),
                child:Text('Stok Menipis',style:GoogleFonts.inter(
                    fontSize:10,color:AppColors.blood,fontWeight:FontWeight.w700))),
          SizedBox(width:8),
          Text('${(ob.persen*100).toStringAsFixed(0)}%',
              style:GoogleFonts.inter(fontSize:13,fontWeight:FontWeight.w800,color:clr)),
          SizedBox(width:8),
          CCButton(label:'Update',outline:true,color:AppColors.evergreen,
              textColor:AppColors.evergreen,onPressed:onEdit),
        ]),
        SizedBox(height:8),
        ProgressBar(value:ob.persen, color:clr, height:10),
      ])),
    );
  }
}
