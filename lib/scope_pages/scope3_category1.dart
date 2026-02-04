import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/app_logic/riverpod_calculation.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:open_file/open_file.dart';



class ProductDetailForm extends ConsumerStatefulWidget {
  final String productId;

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
        ref.read(emissionTotalsProvider((widget.productId, part)));
    final materialRows =
        ref.read(emissionRowsProvider((widget.productId, part)));

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

  if (product == null || timeline == null) {
    debugPrint("[_exportPdf] No active product or timeline.");
    return;
  }

  final allParts = ref.read(partsProvider);
  if (allParts.isEmpty) {
    debugPrint("[_exportPdf] No parts to export.");
    return;
  }

  final pdf = pw.Document();

  // ---------------- HELPERS ----------------

  pw.Widget labelRow(String label, String value) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(value),
          ],
        ),
      );

  pw.Widget coloredBoxRow(String label, double value, PdfColor color) =>
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const pw.EdgeInsets.symmetric(vertical: 4),
        decoration: pw.BoxDecoration(
          color: color,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              value.toStringAsFixed(2),
              style: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  pw.Widget sectionTitle(String text) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8),
        child: pw.Text(
          text,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      );

  pw.Widget simpleTable(List<String> headers, List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: headers
              .map(
                (h) => pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text(
                    h,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              )
              .toList(),
        ),
        ...rows.map(
          (r) => pw.TableRow(
            children: r
                .map(
                  (c) => pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(c),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  pw.Widget buildPartTables(WidgetRef ref, TableKey partKey) {
    final materialTable = ref.read(normalMaterialTableProvider(partKey));
    final transportTable =
        ref.read(upstreamTransportTableProvider(partKey));
    final machiningTable = ref.read(machiningTableProvider(partKey));

    final materialRows = List.generate(
      materialTable.normalMaterials.length,
      (i) => [
        materialTable.normalMaterials[i] ?? '',
        materialTable.masses[i] ?? '',
      ],
    );

    final transportRows = List.generate(
      transportTable.vehicles.length,
      (i) => [
        transportTable.vehicles[i] ?? '',
        transportTable.classes[i] ?? '',
        transportTable.distances[i] ?? '',
        transportTable.masses[i] ?? '',
      ],
    );

    final machiningRows = List.generate(
      machiningTable.machines.length,
      (i) => [
        machiningTable.brands[i] ?? '',
        machiningTable.machines[i] ?? '',
        machiningTable.times[i] ?? '',
      ],
    );

    debugPrint(
      "[buildPartTables] $partKey -> "
      "materials=${materialRows.length}, "
      "transport=${transportRows.length}, "
      "machining=${machiningRows.length}",
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        sectionTitle("Materials"),
        simpleTable(
          ["Material", "Weight (kg)"],
          materialRows,
        ),
        pw.SizedBox(height: 16),
        sectionTitle("Upstream Transport"),
        simpleTable(
          ["Class", "Vehicle", "Distance (km)", "Mass (kg)"],
          transportRows,
        ),
        pw.SizedBox(height: 16),
        sectionTitle("Machining"),
        simpleTable(
          ["Brand", "Machine", "Operating Time (hr)"],
          machiningRows,
        ),
      ],
    );
  }

  final stageColors = {
    'Scope 1': PdfColors.red,
    'Scope 2': PdfColors.orange,
    'Purchased Goods': PdfColors.blue,
    'Transport': PdfColors.green,
    'Waste': PdfColors.purple,
    'Use Phase': PdfColors.teal,
    'End of Life': PdfColors.grey,
  };

  // ---------------- SUMMARY PAGE ----------------

  final totalEmissions = <String, double>{};

  for (final part in allParts) {
    final totals = ref.read(emissionTotalsProvider((product.name, part)));

    final partTotal = totals.machining +
        totals.material +
        totals.transport +
        totals.waste +
        totals.usageCycle +
        totals.endofLife;

    totalEmissions[part] = partTotal;

    debugPrint(
      "[_exportPdf] $part totals -> "
      "machining=${totals.machining}, "
      "material=${totals.material}, "
      "transport=${totals.transport}, "
      "waste=${totals.waste}, "
      "use=${totals.usageCycle}, "
      "eol=${totals.endofLife}, "
      "TOTAL=$partTotal",
    );
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (_) => [
        pw.Text(
          'Product Emissions Summary',
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 16),
        labelRow('Product ID', product.name),
        labelRow('Description', _descriptionController.text),
        labelRow('Functional Unit', _functionalUnitController.text),
        labelRow('Declarations', _declarationsController.text),
        labelRow(
          'Allocation',
          allocationApplied ? 'NOT ALIGNED WITH STANDARD' : 'None',
        ),
        pw.Divider(),
        pw.Text(
          'Total Emissions by Part (kg CO₂e)',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        ...totalEmissions.entries.map(
          (e) => coloredBoxRow(e.key, e.value, PdfColors.blue),
        ),
      ],
    ),
  );

  // ---------------- PER PART PAGES ----------------

  for (final part in allParts) {
    final totals = ref.read(emissionTotalsProvider((product.name, part)));

    final breakdown = {
      'Scope 1': totals.machining,
      'Scope 2': 0.0,
      'Purchased Goods': totals.materialNormal + totals.material,
      'Transport': totals.transport + totals.downstreamTransport + totals.productionTransport,
      'Waste': totals.waste,
      'Use Phase': totals.usageCycle,
      'End of Life': totals.endofLife,
    };

pdf.addPage(
  pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(32),
    build: (_) => [
      pw.Text(
        'Part: $part',
        style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 12),
      pw.Text(
        'Total Emissions (kg CO₂e)',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
      coloredBoxRow('Total', totals.total, PdfColors.black),
      pw.SizedBox(height: 16),
      pw.Text(
        'Emission Breakdown by Life Cycle Stage',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
      ...breakdown.entries.map(
        (e) => coloredBoxRow(e.key, e.value, stageColors[e.key]!),
      ),
      pw.Divider(),

      buildPartTables(
        ref,
        (product: product.name, part: part)
      ),
    ],
  ),
);

    
  }

  

  // ---------------- SAVE FILE ----------------

  final pdfBytes = await pdf.save();
  final file = File('Product_$product.pdf');

  await file.writeAsBytes(pdfBytes);
  debugPrint("[_exportPdf] Saved -> ${file.path}");

  await OpenFile.open(file.path);
}


  // ===================== UI =====================

  

@override
Widget build(BuildContext context) {
  final part = ref.watch(activePartProvider);
  if (part == null) return const SizedBox();

  final emissionTotals = ref.watch(emissionTotalsProvider((widget.productId, part)));

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

        _emissionRow('Scope 1', emissionTotals.machining),
        _emissionRow('Scope 2', 0),
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
