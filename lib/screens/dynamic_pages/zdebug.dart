import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/riverpod.dart';

class DebugPage extends ConsumerWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emissions = ref.watch(emissionCalculatorProvider);

    // ✅ Pass the number of columns to the family provider
    final tableState = ref.watch(tableControllerProvider(3));

    // Convert TableState to RowFormat
    List<RowFormat> rows = List.generate(
      tableState.selections[0].length,
      (rowIndex) => RowFormat(
        columnTitles: ['Country', 'Material', 'Mass (kg)'],
        isTextFieldColumn: [false, false, true],
        selections: [
          tableState.selections[0][rowIndex],
          tableState.selections[1][rowIndex],
          tableState.selections[2][rowIndex],
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Test Page")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
Expanded(
  child: ListView.builder(
    itemCount: tableState.selections[0].length,
    itemBuilder: (context, rowIndex) {
      return Row(
        children: List.generate(3, (colIndex) {
          // Column 0 = Country
          if (colIndex == 0) {
            final countries = ref.watch(countriesProvider);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: DropdownButtonFormField<String>(
                  initialValue: (tableState.selections[colIndex][rowIndex]?.isEmpty ?? true)
                      ? null
                      : tableState.selections[colIndex][rowIndex],
                  items: countries
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ))
                      .toList(),
                  onChanged: (value) {
                    ref
                        .read(tableControllerProvider(3).notifier)
                        .updateCell(colIndex, rowIndex, value);
                  },
                  decoration: const InputDecoration(labelText: 'Country'),
                ),
              ),
            );
          }

          // Column 1 = Material
          if (colIndex == 1) {
            final materials = ref.watch(materialsProvider);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: DropdownButtonFormField<String>(
                  initialValue: (tableState.selections[colIndex][rowIndex]?.isEmpty ?? true)
                      ? null
                      : tableState.selections[colIndex][rowIndex],
                  items: materials
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(m),
                          ))
                      .toList(),
                  onChanged: (value) {
                    ref
                        .read(tableControllerProvider(3).notifier)
                        .updateCell(colIndex, rowIndex, value);
                  },
                  decoration: const InputDecoration(labelText: 'Material'),
                ),
              ),
            );
          }

          // Column 2 = Mass (kg) as text field
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextFormField(
                initialValue: tableState.selections[colIndex][rowIndex],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  ref
                      .read(tableControllerProvider(3).notifier)
                      .updateCell(colIndex, rowIndex, value);
                },
                decoration: const InputDecoration(labelText: 'Mass (kg)'),
              ),
            ),
          );
        }),
      );
    },
  ),
),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () =>
                      ref.read(tableControllerProvider(3).notifier).addRow(3),
                  child: const Text("Add Row"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => ref
                      .read(tableControllerProvider(3).notifier)
                      .removeRow(tableState.selections[0].length - 1),
                  child: const Text("Remove Last Row"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(emissionCalculatorProvider.notifier)
                    .calculate('material', rows);
              },
              child: const Text("Calculate Material Emissions"),
            ),

            const SizedBox(height: 20),
            Text('Material: ${emissions.material} kgCO2e'),
            Text('Transport: ${emissions.transport} kgCO2e'),
            Text('Machining: ${emissions.machining} kgCO2e'),
            Text('Fugitive: ${emissions.fugitive} kgCO2e'),
            const Divider(),
            Text('Total: ${emissions.total} kgCO2e'),
          ],
        ),
      ),
    );
  }
}