import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:test_app/app_logic/riverpod_account.dart';

import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/app_logic/riverpod_calculation.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:open_file/open_file.dart';



class ProductDetailForm extends ConsumerStatefulWidget {
  final Product productId;

  const ProductDetailForm({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailForm> createState() =>
      _ProductDetailFormState();
}

class _ProductDetailFormState
    extends ConsumerState<ProductDetailForm> {
  final _descriptionController = TextEditingController();
  final _functionalUnitController = TextEditingController();
  final _declarationsController = TextEditingController();

  bool allocationApplied = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _functionalUnitController.dispose();
    _declarationsController.dispose();
    super.dispose();
  }

  // ===================== HELPERS =====================

  Widget _textField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Apptheme.textclrdark),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: Apptheme.textclrdark),
          filled: true,
          fillColor: Apptheme.widgetsecondaryclr,
        ),
      ),
    );
  }

  Widget _emissionRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  TextStyle(color: Apptheme.textclrdark)),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              color: Apptheme.textclrdark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportExcel() async {
    final part = ref.read(activePartProvider);
    if (part == null) return;

    final emissionTotals =
        ref.read(emissionTotalsProvider((widget.productId.name, part)));
    final materialRows =
        ref.read(emissionRowsProvider((widget.productId.name, part)));

    final excel = Excel.createExcel();
    const sheetName = 'Summary';

    void writeRow(int rowIndex, List<dynamic> values) {
      for (var col = 0; col < values.length; col++) {
        final value = values[col];
        final cellValue = value is num
            ? DoubleCellValue(value.toDouble())
            : TextCellValue(value.toString());

        excel.updateCell(
          sheetName,
          CellIndex.indexByColumnRow(
            columnIndex: col,
            rowIndex: rowIndex,
          ),
          cellValue,
        );
      }
    }

    int row = 0;

    writeRow(row++, ['Product Description', _descriptionController.text]);
    writeRow(row++, ['Functional Unit', _functionalUnitController.text]);
    writeRow(row++, ['Declarations', _declarationsController.text]);
    writeRow(row++, [
      'Allocation',
      allocationApplied ? 'NOT ALIGNED WITH STANDARD' : 'None'
    ]);

    row++;

    writeRow(row++, ['Scope', 'kg CO₂e']);
    writeRow(row++, ['Scope 1', 0]);
    writeRow(row++, ['Scope 2', emissionTotals.machining]);
    writeRow(row++, [
      'Scope 3 Purchased goods & services',
      emissionTotals.material
    ]);
    writeRow(row++, [
      'Scope 3 Upstream transportation',
      emissionTotals.transport
    ]);
    writeRow(row++, [
      'Scope 3 Waste generated',
      emissionTotals.waste
    ]);
    writeRow(row++, [
      'Scope 3 Use of sold products',
      emissionTotals.usageCycle
    ]);
    writeRow(row++, [
      'Scope 3 End-of-life treatment',
      emissionTotals.endofLife
    ]);

    row++;

    writeRow(row++, ['Material', 'Normal', 'Custom']);
    for (var i = 0; i < materialRows.length; i++) {
      final r = materialRows[i];
      writeRow(row++, [
        'Material ${i + 1}',
        r.materialNormal,
        r.material,
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) return;

    final dir = await getDownloadsDirectory();
    if (dir == null) return;

    final file = File(
      '${dir.path}/Product_${widget.productId}.xlsx',
    );

    await file.writeAsBytes(bytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Excel saved to Downloads')),
    );
  }

Future<void> _exportPdf() async {
  final product = ref.read(activeProductProvider);
  final timeline = ref.read(activeTimelineProvider);
  if (product == null || timeline == null) return;

  final allParts = ref.read(partsProvider);
  if (allParts.isEmpty) return;

  final pdf = pw.Document();

  // ---------------- STYLES ----------------
  final baseStyle = pw.TextStyle(fontSize: 9);
  final boldStyle = pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
  final titleStyle = pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold);
  final smallHeader = pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);

  final secondaryColor = PdfColor.fromInt(Apptheme.widgetsecondaryclr.value);
  final tertiaryColor = PdfColor.fromInt(Apptheme.widgettertiaryclr.value);

  // ---------------- HELPERS ----------------
  pw.Widget labelRow(String label, String value) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label, style: baseStyle),
            pw.Text(value, style: baseStyle),
          ],
        ),
      );

  pw.Widget compactValueRow(String label, double value, {PdfColor? color}) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 1),
        child: pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          decoration: color != null
              ? pw.BoxDecoration(
                  color: color,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                )
              : null,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(label,
                  style: baseStyle.copyWith(color: color != null ? PdfColors.white : null)),
              pw.Text(value.toStringAsFixed(2),
                  style: boldStyle.copyWith(color: color != null ? PdfColors.white : null)),
            ],
          ),
        ),
      );

  pw.Widget lifecycleBoundaryBox() => pw.Container(
        padding: const pw.EdgeInsets.all(6),
        decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.8)),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("System Boundary Definition", style: smallHeader),
            pw.SizedBox(height: 4),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(4),
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 0.5), color: secondaryColor),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Cradle-to-Gate (Stage A)",
                            style: boldStyle.copyWith(color: PdfColors.white)),
                        pw.Text("A1  Raw Material Supply",
                            style: baseStyle.copyWith(color: PdfColors.white)),
                        pw.Text("A2  Transport to Manufacturer",
                            style: baseStyle.copyWith(color: PdfColors.white)),
                        pw.Text("A3  Manufacturing & Waste",
                            style: baseStyle.copyWith(color: PdfColors.white)),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 6),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(4),
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 0.5), color: tertiaryColor),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Cradle-to-Grave (Stages B & C)",
                            style: boldStyle.copyWith(color: PdfColors.white)),
                        pw.Text("B1–B7 – Use Phase",
                            style: baseStyle.copyWith(color: PdfColors.white)),
                        pw.Text("C1–C4 – End of Life",
                            style: baseStyle.copyWith(color: PdfColors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  pw.Widget compactTable(List<String> headers, List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.3),
      columnWidths: {for (int i = 0; i < headers.length; i++) i: const pw.FlexColumnWidth()},
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: headers
              .map((h) => pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text(h, style: boldStyle),
                  ))
              .toList(),
        ),
        ...rows.map((r) => pw.TableRow(
              children: r
                  .map((c) => pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(c, style: baseStyle),
                      ))
                  .toList(),
            )),
      ],
    );
  }

  pw.Widget buildPartTables(WidgetRef ref, TableKey partKey) {
    final materialTable = ref.read(normalMaterialTableProvider(partKey));
    final transportTable = ref.read(upstreamTransportTableProvider(partKey));
    final machiningTable = ref.read(machiningTableProvider(partKey));

    final materialRows = List.generate(
        materialTable.normalMaterials.length,
        (i) => [materialTable.normalMaterials[i] ?? '', materialTable.masses[i] ?? '']);

    final transportRows = List.generate(
        transportTable.vehicles.length,
        (i) => [
              transportTable.classes[i] ?? '',
              transportTable.vehicles[i] ?? '',
              transportTable.distances[i] ?? '',
              transportTable.masses[i] ?? ''
            ]);

    final machiningRows = List.generate(
        machiningTable.machines.length,
        (i) => [machiningTable.brands[i] ?? '', machiningTable.machines[i] ?? '', machiningTable.times[i] ?? '']);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("Materials", style: smallHeader),
        compactTable(["Material", "Weight (kg)"], materialRows),
        pw.SizedBox(height: 6),
        pw.Text("Upstream Transport", style: smallHeader),
        compactTable(["Class", "Vehicle", "Distance (km)", "Mass (kg)"], transportRows),
        pw.SizedBox(height: 6),
        pw.Text("Machining", style: smallHeader),
        compactTable(["Brand", "Machine", "Operating Time (hr)"], machiningRows),
      ],
    );
  }

  // ---------------- TOTAL EMISSIONS & PERCENTAGES ----------------
  final totalEmissions = <String, double>{};
  double grandTotal = 0;
  for (final part in allParts) {
    final totals = ref.read(convertedEmissionsTotalProvider((product, part)));
    totalEmissions[part] = totals.total;
    grandTotal += totals.total;
  }

  // ---------------- FIRST PAGE ----------------
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(18),
      build: (_) => [
        pw.Text('Product Carbon Footprint Report', style: titleStyle),
        pw.SizedBox(height: 6),
        labelRow("Product", product.name),
        labelRow("Functional Unit", _functionalUnitController.text),
        labelRow("Description", _descriptionController.text),
        pw.SizedBox(height: 8),
        lifecycleBoundaryBox(),
        pw.SizedBox(height: 8),
        pw.Text("Total Emissions by Part (kg CO₂e)", style: smallHeader),
        pw.SizedBox(height: 4),

        // ---------------- PER-PART TABLE WITH PERCENTAGE ----------------
        compactTable(
          ["Part", "Emissions (kg CO₂e)", "Percentage"],
          totalEmissions.entries.map((e) {
            final pct = grandTotal > 0 ? e.value / grandTotal * 100 : 0;
            return [e.key, e.value.toStringAsFixed(2), "${pct.toStringAsFixed(1)} %"];
          }).toList(),
        ),
      ],
    ),
  );

  // ---------------- PER-PART DETAIL PAGES ----------------
  for (final part in allParts) {
    final totals = ref.read(convertedEmissionsTotalProvider((product, part)));
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18),
        build: (_) => [
          pw.Text("Part: $part", style: titleStyle),
          pw.SizedBox(height: 6),
          compactValueRow("Total Emissions (kg CO₂e)", totals.total, color: tertiaryColor),
          pw.SizedBox(height: 6),
          pw.Text("Lifecycle Breakdown (A/B/C)", style: smallHeader),
          pw.SizedBox(height: 2),
          compactValueRow(
              "A1–A3 (Cradle-to-Gate)",
              totals.material + totals.materialNormal + totals.transport + totals.machining + totals.waste,
              color: secondaryColor),
          compactValueRow("B Stage (Use Phase)", totals.usageCycle, color: tertiaryColor),
          compactValueRow("C Stage (End of Life)", totals.endofLife, color: tertiaryColor),
          pw.SizedBox(height: 6),
          buildPartTables(ref, (product: product.name, part: part)),
        ],
      ),
    );
  }

  // ---------------- SAVE FILE ----------------
  final pdfBytes = await pdf.save();
  final file = File('Product_${product.name}.pdf');
  await file.writeAsBytes(pdfBytes);
  await OpenFile.open(file.path);
  debugPrint("[_exportPdf] Saved -> ${file.path}");
}

  // ===================== UI =====================

  

