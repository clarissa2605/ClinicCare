// lib/screens/edukasi_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class EdukasiScreen extends StatelessWidget {
  const EdukasiScreen({super.key});

  static const _katColors = {
    'Pengenalan TBC': AppColors.darkGreen,
    'Pengobatan':     AppColors.terracotta,
    'Pencegahan':     AppColors.green,
    'Nutrisi':        AppColors.yellow,
    'Kepatuhan':      AppColors.antrian,
  };

  static const _katIcons = {
    'Pengenalan TBC': Icons.info_outline,
    'Pengobatan':     Icons.medication_outlined,
    'Pencegahan':     Icons.health_and_safety_outlined,
    'Nutrisi':        Icons.restaurant_outlined,
    'Kepatuhan':      Icons.checklist_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return SingleChildScrollView(
      padding:EdgeInsets.all(20),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Row(children:[
          Text('Konten Edukasi Pasien TBC',style:GoogleFonts.inter(
              fontSize:15,fontWeight:FontWeight.w800,color:AppColors.textDark)),
          Spacer(),
          CCButton(label:'Tambah Konten',icon:Icons.add,
              onPressed:()=>_showTambahDialog(context)),
        ]),
        SizedBox(height:12),
        FilterChipRow(
            options:const ['Semua','Pengenalan TBC','Pengobatan','Pencegahan','Nutrisi','Kepatuhan'],
            selected:state.filterEdukasi,
            onSelect:(v){ state.filterEdukasi=v; state.notifyListeners(); }),
        SizedBox(height:16),
        GridView.builder(
          shrinkWrap:true,
          physics:NeverScrollableScrollPhysics(),
          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:3, childAspectRatio:1.6,
              mainAxisSpacing:12, crossAxisSpacing:12),
          itemCount:state.filteredEdukasi.length,
          itemBuilder:(ctx,i){
            final edu = state.filteredEdukasi[i];
            final clr = _katColors[edu.kategori] ?? AppColors.sage;
            final ico = _katIcons[edu.kategori]  ?? Icons.article_outlined;
            return Card(
              child:Padding(padding:EdgeInsets.all(14),child:Column(
                crossAxisAlignment:CrossAxisAlignment.start, children:[
                  Row(children:[
                    Container(width:36,height:36,
                        decoration:BoxDecoration(color:clr,borderRadius:BorderRadius.circular(8)),
                        child:Icon(ico,size:18,color:Colors.white)),
                    SizedBox(width:8),
                    Expanded(child:Text(edu.kategori.toUpperCase(),
                        style:GoogleFonts.inter(fontSize:9,color:clr,
                            fontWeight:FontWeight.w700))),
                    IconButton(icon:Icon(Icons.edit,size:14,color:AppColors.textLight),
                        onPressed:()=>_showEditDialog(context,edu)),
                  ]),
                  SizedBox(height:6),
                  Expanded(child:Text(edu.judul,style:GoogleFonts.inter(
                      fontSize:12,fontWeight:FontWeight.w700,color:AppColors.textDark),
                      overflow:TextOverflow.ellipsis,maxLines:2)),
                  SizedBox(height:4),
                  Row(children:[
                    Icon(Icons.timer_outlined,size:11,color:AppColors.textLight),
                    SizedBox(width:3),
                    Text(edu.durasi,style:GoogleFonts.inter(fontSize:10,
                        color:AppColors.textLight)),
                    SizedBox(width:10),
                    Icon(Icons.visibility_outlined,size:11,color:AppColors.textLight),
                    SizedBox(width:3),
                    Text('${edu.views}',style:GoogleFonts.inter(fontSize:10,
                        color:AppColors.textLight)),
                    Spacer(),
                    InkWell(
                      borderRadius:BorderRadius.circular(6),
                      onTap:()=>_showBacaDialog(context, edu),
                      child:Container(
                        padding:EdgeInsets.symmetric(horizontal:10,vertical:4),
                        decoration:BoxDecoration(color:clr,
                            borderRadius:BorderRadius.circular(6)),
                        child:Text('Buka',style:GoogleFonts.inter(fontSize:10,
                            color:Colors.white,fontWeight:FontWeight.w700)),
                      ),
                    ),
                  ]),
                ],
              )),
            );
          },
        ),
      ]),
    );
  }

  void _showBacaDialog(BuildContext context, KontenEdukasi edu) async {
    final state = context.read<AppState>();
    // PENAMBAHAN AWAIT SAAT INCREMENT VIEWS
    await state.incrementViews(edu);
    final clr = _katColors[edu.kategori] ?? AppColors.sage;
    showDialog(context:context, builder:(_)=>Dialog(
      backgroundColor:AppColors.card,
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)),
      child:ConstrainedBox(
        constraints:BoxConstraints(maxWidth:520,maxHeight:520),
        child:Column(children:[
          Container(
            width:double.infinity,
            padding:EdgeInsets.fromLTRB(20,20,16,16),
            decoration:BoxDecoration(color:clr,
                borderRadius:BorderRadius.vertical(top:Radius.circular(16))),
            child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Row(children:[
                Expanded(child:Text(edu.kategori.toUpperCase(),
                    style:GoogleFonts.inter(fontSize:10,color:Colors.white70,
                        fontWeight:FontWeight.w700))),
                IconButton(onPressed:()=>Navigator.pop(context),
                    icon:Icon(Icons.close,color:Colors.white70,size:20)),
              ]),
              Text(edu.judul,style:GoogleFonts.inter(fontSize:15,
                  fontWeight:FontWeight.w800,color:Colors.white)),
              SizedBox(height:4),
              Row(children:[
                Icon(Icons.timer_outlined,size:12,color:Colors.white60),
                SizedBox(width:4),
                Text(edu.durasi,style:GoogleFonts.inter(fontSize:11,color:Colors.white70)),
                SizedBox(width:12),
                Icon(Icons.visibility_outlined,size:12,color:Colors.white60),
                SizedBox(width:4),
                Text('${edu.views} dilihat',style:GoogleFonts.inter(
                    fontSize:11,color:Colors.white70)),
              ]),
            ]),
          ),
          Expanded(child:SingleChildScrollView(
            padding:EdgeInsets.all(20),
            child:Text(edu.isi.isEmpty?'Konten belum tersedia.':edu.isi,
                style:GoogleFonts.inter(fontSize:13,color:AppColors.textDark,height:1.6)),
          )),
          Padding(padding:EdgeInsets.fromLTRB(20,0,20,16),child:Row(children:[
            CCButton(label:'🖨  Cetak Materi',color:clr,onPressed:(){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:Text("Materi '${edu.judul}' dicetak"),
                  backgroundColor:clr));
            }),
            SizedBox(width:8),
            CCButton(label:'Tutup',outline:true,color:AppColors.sage,
                textColor:AppColors.sage,onPressed:()=>Navigator.pop(context)),
          ])),
        ]),
      ),
    ));
  }

  void _showTambahDialog(BuildContext context) {
    final state  = context.read<AppState>();
    final cJudul = TextEditingController();
    final cDur   = TextEditingController(text:'5 mnt');
    final cIsi   = TextEditingController();
    String vKat  = 'Pengenalan TBC';

    showDialog(context:context, builder:(ctx)=>StatefulBuilder(
      builder:(ctx,setSt)=>CCDialog(
        title:'Tambah Konten Edukasi',
        content:Column(mainAxisSize:MainAxisSize.min, children:[
          LabeledField(label:'Judul *', controller:cJudul),
          LabeledDropdown(label:'Kategori', value:vKat,
              items:const ['Pengenalan TBC','Pengobatan','Pencegahan','Nutrisi','Kepatuhan'],
              onChanged:(v)=>setSt(()=>vKat=v!)),
          LabeledField(label:'Durasi Baca', controller:cDur),
          LabeledField(label:'Isi Materi', controller:cIsi, maxLines:4),
        ]),
        actions:[
          CCButton(label:'Batal',outline:true,color:AppColors.sage,
              textColor:AppColors.sage,onPressed:()=>Navigator.pop(ctx)),
          CCButton(label:'Simpan',onPressed:() async {
            if(cJudul.text.trim().isEmpty){
              ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content:Text('Judul tidak boleh kosong')));
              return;
            }
            
            // PENAMBAHAN ID GENERATE & AWAIT DI SINI
            await state.addEdukasi(KontenEdukasi(
                id: 'E-${DateTime.now().millisecondsSinceEpoch}',
                judul:cJudul.text.trim(), kategori:vKat,
                durasi:cDur.text.trim().isEmpty?'5 mnt':cDur.text.trim(),
                views:0, isi:cIsi.text.trim()));
                
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:Text('Konten edukasi ditambahkan'),
                backgroundColor:AppColors.green));
          }),
        ],
      ),
    ));
  }

  void _showEditDialog(BuildContext context, KontenEdukasi edu) {
    final state  = context.read<AppState>();
    final cJudul = TextEditingController(text:edu.judul);
    final cDur   = TextEditingController(text:edu.durasi);
    final cIsi   = TextEditingController(text:edu.isi);
    String vKat  = edu.kategori;

    showDialog(context:context, builder:(ctx)=>StatefulBuilder(
      builder:(ctx,setSt)=>CCDialog(
        title:'Edit Konten Edukasi',
        content:Column(mainAxisSize:MainAxisSize.min, children:[
          LabeledField(label:'Judul *', controller:cJudul),
          LabeledDropdown(label:'Kategori', value:vKat,
              items:const ['Pengenalan TBC','Pengobatan','Pencegahan','Nutrisi','Kepatuhan'],
              onChanged:(v)=>setSt(()=>vKat=v!)),
          LabeledField(label:'Durasi Baca', controller:cDur),
          LabeledField(label:'Isi Materi', controller:cIsi, maxLines:4),
        ]),
        actions:[
          CCButton(label:'Batal',outline:true,color:AppColors.sage,
              textColor:AppColors.sage,onPressed:()=>Navigator.pop(ctx)),
          CCButton(label:'Simpan',onPressed:() async {
            if(cJudul.text.trim().isEmpty){
              ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content:Text('Judul tidak boleh kosong')));
              return;
            }
            
            // PENAMBAHAN AWAIT DI SINI
            await state.updateEdukasi(edu, cJudul.text.trim(), vKat,
                cDur.text.trim(), cIsi.text.trim());
                
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:Text('Konten edukasi diperbarui'),
                backgroundColor:AppColors.green));
          }),
        ],
      ),
    ));
  }
}