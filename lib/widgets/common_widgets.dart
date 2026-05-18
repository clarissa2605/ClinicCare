// lib/widgets/common_widgets.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ── Stat Card ─────────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final String trend;
  final Color  color;

  const StatCard({super.key,
    required this.label, required this.value, required this.sub,
    required this.trend, required this.color});

  @override
  Widget build(BuildContext context) {
    final trendColor = trend.startsWith('+') ? AppColors.green : AppColors.blood;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 3, decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)))),
          Padding(
            padding: EdgeInsets.fromLTRB(14,10,14,12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label.toUpperCase(),
                  style: GoogleFonts.inter(fontSize:10, color:AppColors.textLight,
                      fontWeight:FontWeight.w600)),
              SizedBox(height:4),
              Text(value, style: GoogleFonts.inter(fontSize:26, fontWeight:FontWeight.w800,
                  color:AppColors.textDark)),
              Text(sub, style: GoogleFonts.inter(fontSize:10, color:AppColors.textMid)),
              SizedBox(height:4),
              Text(trend, style: GoogleFonts.inter(fontSize:10, color:trendColor,
                  fontWeight:FontWeight.w600)),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({super.key,
      required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(title, style: GoogleFonts.inter(
          fontSize:13, fontWeight:FontWeight.w700, color:AppColors.textDark))),
      if (action != null)
        TextButton(onPressed: onAction,
          child: Text(action!,
              style: GoogleFonts.inter(fontSize:11, color:AppColors.evergreen))),
    ]);
  }
}

// ── Risk Badge ────────────────────────────────────────────────────────────────
class RiskBadge extends StatelessWidget {
  final String level;
  const RiskBadge(this.level, {super.key});

  @override
  Widget build(BuildContext context) {
    final clr = AppColors.riskColor(level);
    return Container(
      padding: EdgeInsets.symmetric(horizontal:8, vertical:3),
      decoration: BoxDecoration(color:clr, borderRadius:BorderRadius.circular(8)),
      child: Text(level,
          style: GoogleFonts.inter(fontSize:10, color:Colors.white,
              fontWeight:FontWeight.w700)),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  const StatusBadge(this.text, {super.key, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal:8, vertical:3),
    decoration: BoxDecoration(color:color, borderRadius:BorderRadius.circular(8)),
    child: Text(text,
        style: GoogleFonts.inter(fontSize:10, color:Colors.white,
            fontWeight:FontWeight.w600)));
}

// ── Avatar Initials ───────────────────────────────────────────────────────────
class AvatarInitials extends StatelessWidget {
  final String name;
  final Color  bgColor;
  final Color  textColor;
  final double size;

  const AvatarInitials({super.key,
      required this.name, required this.bgColor,
      required this.textColor, this.size = 36});

  @override
  Widget build(BuildContext context) {
    final parts    = name.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'
        : (parts[0].isNotEmpty ? parts[0][0] : '?');
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(initials.toUpperCase(),
          style: GoogleFonts.inter(fontSize: size * 0.33,
              fontWeight: FontWeight.w700, color: textColor)),
    );
  }
}

// ── Progress Bar ──────────────────────────────────────────────────────────────
class ProgressBar extends StatelessWidget {
  final double value;   // 0.0 – 1.0
  final Color  color;
  final double height;

  const ProgressBar({super.key,
      required this.value, required this.color, this.height = 8});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(height / 2),
    child: LinearProgressIndicator(
      value: value.clamp(0.0, 1.0),
      backgroundColor: AppColors.border,
      valueColor: AlwaysStoppedAnimation<Color>(color),
      minHeight: height,
    ),
  );
}

// ── Info Banner ───────────────────────────────────────────────────────────────
class InfoBanner extends StatelessWidget {
  final String  text;
  final Color   bgColor;
  final Color   textColor;
  final IconData? icon;

  const InfoBanner({super.key,
      required this.text, required this.bgColor, required this.textColor,
      this.icon});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal:14, vertical:10),
    decoration: BoxDecoration(color:bgColor, borderRadius:BorderRadius.circular(10)),
    child: Row(children: [
      if (icon != null) ...[
        Icon(icon, size:16, color:textColor),
        SizedBox(width:8),
      ],
      Expanded(child: Text(text,
          style: GoogleFonts.inter(fontSize:11, color:textColor))),
    ]),
  );
}

// ── CC Button (primary / secondary) ──────────────────────────────────────────
class CCButton extends StatelessWidget {
  final String      label;
  final VoidCallback? onPressed;
  final Color       color;
  final Color       textColor;
  final IconData?   icon;
  final bool        outline;

  const CCButton({super.key,
      required this.label, this.onPressed,
      this.color = AppColors.darkGreen,
      this.textColor = Colors.white,
      this.icon, this.outline = false});

  @override
  Widget build(BuildContext context) {
    final style = outline
        ? OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color),
            padding: EdgeInsets.symmetric(horizontal:16, vertical:10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: GoogleFonts.inter(fontSize:12, fontWeight:FontWeight.w600),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal:16, vertical:10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: GoogleFonts.inter(fontSize:12, fontWeight:FontWeight.w600),
          );

    final child = icon != null
        ? Row(mainAxisSize:MainAxisSize.min, children:[
            Icon(icon, size:15),
            SizedBox(width:6),
            Text(label),
          ])
        : Text(label);

