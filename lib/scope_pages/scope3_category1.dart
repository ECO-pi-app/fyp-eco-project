import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/riverpod.dart';
import 'package:test_app/riverpod_profileswitch.dart';

class ProductDetailForm extends ConsumerWidget {
  final String productId;

  const ProductDetailForm({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final part = ref.watch(activePartProvider);
    final materialTable = ref.watch(materialTableProvider((product: productId, part: 'default')));
    final emissionTotals = ref.watch(emissionTotalsProvider((productId, part!)));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- PRODUCT DESCRIPTION ----------------
          TextField(
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
    StatefulBuilder(
      builder: (context, setState) {
        bool applied = false; // local toggle state
        return Row(
          children: [
            Switch(
              value: applied,
              onChanged: (val) {
                setState(() {
                  applied = val;
                });
              },
              activeColor: Apptheme.widgetsecondaryclr,
            ),
            if (applied) ...[
              const SizedBox(width: 16),
              const Text('gibberish'),
            ],
          ],
        );
      },
    ),
  ],
),
const SizedBox(height: 24),


          // ---------------- MATERIALS USED ----------------
          Text('Materials Used', style: TextStyle(color: Apptheme.textclrdark, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: materialTable.materials.length,
            itemBuilder: (context, index) {
              return Card(
                color: Apptheme.widgetsecondaryclr,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(materialTable.materials[index] ?? '', style: TextStyle(color: Apptheme.textclrdark)),
                      ),
                      const SizedBox(width: 8),
                      Text(materialTable.masses[index] ?? '', style: TextStyle(color: Apptheme.textclrdark)),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // ---------------- EMISSIONS ----------------
          Text('Emissions (kg CO₂e)', style: TextStyle(color: Apptheme.textclrdark, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _emissionRow('Scope 1', 0),
          _emissionRow('Scope 2', emissionTotals.machining),
              _emissionRow('Scope 3 Purchased goods and services/Capital Goods', emissionTotals.material),
              _emissionRow('Scope 3 Fuel- and energy-related activities', 0),
              _emissionRow('Scope 3 Upstream transportation and distribution', emissionTotals.transport),
              _emissionRow('Scope 3 Waste generated in operations', emissionTotals.waste),
              _emissionRow('Scope 3 Business travel (NOT APPLICABLE)', 0),
              _emissionRow('Scope 3 Employee commuting (NOT APPLICABLE)', 0),
              _emissionRow('Scope 3 Upstream leased assets (NOT APPLICABLE)', 0),
              _emissionRow('Scope 3 Downstream transportation and distribution', 0),
              _emissionRow('Scope 3 Processing of sold products', 0),
              _emissionRow('Scope 3 Use of sold products', emissionTotals.usageCycle),
              _emissionRow('Scope 3 End-of-life treatment of sold products', emissionTotals.endofLife),
              _emissionRow('Scope 3 Downstream leased assets (NOT APPLICABLE)', 0),
              _emissionRow('Scope 3 Franchises (NOT APPLICABLE)', 0),
              _emissionRow('Scope 3 Investments (NOT APPLICABLE)', 0),
        ]
      ),
    );
  }

  Widget _emissionRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Apptheme.textclrdark)),
          Text(value.toStringAsFixed(2), style: TextStyle(color: Apptheme.textclrdark, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
