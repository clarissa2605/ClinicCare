// lib/screens/jadwal_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class JadwalScreen extends StatelessWidget {
  const JadwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final nTerjadwal  = state.jadwal.where((j)=>j.status=='Terjadwal').length;
    final nTdkHadir   = state.jadwal.where((j)=>j.status=='Tidak Hadir').length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Row(children:[
          Text('Jadwal Kontrol & Kunjungan Pasien',style:GoogleFonts.inter(
              fontSize:15,fontWeight:FontWeight.w800,color:AppColors.textDark)),
          Spacer(),
          CCButton(label:'Jadwalkan Pasien',icon:Icons.add,
              onPressed:()=>_showTambahDialog(context, null)),
        ]),
        SizedBox(height:16),

        // Mini stats
        Row(children:[
          for(var (lbl,val,clr) in [
            ('Total Jadwal','${state.jadwal.length}',AppColors.darkGreen),
            ('Terjadwal','$nTerjadwal',AppColors.yellow),
            ('Tidak Hadir','$nTdkHadir',AppColors.blood),
          ]) ...[
            Expanded(child:Card(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Container(height:3,decoration:BoxDecoration(color:clr,
                  borderRadius:BorderRadius.vertical(top:Radius.circular(12)))),
              Padding(padding:EdgeInsets.fromLTRB(14,10,14,12),child:Column(
                crossAxisAlignment:CrossAxisAlignment.start, children:[
                  Text(lbl,style:GoogleFonts.inter(fontSize:11,color:AppColors.textLight)),
                  Text(val,style:GoogleFonts.inter(fontSize:22,fontWeight:FontWeight.w800,
                      color:AppColors.textDark)),
                ])),
            ]))),
            SizedBox(width:10),
          ],
        ]),
        SizedBox(height:16),

        // Table
        Card(child:Column(children:[
          _header(),
          ...state.jadwal.asMap().entries.map((e)=>_row(context,e.value,e.key,state)),
        ])),
      ]),
    );
  }

  Widget _header() => Container(
    padding:EdgeInsets.symmetric(horizontal:12,vertical:10),
    decoration:BoxDecoration(color:AppColors.ivory,
        borderRadius:BorderRadius.vertical(top:Radius.circular(12))),
    child:Row(children:[
      for(var (h,w) in [('Tanggal',90),('Pukul',70),('Nama Pasien',140),
                         ('Poliklinik',110),('Dokter',140),('Catatan',180),('Status',110)])
        SizedBox(width:w.toDouble(),child:Text(h,style:GoogleFonts.inter(
            fontSize:10,fontWeight:FontWeight.w700,color:AppColors.textMid))),
      SizedBox(width:60,child:Text('Aksi',style:GoogleFonts.inter(
          fontSize:10,fontWeight:FontWeight.w700,color:AppColors.textMid))),
    ]),
  );

  Widget _row(BuildContext context, JadwalKontrol j, int idx, AppState state) {
    final tdkHadir = j.status == 'Tidak Hadir';
    final clr = tdkHadir ? AppColors.blood
        : j.status=='Sudah Hadir' ? AppColors.green : AppColors.textDark;
    return Column(children:[
      Divider(height:1,color:AppColors.border),
      InkWell(
        onTap:()=>_showUpdateDialog(context, j),
        child:Padding(padding:EdgeInsets.symmetric(horizontal:12,vertical:10),
          child:Row(children:[
            SizedBox(width:90,child:Text(j.tgl,style:GoogleFonts.inter(
                fontSize:11,color:AppColors.textMid))),
            SizedBox(width:70,child:Text(j.pukul,style:GoogleFonts.inter(
                fontSize:11,fontWeight:FontWeight.w600,color:AppColors.textDark))),
            SizedBox(width:140,child:Text(j.nama,style:GoogleFonts.inter(
                fontSize:11,fontWeight:FontWeight.w600,color:AppColors.textDark),
                overflow:TextOverflow.ellipsis)),
            SizedBox(width:110,child:Text(j.poli,style:GoogleFonts.inter(
                fontSize:10,color:AppColors.textMid),overflow:TextOverflow.ellipsis)),
            SizedBox(width:140,child:Text(j.dokter,style:GoogleFonts.inter(
                fontSize:10,color:AppColors.textMid),overflow:TextOverflow.ellipsis)),
            SizedBox(width:180,child:Text(j.catatan,style:GoogleFonts.inter(
                fontSize:10,color:AppColors.textLight),overflow:TextOverflow.ellipsis)),
            SizedBox(width:110,child:StatusBadge(j.status,
                color:tdkHadir?AppColors.blood:
                      j.status=='Sudah Hadir'?AppColors.green:AppColors.evergreen)),
            SizedBox(width:60,child:IconButton(
                icon:Icon(Icons.edit,size:16,color:AppColors.evergreen),
                onPressed:()=>_showUpdateDialog(context,j))),
          ]),
        ),
      ),
    ]);
  }

  void _showTambahDialog(BuildContext context, Pasien? px) {
    final state = context.read<AppState>();
    final cNama  = TextEditingController(text: px?.nama ?? '');
    final cId    = TextEditingController(text: px?.id ?? '');
    final cTgl   = TextEditingController(text:
        '${DateTime.now().day.toString().padLeft(2,'0')}/'
        '${DateTime.now().month.toString().padLeft(2,'0')}/'
        '${DateTime.now().year}');
    final cPukul = TextEditingController(text:'08:00');
    final cCat   = TextEditingController();
    String vPoli='Poli TBC', vDok='dr. Rina Sari';

    showDialog(context:context, builder:(ctx)=>StatefulBuilder(
      builder:(ctx,setSt)=>CCDialog(
        title:'Tambah Jadwal Kontrol',
        content:Column(mainAxisSize:MainAxisSize.min, children:[
          LabeledField(label:'Nama Pasien *', controller:cNama),
          LabeledField(label:'ID Pasien *',   controller:cId),
          LabeledField(label:'Tanggal (DD/MM/YYYY) *', controller:cTgl),
          LabeledField(label:'Pukul (HH:MM) *', controller:cPukul),
          LabeledDropdown(label:'Poliklinik', value:vPoli,
              items:const ['Poli TBC','Poli Paru','Poli Umum','Laboratorium','Radiologi'],
              onChanged:(v)=>setSt(()=>vPoli=v!)),
          LabeledDropdown(label:'Dokter', value:vDok,
              items:const ['dr. Rina Sari','dr. Budi Santoso','dr. Samuel Wenas','dr. Yolanda Karwur'],
              onChanged:(v)=>setSt(()=>vDok=v!)),
          LabeledField(label:'Catatan', controller:cCat),
        ]),
        actions:[
          CCButton(label:'Batal',outline:true,color:AppColors.sage,
              textColor:AppColors.sage,onPressed:()=>Navigator.pop(ctx)),
          CCButton(label:'Simpan',onPressed:() async {
            if(cNama.text.trim().isEmpty||cId.text.trim().isEmpty||
               cTgl.text.trim().isEmpty||cPukul.text.trim().isEmpty){
              ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content:Text('Field bertanda * wajib diisi')));
              return;
            }
            
            // PENAMBAHAN ID GENERATE & AWAIT DI SINI
            await state.addJadwal(JadwalKontrol(
                id: 'J-${DateTime.now().millisecondsSinceEpoch}', 
                tgl:cTgl.text.trim(), pukul:cPukul.text.trim(),
                nama:cNama.text.trim(), idPasien:cId.text.trim(),
                poli:vPoli, dokter:vDok,
                catatan:cCat.text.trim().isEmpty?'-':cCat.text.trim(),
                status:'Terjadwal'));
                
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:Text('Jadwal berhasil disimpan'),
                backgroundColor:AppColors.green));
          }),
        ],
      ),
    ));
  }

  void _showUpdateDialog(BuildContext context, JadwalKontrol j) {
    final state = context.read<AppState>();
    String vStatus = j.status;
    final cCat = TextEditingController(text: j.catatan);

    showDialog(context:context, builder:(ctx)=>StatefulBuilder(
      builder:(ctx,setSt)=>CCDialog(
        title:'Update Status — ${j.nama}',
        content:Column(mainAxisSize:MainAxisSize.min, children:[
          InfoBanner(text:'${j.tgl}  ${j.pukul}  |  ${j.poli}',
              bgColor:AppColors.greenLt, textColor:AppColors.darkGreen,
              icon:Icons.calendar_today),
          SizedBox(height:12),
          LabeledDropdown(label:'Status Kunjungan', value:vStatus,
              items:const ['Terjadwal','Sudah Hadir','Tidak Hadir','Ditunda'],
              onChanged:(v)=>setSt(()=>vStatus=v!)),
          LabeledField(label:'Catatan Update', controller:cCat),
        ]),
        actions:[
          CCButton(label:'Batal',outline:true,color:AppColors.sage,
              textColor:AppColors.sage,onPressed:()=>Navigator.pop(ctx)),
          CCButton(label:'Simpan',onPressed:() async {
            // PENAMBAHAN AWAIT DI SINI
            await state.updateStatusJadwal(j, vStatus, cCat.text.trim().isEmpty?j.catatan:cCat.text.trim());
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:Text('Status jadwal diperbarui'),
                backgroundColor:AppColors.green));
          }),
        ],
      ),
    ));
  }
}