    return outline
        ? OutlinedButton(onPressed:onPressed, style:style, child:child)
        : ElevatedButton(onPressed:onPressed, style:style, child:child);
  }
}

// ── Form Dialog Shell ─────────────────────────────────────────────────────────
class CCDialog extends StatelessWidget {
  final String  title;
  final Widget  content;
  final List<Widget> actions;

  const CCDialog({super.key,
      required this.title, required this.content, required this.actions});

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: AppColors.card,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 500, maxHeight: 700),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 20, 16, 16),
          decoration: BoxDecoration(
            color: AppColors.darkGreen,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(children: [
            Expanded(child: Text(title,
                style: GoogleFonts.inter(fontSize:15, fontWeight:FontWeight.w700,
                    color:Colors.white))),
            IconButton(onPressed:()=>Navigator.pop(context),
                icon:Icon(Icons.close, color:Colors.white70, size:20)),
          ]),
        ),
        // Content
        Flexible(child: SingleChildScrollView(
            padding: EdgeInsets.all(20), child: content)),
        // Actions
        if (actions.isNotEmpty)
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.end,
                children: actions.map((a) => Padding(
                    padding: EdgeInsets.only(left:8), child:a)).toList()),
          ),
      ]),
    ),
  );
}

// ── Labeled TextField ─────────────────────────────────────────────────────────
class LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;

  const LabeledField({super.key,
      required this.label, required this.controller,
      this.hint, this.maxLines=1, this.keyboardType});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom:12),
    child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      Text(label, style: GoogleFonts.inter(
          fontSize:11, fontWeight:FontWeight.w600, color:AppColors.textMid)),
      SizedBox(height:4),
      TextField(
        controller:    controller,
        maxLines:      maxLines,
        keyboardType:  keyboardType,
        style:         GoogleFonts.inter(fontSize:13),
        decoration:    InputDecoration(hintText: hint),
      ),
    ]),
  );
}

// ── Labeled Dropdown ──────────────────────────────────────────────────────────
class LabeledDropdown extends StatelessWidget {
  final String         label;
  final String         value;
  final List<String>   items;
  final ValueChanged<String?> onChanged;

  const LabeledDropdown({super.key,
      required this.label, required this.value,
      required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom:12),
    child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      Text(label, style: GoogleFonts.inter(
          fontSize:11, fontWeight:FontWeight.w600, color:AppColors.textMid)),
      SizedBox(height:4),
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal:12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color:AppColors.border),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            style: GoogleFonts.inter(fontSize:13, color:AppColors.textDark),
            items: items.map((i) => DropdownMenuItem(value:i, child:Text(i))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ]),
  );
}

// ── Data Table Card ───────────────────────────────────────────────────────────
class CCDataTable extends StatelessWidget {
  final List<String>       columns;
  final List<List<String>> rows;
  final List<double>       widths;
  final void Function(int)? onRowTap;
  final List<Color>?       rowColors; // per-row text color overrides

  const CCDataTable({super.key,
      required this.columns, required this.rows,
      required this.widths, this.onRowTap, this.rowColors});

  @override
  Widget build(BuildContext context) => Card(
    child: Column(children:[
      // Header
      Container(
        decoration: BoxDecoration(
          color: AppColors.ivory,
          borderRadius: BorderRadius.vertical(top:Radius.circular(12)),
        ),
        child: _row(columns, isHeader:true),
      ),
      Divider(height:1, color:AppColors.border),
      // Rows
      ...rows.asMap().entries.map((e) {
        final idx = e.key;
        final r   = e.value;
        final clr = rowColors != null && idx < rowColors!.length
            ? rowColors![idx] : AppColors.textDark;
        return InkWell(
          onTap: onRowTap != null ? ()=>onRowTap!(idx) : null,
          child: Column(children:[
            _row(r, color:clr),
            if (idx < rows.length-1) Divider(height:1, color:AppColors.border),
          ]),
        );
      }),
    ]),
  );

  Widget _row(List<String> cells, {bool isHeader=false, Color? color}) =>
    Padding(
      padding: EdgeInsets.symmetric(horizontal:12, vertical:10),
      child: Row(
        children: cells.asMap().entries.map((e) {
          final w = e.key < widths.length ? widths[e.key] : 100.0;
          return SizedBox(
            width: w,
            child: Text(e.value,
              style: GoogleFonts.inter(
                fontSize: isHeader ? 10 : 11,
                fontWeight: isHeader ? FontWeight.w700 : FontWeight.w400,
                color: isHeader ? AppColors.textMid : (color ?? AppColors.textDark),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
}

// ── Filter Chips Row ──────────────────────────────────────────────────────────
class FilterChipRow extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  const FilterChipRow({super.key,
      required this.options, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: options.map((opt) {
        final isAct = opt == selected;
        return Padding(
          padding: EdgeInsets.only(right:8),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onSelect(opt),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:14, vertical:7),
              decoration: BoxDecoration(
                color:  isAct ? AppColors.darkGreen : AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isAct ? AppColors.darkGreen : AppColors.border),
              ),
              child: Text(opt, style: GoogleFonts.inter(
                  fontSize:11, fontWeight:FontWeight.w600,
                  color: isAct ? Colors.white : AppColors.textDark)),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
