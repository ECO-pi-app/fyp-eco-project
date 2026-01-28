import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/app_logic/riverpod_calculation.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
import 'package:test_app/design/apptheme/textlayout.dart';


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
    final part = ref.read(activePartProvider);
    if (part == null) return;

    final emissionTotals =
        ref.read(emissionTotalsProvider((widget.productId, part)));
    final materialRows =
        ref.read(emissionRowsProvider((widget.productId, part)));

    final pdf = pw.Document();

    pw.Widget labelRow(String label, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(value),
          ],
        ),
      );
    }

    pw.Widget emissionRow(String label, double value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label),
            pw.Text(value.toStringAsFixed(2)),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            'Product Emissions Summary',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),

          labelRow('Product ID', widget.productId),
          labelRow('Description', _descriptionController.text),
          labelRow('Functional Unit', _functionalUnitController.text),
          labelRow('Declarations', _declarationsController.text),
          labelRow(
            'Allocation',
            allocationApplied ? 'NOT ALIGNED WITH STANDARD' : 'None',
          ),

          pw.Divider(),
          pw.Text('Emissions (kg CO₂e)',
              style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),

          emissionRow('Scope 1', 0),
          emissionRow('Scope 2', emissionTotals.machining),
          emissionRow('Purchased Goods', emissionTotals.material),
          emissionRow('Transport', emissionTotals.transport),
          emissionRow('Waste', emissionTotals.waste),
          emissionRow('Use Phase', emissionTotals.usageCycle),
          emissionRow('End of Life', emissionTotals.endofLife),

          pw.Divider(),
          pw.Text('Materials',
              style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),

          ...List.generate(materialRows.length, (i) {
            final r = materialRows[i];
            return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Material ${i + 1}'),
                pw.Text(
                  'Normal: ${r.materialNormal.toStringAsFixed(2)} | Custom: ${r.material.toStringAsFixed(2)}',
                ),
              ],
            );
          }),
        ],
      ),
    );

    await Printing.layoutPdf(
      name: 'Product_${widget.productId}.pdf',
      onLayout: (_) async => pdf.save(),
    );
  }

  // ===================== UI =====================

  @override
  Widget build(BuildContext context) {
    final part = ref.watch(activePartProvider);
    if (part == null) return const SizedBox();

    final emissionTotals =
        ref.watch(emissionTotalsProvider((widget.productId, part)));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textField(
              'Product Description', _descriptionController),
          _textField(
              'Functional Unit', _functionalUnitController),
          _textField(
              'Declarations', _declarationsController),

          const SizedBox(height: 16),

          Row(
            children: [
              Text('Allocation Applied?',
                  style:
                      TextStyle(color: Apptheme.textclrdark)),
              const SizedBox(width: 16),
              Switch(
                value: allocationApplied,
                onChanged: (val) {
                  setState(() {
                    allocationApplied = val;
                  });
                },
                activeColor:
                    Apptheme.widgetsecondaryclr,
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
          _emissionRow(
              'Scope 2', 0),
          _emissionRow(
              'Purchased Goods',
              emissionTotals.material +
                  emissionTotals.materialNormal),
          _emissionRow(
              'Upstream Transport',
              emissionTotals.transport),
          _emissionRow(
              'Waste', emissionTotals.waste),
          _emissionRow(
              'Use Phase',
              emissionTotals.usageCycle),
          _emissionRow(
              'End of Life',
              emissionTotals.endofLife),

          const SizedBox(height: 24),

          Center(
            child: Wrap(
              spacing: 16,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Export Excel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Apptheme.widgetsecondaryclr,
                    foregroundColor:
                        Apptheme.textclrdark,
                  ),
                  onPressed: _exportExcel,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Apptheme.widgetsecondaryclr,
                    foregroundColor:
                        Apptheme.textclrdark,
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
