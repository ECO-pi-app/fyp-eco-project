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
import 'package:file_selector/file_selector.dart';


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

  final emissionTotals = ref.watch(convertedEmissionsTotalProvider((widget.productId, part)));

  final materialRows =
      ref.read(emissionRowsProvider((widget.productId.name, part)));

  final excel = Excel.createExcel();
  const sheetName = 'Summary';

  final sheet = excel[sheetName];

  /// ---------- STYLES ----------
  final headerStyle = CellStyle(
    bold: true,
    fontSize: 14,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );

  final sectionStyle = CellStyle(
    bold: true,
    fontSize: 12,
  );

  final labelStyle = CellStyle(
    bold: true,
  );

  /// ---------- HELPERS ----------
  void writeCell(int row, int col, dynamic value, {CellStyle? style}) {
    final cellValue = value is num
        ? DoubleCellValue(value.toDouble())
        : TextCellValue(value.toString());

    sheet.updateCell(
      CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
      cellValue,
      cellStyle: style,
    );
  }

  void writeSectionTitle(int row, String title) {
    writeCell(row, 0, title, style: sectionStyle);
  }

  int row = 0;

  /// ---------- TITLE ----------
  writeCell(row++, 0, "PRODUCT EMISSION REPORT", style: headerStyle);
  row++;

  /// ---------- PRODUCT INFO ----------
  writeSectionTitle(row++, "Product Information");

  writeCell(row, 0, "Product Description", style: labelStyle);
  writeCell(row++, 1, _descriptionController.text);

  writeCell(row, 0, "Functional Unit", style: labelStyle);
  writeCell(row++, 1, _functionalUnitController.text);

  writeCell(row, 0, "Declarations", style: labelStyle);
  writeCell(row++, 1, _declarationsController.text);

  writeCell(row, 0, "Allocation", style: labelStyle);
  writeCell(
    row++,
    1,
    allocationApplied ? "NOT ALIGNED WITH STANDARD" : "None",
  );

  row++;

  /// ---------- EMISSION SUMMARY ----------
  writeSectionTitle(row++, "Emission Summary (kg CO₂e)");

  writeCell(row, 0, "Scope", style: labelStyle);
  writeCell(row++, 1, "kg CO₂e", style: labelStyle);

  writeCell(row, 0, "Scope 1");
  writeCell(row++, 1, 0);

  writeCell(row, 0, "Scope 2 - Machining");
  writeCell(row++, 1, emissionTotals.machining);

  writeCell(row, 0, "Scope 3 - Purchased Goods & Services");
  writeCell(row++, 1, emissionTotals.material);

  writeCell(row, 0, "Scope 3 - Upstream Transportation");
  writeCell(row++, 1, emissionTotals.transport);

  writeCell(row, 0, "Scope 3 - Waste Generated");
  writeCell(row++, 1, emissionTotals.waste);

  writeCell(row, 0, "Scope 3 - Usage Cycle");
  writeCell(row++, 1, emissionTotals.usageCycle);

  writeCell(row, 0, "Scope 3 - End-of-Life");
  writeCell(row++, 1, emissionTotals.endofLife);

  row++;

  /// ---------- MATERIAL TABLE ----------
  writeSectionTitle(row++, "Material Breakdown");

  // table header
  writeCell(row, 0, "Material", style: labelStyle);
  writeCell(row, 1, "Normal", style: labelStyle);
  writeCell(row++, 2, "Custom", style: labelStyle);

  for (var i = 0; i < materialRows.length; i++) {
    final r = materialRows[i];

    writeCell(row, 0, "Material ${i + 1}");
    writeCell(row, 1, r.materialNormal);
    writeCell(row++, 2, r.material);
  }

  /// ---------- COLUMN WIDTHS ----------
  sheet.setColumnWidth(0, 35);
  sheet.setColumnWidth(1, 20);
  sheet.setColumnWidth(2, 20);

  /// ---------- SAVE FILE ----------
  final bytes = excel.encode();
  if (bytes == null) return;

  final dir = await getDownloadsDirectory();
  if (dir == null) return;

  final file = File('${dir.path}/Product_${widget.productId}.xlsx');
  await file.writeAsBytes(bytes);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Excel saved to Downloads')),
  );
}

