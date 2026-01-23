import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel/excel.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/app_logic/riverpod_calculation.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
import 'package:test_app/design/apptheme/textlayout.dart';

class ProductDetailForm extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailForm({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailForm> createState() => _ProductDetailFormState();
}

class _ProductDetailFormState extends ConsumerState<ProductDetailForm> {
  // Controllers for text fields
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

void _exportToExcel() {
  final part = ref.read(activePartProvider);
  if (part == null) return;

  final emissionTotals = ref.read(emissionTotalsProvider((widget.productId, part)));
  final materialRows = ref.read(emissionRowsProvider((widget.productId, part)));

  final excel = Excel.createExcel();
  final sheetName = 'Sheet1';

  void writeRow(int rowIndex, List<dynamic> values) {
    for (var col = 0; col < values.length; col++) {
      final value = values[col];
      final cellValue = value is num
          ? DoubleCellValue(value.toDouble())
          : TextCellValue(value.toString());
      excel.updateCell(sheetName, CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex), cellValue);
    }
  }

  int currentRow = 0;

  writeRow(currentRow++, ['Product Description: ', _descriptionController.text]);
  writeRow(currentRow++, ['Functional Unit: ', _functionalUnitController.text]);
  writeRow(currentRow++, ['Declarations: ', _declarationsController.text]);
  writeRow(currentRow++, ['Allocation: ', allocationApplied ? 'NOT ALIGNED WITH STANDARD' : 'None']);

  currentRow++; 

  writeRow(currentRow++, ['Scope', 'Value (kg CO₂e)']);
  writeRow(currentRow++, ['Scope 1', 0]);
  writeRow(currentRow++, ['Scope 2', emissionTotals.machining]);
  writeRow(currentRow++, ['Scope 3 Purchased goods and services/Capital Goods', emissionTotals.material]);
  writeRow(currentRow++, ['Scope 3 Fuel- and energy-related activities', 0]);
  writeRow(currentRow++, ['Scope 3 Upstream transportation and distribution', emissionTotals.transport]);
  writeRow(currentRow++, ['Scope 3 Waste generated in operations', emissionTotals.waste]);
  writeRow(currentRow++, ['Scope 3 Business travel (NOT APPLICABLE)', 0]);
  writeRow(currentRow++, ['Scope 3 Employee commuting (NOT APPLICABLE)', 0]);
  writeRow(currentRow++, ['Scope 3 Upstream leased assets (NOT APPLICABLE)', 0]);
  writeRow(currentRow++, ['Scope 3 Downstream transportation and distribution', 0]);
  writeRow(currentRow++, ['Scope 3 Processing of sold products', 0]);
  writeRow(currentRow++, ['Scope 3 Use of sold products', emissionTotals.usageCycle]);
  writeRow(currentRow++, ['Scope 3 End-of-life treatment of sold products', emissionTotals.endofLife]);
  writeRow(currentRow++, ['Scope 3 Downstream leased assets (NOT APPLICABLE)', 0]);
  writeRow(currentRow++, ['Scope 3 Franchises (NOT APPLICABLE)', 0]);
  writeRow(currentRow++, ['Scope 3 Investments (NOT APPLICABLE)', 0]);

  currentRow++;

writeRow(currentRow++, ['Material', 'Normal', 'Custom']);
for (var i = 0; i < materialRows.length; i++) {
  final r = materialRows[i];
  writeRow(currentRow++, [
    'Material ${i + 1}', 
    r.materialNormal,
    r.material,
  ]);
}

  final bytes = excel.encode();
  if (bytes != null) {
    final file = File('Product_${widget.productId}.xlsx');
    file.writeAsBytesSync(bytes);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Excel exported successfully!')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final part = ref.watch(activePartProvider);
    if (part == null) return const SizedBox();

    final key = (product: widget.productId, part: part);

    final emissionTotals = ref.watch(emissionTotalsProvider((widget.productId, part)));



    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- PRODUCT DESCRIPTION ----------------
          TextField(
            controller: _descriptionController,
            style: TextStyle(color: Apptheme.textclrdark),
            decoration: InputDecoration(
              labelText: 'Product Description',
              labelStyle: TextStyle(color: Apptheme.textclrdark),
              filled: true,
              fillColor: Apptheme.widgetsecondaryclr,
            ),
          ),
          const SizedBox(height: 16),

          // ---------------- FUNCTIONAL UNIT ----------------
          TextField(
            controller: _functionalUnitController,
            style: TextStyle(color: Apptheme.textclrdark),
            decoration: InputDecoration(
              labelText: 'Functional Unit',
              labelStyle: TextStyle(color: Apptheme.textclrdark),
              filled: true,
              fillColor: Apptheme.widgetsecondaryclr,
            ),
          ),
          const SizedBox(height: 16),

          // ---------------- DECLARATIONS ----------------
          TextField(
            controller: _declarationsController,
            style: TextStyle(color: Apptheme.textclrdark),
            decoration: InputDecoration(
              labelText: 'Declarations',
              labelStyle: TextStyle(color: Apptheme.textclrdark),
              filled: true,
              fillColor: Apptheme.widgetsecondaryclr,
            ),
          ),
          const SizedBox(height: 16),

          // ---------------- ALLOCATION APPLIED ----------------
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
              if (allocationApplied) ...[
                const SizedBox(width: 16),
                const Text('Declaration here'),
              ],
            ],
          ),
          const SizedBox(height: 24),

          // ---------------- EMISSIONS ----------------
          Text(
            'Emissions (kg CO₂e)',
            style: TextStyle(
              color: Apptheme.textclrdark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          emissionRow('Scope 1', 0),
          emissionRow('Scope 2', emissionTotals.machining),
          emissionRow('Scope 3 Purchased goods and services/Capital Goods', emissionTotals.material + emissionTotals.materialNormal),
          emissionRow('Scope 3 Fuel- and energy-related activities', 0),
          emissionRow('Scope 3 Upstream transportation and distribution', emissionTotals.transport),
          emissionRow('Scope 3 Waste generated in operations', emissionTotals.waste),
          emissionRow('Scope 3 Business travel (NOT APPLICABLE)', 0),
          emissionRow('Scope 3 Employee commuting (NOT APPLICABLE)', 0),
          emissionRow('Scope 3 Upstream leased assets (NOT APPLICABLE)', 0),
          emissionRow('Scope 3 Downstream transportation and distribution', 0),
          emissionRow('Scope 3 Processing of sold products', 0),
          emissionRow('Scope 3 Use of sold products', emissionTotals.usageCycle),
          emissionRow('Scope 3 End-of-life treatment of sold products', emissionTotals.endofLife),
          emissionRow('Scope 3 Downstream leased assets (NOT APPLICABLE)', 0),
          emissionRow('Scope 3 Franchises (NOT APPLICABLE)', 0),
          emissionRow('Scope 3 Investments (NOT APPLICABLE)', 0),
          const SizedBox(height: 24),

          // ---------------- ALL EMISSION RESULTS ----------------
          Labels(
            title: 'All Materials used',
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 8),
          buildMaterialEmissionResults(ref, widget.productId, part, key),
          const SizedBox(height: 24),

          // ---------------- ALL MACHINING RESULTS ----------------
          Labels(
            title: 'All Machining Used',
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 8),
          buildMachiningEmissionResults(ref, widget.productId, part, key),
          const SizedBox(height: 24),


          // ---------------- EXPORT BUTTON ----------------
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Export to Excel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Apptheme.widgetsecondaryclr,
                foregroundColor: Apptheme.textclrdark,
              ),
              onPressed: _exportToExcel,
            ),
          ),
        ],
      ),
    );
  }

  Widget emissionRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Apptheme.textclrdark)),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(color: Apptheme.textclrdark, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildMaterialEmissionResults(
      WidgetRef ref,
      String productId,
      String partId,
      TableKey tableKey,
    ) {
      final rows = ref.watch(emissionRowsProvider((productId, partId)));

      final materialsState =
          ref.watch(normalMaterialTableProvider(tableKey));

      if (rows.isEmpty) {
        return Text(
          'No emission rows calculated yet',
          style: TextStyle(color: Apptheme.textclrdark),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: rows.length,
        itemBuilder: (context, index) {
          final r = rows[index];

          final materialName =
              materialsState.normalMaterials.length > index
                  ? materialsState.normalMaterials[index] ?? 'Unnamed Material'
                  : 'Unknown Material';

          return SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  resultLine(materialName, r.materialNormal),
                ],
              ),
            ),
          );
        },
      );
    }

  Widget buildMachiningEmissionResults(
  WidgetRef ref,
  String productId,
  String partId,
  TableKey tableKey,
) {
  final rows = ref.watch(emissionRowsProvider((productId, partId)));

  final machiningState =
      ref.watch(machiningTableProvider(tableKey));

  if (rows.isEmpty) {
    return Text(
      'No machining emission rows calculated yet',
      style: TextStyle(color: Apptheme.textclrdark),
    );
  }

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: rows.length,
    itemBuilder: (context, index) {
      final r = rows[index];

      final machineName =
          machiningState.machines.length > index
              ? machiningState.machines[index] ?? 'Unnamed Machine'
              : 'Unknown Machine';

      return SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              resultLine(machineName, r.machining),
            ],
          ),
        ),
      );
    },
  );
}

  Widget resultLine(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Apptheme.textclrdark),
          ),
          Text(
            value.toStringAsFixed(3),
            style: TextStyle(
              color: Apptheme.textclrdark,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

