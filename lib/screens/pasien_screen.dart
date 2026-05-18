// lib/screens/pasien_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class PasienScreen extends StatefulWidget {
  const PasienScreen({super.key});
  @override State<PasienScreen> createState() => _PasienScreenState();
}
class _PasienScreenState extends State<PasienScreen> {
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final query = _search.text.toLowerCase();
    final shown = state.filteredPasien.where((px) =>
        query.isEmpty ||
        px.nama.toLowerCase().contains(query) ||
        px.id.toLowerCase().contains(query)).toList();

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          // Header
          Row(children:[
            Text('Manajemen Data Pasien TBC',
                style:GoogleFonts.inter(fontSize:15,fontWeight:FontWeight.w800,
                    color:AppColors.textDark)),
            Spacer(),
            CCButton(label:'Tambah Pasien',icon:Icons.add,
                onPressed:()=>_showTambahDialog(context)),
          ]),
          SizedBox(height:12),
          // Filter bar
          Row(children:[
            SizedBox(width:260,
                child:TextField(
                  controller:_search,
                  style:GoogleFonts.inter(fontSize:12),
                  onChanged:(_)=>setState((){}),
                  decoration:InputDecoration(
                      hintText:'Cari nama / ID pasien…',
                      prefixIcon:Icon(Icons.search,size:16),
                      isDense:true),
                )),
            SizedBox(width:12),
            FilterChipRow(
                options:['Semua Status','Dalam Terapi','Putus Obat','Selesai'],
                selected:state.filterPasien,
                onSelect:(v){state.filterPasien=v; state.notifyListeners();}),
          ]),
          SizedBox(height:12),
          // Table
          Expanded(child: Card(
            child: SingleChildScrollView(
              child: Column(children:[
                _tableHeader(),
                ...shown.asMap().entries.map((e) => _tableRow(context, e.value, e.key)),
              ]),
            ),
          )),
        ]),
      ),
    );
  }

  Widget _tableHeader() => Container(
    padding: EdgeInsets.symmetric(horizontal:12, vertical:10),
    decoration: BoxDecoration(
        color:AppColors.ivory,
        borderRadius:BorderRadius.vertical(top:Radius.circular(12))),
    child: Row(children:[
      for(var (lbl,w) in [('ID',90),('Nama',140),('Usia',50),('Diagnosa',160),
        ('Fase',120),('Kep.',70),('Status',100),('Risiko',80)])
        SizedBox(width:w.toDouble(),
            child:Text(lbl,style:GoogleFonts.inter(fontSize:10,
                fontWeight:FontWeight.w700,color:AppColors.textMid))),
      SizedBox(width:80,child:Text('Aksi',style:GoogleFonts.inter(fontSize:10,
          fontWeight:FontWeight.w700,color:AppColors.textMid))),
    ]),
  );

  Widget _tableRow(BuildContext context, Pasien px, int idx) {
    final clr = px.status=='Putus Obat' ? AppColors.blood
        : px.status=='Selesai' ? AppColors.green : AppColors.textDark;
    return Column(children:[
      Divider(height:1,color:AppColors.border),
      InkWell(
        onTap:()=>_showDetailDialog(context, px),
        child:Container(
          padding:EdgeInsets.symmetric(horizontal:12,vertical:10),
          child:Row(children:[
            SizedBox(width:90,child:Text(px.id,
                style:GoogleFonts.inter(fontSize:10,color:AppColors.textLight),
                overflow:TextOverflow.ellipsis)),
            SizedBox(width:140,child:Text(px.nama,
                style:GoogleFonts.inter(fontSize:11,fontWeight:FontWeight.w600,color:clr),
                overflow:TextOverflow.ellipsis)),
            SizedBox(width:50,child:Text('${px.umur} th',
                style:GoogleFonts.inter(fontSize:11,color:AppColors.textMid))),
            SizedBox(width:160,child:Text(px.diagnosa,
                style:GoogleFonts.inter(fontSize:10,color:AppColors.textMid),
                overflow:TextOverflow.ellipsis)),
            SizedBox(width:120,child:Text(px.fase,
                style:GoogleFonts.inter(fontSize:10,color:AppColors.textMid),
                overflow:TextOverflow.ellipsis)),
            SizedBox(width:70,child:Text('${px.kepatuhan}%',
                style:GoogleFonts.inter(fontSize:11,
                    fontWeight:FontWeight.w600,
                    color:px.kepatuhan>=85?AppColors.green:
                    px.kepatuhan>=70?AppColors.yellow:AppColors.blood))),
            SizedBox(width:100,child:StatusBadge(px.status,
                color:px.status=='Putus Obat'?AppColors.blood:
                px.status=='Selesai'?AppColors.green:AppColors.evergreen)),
            SizedBox(width:80,child:RiskBadge(px.risiko)),
            SizedBox(width:80,child:Row(children:[
              IconButton(icon:Icon(Icons.edit,size:16,color:AppColors.evergreen),
                  onPressed:()=>_showEditDialog(context,px)),
              IconButton(icon:Icon(Icons.delete,size:16,color:AppColors.blood),
                  onPressed:()=>_confirmDelete(context,px)),
            ])),
          ]),
        ),
      ),
    ]);
  }

  void _showTambahDialog(BuildContext context) {
    final state = context.read<AppState>();
    final cNama=TextEditingController(), cUmur=TextEditingController(),
          cAlamat=TextEditingController(), cTelp=TextEditingController();
    String vDiag='TBC Paru (Baru)', vDok='dr. Rina Sari',
           vFase='Fase Intensif', vRisiko='Rendah';

    showDialog(context:context, builder:(ctx)=>StatefulBuilder(
      builder:(ctx,setSt)=>CCDialog(
        title:'Tambah Pasien Baru',
        content:Column(mainAxisSize:MainAxisSize.min, children:[
          LabeledField(label:'Nama Lengkap *', controller:cNama),
          LabeledField(label:'Usia (tahun) *', controller:cUmur,
              keyboardType:TextInputType.number),
          LabeledField(label:'No. Telepon', controller:cTelp,
              keyboardType:TextInputType.phone),
          LabeledField(label:'Alamat', controller:cAlamat),
          LabeledDropdown(label:'Diagnosa *', value:vDiag,
              items:['TBC Paru (Baru)','TBC Paru (Kambuh)','TBC Ekstra Paru',
                     'TBC + HIV Komorbid','MDR-TBC'],
              onChanged:(v)=>setSt(()=>vDiag=v!)),
          LabeledDropdown(label:'Dokter', value:vDok,
              items:['dr. Rina Sari','dr. Budi Santoso','dr. Samuel Wenas'],
              onChanged:(v)=>setSt(()=>vDok=v!)),
          LabeledDropdown(label:'Fase Terapi', value:vFase,
              items:['Fase Intensif','Fase Lanjutan','Kambuh'],
              onChanged:(v)=>setSt(()=>vFase=v!)),
          LabeledDropdown(label:'Risiko', value:vRisiko,
              items:['Rendah','Sedang','Tinggi','KRITIS'],
              onChanged:(v)=>setSt(()=>vRisiko=v!)),
        ]),
        actions:[
          CCButton(label:'Batal', outline:true, color:AppColors.sage,
              textColor:AppColors.sage, onPressed:()=>Navigator.pop(ctx)),
          CCButton(label:'Simpan', onPressed:(){
            final nama=cNama.text.trim();
            final umur=int.tryParse(cUmur.text.trim())??0;
            if(nama.isEmpty||umur==0){
              ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content:Text('Nama & usia wajib diisi')));
              return;
            }
            final id=state.nextPasienId();
            state.addPasien(Pasien(id:id,nama:nama,umur:umur,fase:vFase,hari:0,
                kepatuhan:0,status:'Dalam Terapi',dahak:'Bening',kontrol:'-',
                risiko:vRisiko,diagnosa:vDiag,dokter:vDok,alamat:cAlamat.text.trim(),
                telp:cTelp.text.trim(),noRm:id));
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:Text('Pasien $nama berhasil ditambahkan'),
                    backgroundColor:AppColors.green));
          }),
        ],
      ),
    ));
  }

  void _showDetailDialog(BuildContext context, Pasien px) {
    final clr = AppColors.riskColor(px.risiko);
    final blt = AppColors.riskLightColor(px.risiko);
    showDialog(context:context, builder:(_)=>CCDialog(
      title:'Detail Pasien',
      content:Column(mainAxisSize:MainAxisSize.min, children:[
        Container(
          padding:EdgeInsets.all(16),
          decoration:BoxDecoration(color:blt,borderRadius:BorderRadius.circular(12)),
          child:Row(children:[
            AvatarInitials(name:px.nama,bgColor:clr,textColor:Colors.white,size:48),
            SizedBox(width:12),
            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text(px.nama,style:GoogleFonts.inter(fontSize:15,fontWeight:FontWeight.w800,
                  color:AppColors.textDark)),
              Text('${px.id}  ·  ${px.noRm}',
                  style:GoogleFonts.inter(fontSize:10,color:AppColors.textMid)),
              SizedBox(height:4),
              RiskBadge(px.risiko),
            ])),
          ]),
        ),
        SizedBox(height:12),
        for(var (k,v) in [
          ('Usia','${px.umur} tahun'),('Telepon',px.telp.isEmpty?'-':px.telp),
          ('Alamat',px.alamat),('Diagnosa',px.diagnosa),
          ('Fase',px.fase),('Hari ke-','${px.hari}'),
          ('Kepatuhan','${px.kepatuhan}%'),('Dokter',px.dokter),
          ('Status',px.status),('Warna Dahak',px.dahak),
        ])
          Padding(padding:EdgeInsets.only(bottom:6),
              child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
                SizedBox(width:110,child:Text('$k:',style:GoogleFonts.inter(
                    fontSize:11,fontWeight:FontWeight.w600,color:AppColors.textMid))),
                Expanded(child:Text(v,style:GoogleFonts.inter(fontSize:11,
                    color:AppColors.textDark))),
              ])),
      ]),
      actions:[
        CCButton(label:'Edit', outline:true, color:AppColors.evergreen,
            textColor:AppColors.evergreen, icon:Icons.edit, onPressed:(){
          Navigator.pop(context);
          _showEditDialog(context, px);
        }),
        CCButton(label:'Hapus', color:AppColors.blood, icon:Icons.delete,
            onPressed:(){Navigator.pop(context);_confirmDelete(context,px);}),
        CCButton(label:'Tutup', outline:true, color:AppColors.sage,
            textColor:AppColors.textMid, onPressed:()=>Navigator.pop(context)),
      ],
    ));
  }

  void _showEditDialog(BuildContext context, Pasien px) {
    final state=context.read<AppState>();
    final cNama=TextEditingController(text:px.nama);
    final cUmur=TextEditingController(text:'${px.umur}');
    final cAlamat=TextEditingController(text:px.alamat);
    final cTelp=TextEditingController(text:px.telp);
    String vStatus=px.status, vRisiko=px.risiko;
    showDialog(context:context, builder:(ctx)=>StatefulBuilder(
      builder:(ctx,setSt)=>CCDialog(
        title:'Edit Data Pasien',
        content:Column(mainAxisSize:MainAxisSize.min,children:[
          LabeledField(label:'Nama',controller:cNama),
          LabeledField(label:'Usia',controller:cUmur,keyboardType:TextInputType.number),
          LabeledField(label:'Telepon',controller:cTelp),
          LabeledField(label:'Alamat',controller:cAlamat),
          LabeledDropdown(label:'Status',value:vStatus,
              items:['Dalam Terapi','Putus Obat','Selesai'],
              onChanged:(v)=>setSt(()=>vStatus=v!)),
          LabeledDropdown(label:'Risiko',value:vRisiko,
              items:['Rendah','Sedang','Tinggi','KRITIS'],
              onChanged:(v)=>setSt(()=>vRisiko=v!)),
        ]),
        actions:[
          CCButton(label:'Batal',outline:true,color:AppColors.sage,
              textColor:AppColors.sage,onPressed:()=>Navigator.pop(ctx)),
          CCButton(label:'Simpan',onPressed:(){
            px.nama=cNama.text.trim();
            px.umur=int.tryParse(cUmur.text.trim())??px.umur;
            px.alamat=cAlamat.text.trim();
            px.telp=cTelp.text.trim();
            px.status=vStatus; px.risiko=vRisiko;
            state.updatePasien(px);
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:Text('Data ${px.nama} diperbarui'),
                    backgroundColor:AppColors.green));
          }),
        ],
      ),
    ));
  }

  void _confirmDelete(BuildContext context, Pasien px) {
    final state=context.read<AppState>();
    showDialog(context:context, builder:(_)=>AlertDialog(
      title:Text('Hapus Pasien?'),
      content:Text('Data ${px.nama} akan dihapus permanen.'),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context),child:Text('Batal')),
        ElevatedButton(
          style:ElevatedButton.styleFrom(backgroundColor:AppColors.blood),
          onPressed:(){
            state.deletePasien(px.id);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:Text('${px.nama} dihapus'),
                    backgroundColor:AppColors.blood));
          },
          child:Text('Hapus'),
        ),
      ],
    ));
  }
}