Future<void> exportPdfWithDialog() async {
  final product = ref.read(activeProductProvider);
  final timeline = ref.read(activeTimelineProvider);
  if (product == null || timeline == null) return;

  final allParts = ref.read(partsProvider);
  if (allParts.isEmpty) return;

  final pdf = pw.Document();

  // ---------------- STYLES ----------------
  final base = pw.TextStyle(fontSize: 8);
  final bold = pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);
  final title = pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold);
  final header = pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);

  // ---------------- GENERIC TABLE ----------------
  pw.Widget table(List<String> headers, List<List<String>> rows) {
    if (rows.isEmpty) return pw.Text("No data", style: base);

    return pw.Table(
      border: pw.TableBorder.all(width: 0.3),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: headers
              .map((h) => pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text(h, style: bold),
                  ))
              .toList(),
        ),
        ...rows.map((r) => pw.TableRow(
              children: r
                  .map((c) => pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(c, style: base),
                      ))
                  .toList(),
            )),
      ],
    );
  }

  // ---------------- SECTION BUILDER ----------------
  pw.Widget section({
    required String titleText,
    required List<String> headers,
    required List<List<String>> rows,
    required double? allocationSum,
    required double emissionTotal,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 6),
        pw.Text(titleText, style: header),
        pw.SizedBox(height: 2),
        table(headers, rows),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Allocation Sum: ${allocationSum?.toStringAsFixed(2)}",
                style: base),
            pw.Text("Emissions: ${emissionTotal.toStringAsFixed(2)} kgCO₂e",
                style: bold),
          ],
        ),
      ],
    );
  }

  // ---------------- EMISSION SUM HELPER ----------------
  double sum(List<EmissionResults> rows, double Function(EmissionResults) f) {
    return rows.fold(0.0, (a, b) => a + f(b));
  }

  // ---------------- BUILD PART SECTION ----------------
  pw.Widget buildPart(String part) {
    final key = (product: product.name, part: part);
    final emissionTotals =
        ref.watch(convertedEmissionsTotalProvider((widget.productId, part)));

    // ---------- NORMAL MATERIAL ----------
    final normalMat = ref.read(normalMaterialTableProvider(key));
    final normalRows = List.generate(
      normalMat.normalMaterials.length,
      (i) => [
        normalMat.normalMaterials[i] ?? '',
        normalMat.countries[i] ?? '',
        normalMat.masses[i] ?? '',
        normalMat.materialAllocationValues[i] ?? ''
      ],
    );

    // ---------- MATERIAL ----------
    final mat = ref.read(materialTableProvider(key));
    final matRows = List.generate(
      mat.materials.length,
      (i) => [
        mat.materials[i] ?? '',
        mat.countries[i] ?? '',
        mat.masses[i] ?? '',
        mat.materialAllocationValues[i] ?? ''
      ],
    );

    // ---------- UPSTREAM TRANSPORT ----------
    final up = ref.read(upstreamTransportTableProvider(key));
    final upRows = List.generate(
      up.vehicles.length,
      (i) => [
        up.classes[i] ?? '',
        up.vehicles[i] ?? '',
        up.distances[i] ?? '',
        up.masses[i] ?? '',
        up.transportAllocationValues[i] ?? ''
      ],
    );

    // ---------- MACHINING ----------
    final mach = ref.read(machiningTableProvider(key));
    final machRows = List.generate(
      mach.machines.length,
      (i) => [
        mach.brands[i] ?? '',
        mach.machines[i] ?? '',
        mach.countries[i] ?? '',
        mach.times[i] ?? '',
        mach.machiningAllocationValues[i] ?? ''
      ],
    );

    // ---------- WASTE ----------
    final waste = ref.read(wastesTableProvider(key));
    final wasteRows = List.generate(
      waste.waste.length,
      (i) => [
        waste.wasteType[i] ?? '',
        waste.waste[i] ?? '',
        waste.mass[i] ?? '',
        waste.wasteAllocationValues[i] ?? ''
      ],
    );

    // ---------- FUGITIVE ----------
    final fug = ref.read(fugitiveLeaksTableProvider(key));
    final fugRows = List.generate(
      fug.ghg.length,
      (i) => [
        fug.ghg[i] ?? '',
        fug.totalCharge[i] ?? '',
        fug.remainingCharge[i] ?? '',
        fug.fugitiveAllocationValues[i] ?? ''
      ],
    );

    // ---------- PRODUCTION TRANSPORT ----------
    final prodT = ref.read(productionTransportTableProvider(key));
    final prodRows = List.generate(
      prodT.vehicles.length,
      (i) => [
        prodT.classes[i] ?? '',
        prodT.vehicles[i] ?? '',
        prodT.distances[i] ?? '',
        prodT.masses[i] ?? '',
        prodT.transportAllocationValues[i] ?? ''
      ],
    );

    // ---------- DOWNSTREAM ----------
    final downT = ref.read(downstreamTransportTableProvider(key));
    final downRows = List.generate(
      downT.vehicles.length,
      (i) => [
        downT.classes[i] ?? '',
        downT.vehicles[i] ?? '',
        downT.distances[i] ?? '',
        downT.masses[i] ?? '',
        downT.transportAllocationValues[i] ?? ''
      ],
    );

    // ---------- END OF LIFE ----------
    final eol = ref.read(endOfLifeTableProvider(key));
    final eolRows = List.generate(
      eol.endOfLifeOptions.length,
      (i) => [
        eol.endOfLifeOptions[i] ?? '',
        eol.endOfLifeTotalMass[i] ?? '',
        eol.endOfLifeAllocationValues[i] ?? ''
      ],
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),
        pw.Divider(),
        pw.Text("PART: $part", style: title),

        section(
          titleText: "Normal Material",
          headers: ["Material", "Country", "Mass", "Allocation"],
          rows: normalRows,
          allocationSum: null,
          emissionTotal: sum(
            ref.read(normalMaterialEmissionRowsProvider(key)),
            (e) => e.materialNormal,
          ),
        ),

        section(
          titleText: "Material",
          headers: ["Material", "Country", "Mass", "Allocation"],
          rows: matRows,
          allocationSum:null,
          emissionTotal: sum(
            ref.read(materialEmissionRowsProvider(key)),
            (e) => e.material,
          ),
        ),

        section(
          titleText: "Upstream Transport",
          headers: ["Class", "Vehicle", "Distance", "Mass", "Allocation"],
          rows: upRows,
          allocationSum: null,
          emissionTotal: emissionTotals.transport,
        ),

        section(
          titleText: "Machining",
          headers: ["Brand", "Machine", "Country", "Time", "Allocation"],
          rows: machRows,
          allocationSum: null,
          emissionTotal: emissionTotals.machining,
        ),

        section(
          titleText: "Waste",
          headers: ["Type", "Waste", "Mass", "Allocation"],
          rows: wasteRows,
          allocationSum: null,
          emissionTotal: sum(
            ref.read(wasteEmissionRowsProvider(key)),
            (e) => e.waste,
          ),
        ),

        section(
          titleText: "Fugitive Leaks",
          headers: ["GHG", "Total Charge", "Remaining", "Allocation"],
          rows: fugRows,
          allocationSum: ref.read(fugitiveAllocationSumProvider(key)),
          emissionTotal: sum(
            ref.read(fugitiveEmissionRowsProvider(key)),
            (e) => e.fugitive,
          ),
        ),

        section(
          titleText: "Production Transport",
          headers: ["Class", "Vehicle", "Distance", "Mass", "Allocation"],
          rows: prodRows,
          allocationSum: null,
          emissionTotal: sum(
            ref.read(productionTransportEmissionRowsProvider(key)),
            (e) => e.productionTransport,
          ),
        ),

        section(
          titleText: "Downstream Transport",
          headers: ["Class", "Vehicle", "Distance", "Mass", "Allocation"],
          rows: downRows,
          allocationSum:null,
          emissionTotal: sum(
            ref.read(downstreamTransportEmissionRowsProvider(key)),
            (e) => e.downstreamTransport,
          ),
        ),

        section(
          titleText: "End of Life",
          headers: ["Option", "Total Mass", "Allocation"],
          rows: eolRows,
          allocationSum: ref.read(endOfLifeAllocationSumProvider(key)),
          emissionTotal: sum(
            ref.read(endOfLifeEmissionRowsProvider(key)),
            (e) => e.endofLife,
          ),
        ),
      ],
    );
  }

  // ---------------- SINGLE PAGE ----------------
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(16),
      build: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("Product Carbon Footprint Report", style: title),
          pw.SizedBox(height: 8),
          pw.Text("Product: ${product.name}", style: base),
          pw.Text("Functional Unit: ${_functionalUnitController.text}", style: base),
          pw.Text("Description: ${_descriptionController.text}", style: base),
          pw.SizedBox(height: 12),
          ...allParts.map(buildPart),
        ],
      ),
    ),
  );

// ---------------- SAVE DIALOG ----------------
final saveLocation = await getSaveLocation(
  acceptedTypeGroups: [
    XTypeGroup(label: 'PDF', extensions: ['pdf'])
  ],
  suggestedName: 'Product_${product.name}.pdf',
);

if (saveLocation == null) return; // user cancelled

final path = saveLocation.path;

// Generate the PDF bytes
final bytes = await pdf.save();

// Write file to disk
final file = File(path);
await file.writeAsBytes(bytes, flush: true);

// Open the saved PDF
await OpenFile.open(path);
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
                onPressed: exportPdfWithDialog,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}