@override
Widget build(BuildContext context) {
  final part = ref.watch(activePartProvider);
  if (part == null) return const SizedBox();

  final emissionTotals = ref.watch(convertedEmissionsTotalProvider((widget.productId, part)));

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textField('Product Description', _descriptionController),
        _textField('Functional Unit', _functionalUnitController),
        _textField('Declarations', _declarationsController),

        const SizedBox(height: 16),

        Row(
          children: [
            Text('Allocation Applied?', style: TextStyle(color: Apptheme.textclrdark)),
            const SizedBox(width: 16),
            Switch(
              value: allocationApplied,
              onChanged: (val) {
                setState(() {
                  allocationApplied = val;
                });
              },
              activeColor: Apptheme.widgetsecondaryclr,
            ),
          ],
        ),

        const SizedBox(height: 24),

        Labels(
          title: 'Emissions (kg CO₂e)',
          color: Apptheme.textclrdark,
        ),
        const SizedBox(height: 8),

        _emissionRow('Scope 1', 0),
        _emissionRow('Scope 2', emissionTotals.machining),
        _emissionRow('Purchased Goods', emissionTotals.material + emissionTotals.materialNormal),
        _emissionRow('Upstream Transport', emissionTotals.transport),
        _emissionRow('Waste', emissionTotals.waste),
        _emissionRow('Use Phase', emissionTotals.usageCycle),
        _emissionRow('End of Life', emissionTotals.endofLife),

        const SizedBox(height: 16),

        // ✅ Display total by part
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Apptheme.widgetsecondaryclr.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Total Emissions for $part: ${emissionTotals.total.toStringAsFixed(2)} kg CO₂e',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Apptheme.textclrdark,
            ),
          ),
        ),

        const SizedBox(height: 24),

        Center(
          child: Wrap(
            spacing: 16,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Export Excel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Apptheme.widgetsecondaryclr,
                  foregroundColor: Apptheme.textclrdark,
                ),
                onPressed: _exportExcel,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Export PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Apptheme.widgetsecondaryclr,
                  foregroundColor: Apptheme.textclrdark,
                ),
                onPressed: _exportPdf,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}






