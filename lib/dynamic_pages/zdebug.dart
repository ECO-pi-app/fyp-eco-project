import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/riverpod.dart';
import 'package:test_app/riverpod_profileswitch.dart';

class DebugPage extends ConsumerWidget {
  final String productID;
  const DebugPage({super.key, required this.productID });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ---------- PROVIDERS ----------
    final product = ref.watch(activeProductProvider);
    final part = ref.watch(activePartProvider);

    if (product == null || part == null) {
      return const SizedBox(); // or handle empty state
    }

    final key = (product: product, part: part);

    /// ---------------- MATERIAL ----------------
    final normalMaterialState = ref.watch(normalMaterialTableProvider(key));
    final normalMaterialNotifier = ref.read(normalMaterialTableProvider(key).notifier);

    final materialState = ref.watch(materialTableProvider(key));
    final materialNotifier = ref.read(materialTableProvider(key).notifier);

    /// ---------------- UPSTREAM TRANSPORT ----------------
    final upstreamTransportState = ref.watch(upstreamTransportTableProvider(key));
    final upstreamTransportNotifier = ref.read(upstreamTransportTableProvider(key).notifier);

    /// ---------------- MACHINING ----------------
    final machiningState = ref.watch(machiningTableProvider(key));
    final machiningNotifier = ref.read(machiningTableProvider(key).notifier);

    /// ---------------- FUGITIVE LEAKS ----------------
    final leaksState = ref.watch(fugitiveLeaksTableProvider(key));
    final leaksNotifier = ref.read(fugitiveLeaksTableProvider(key).notifier);

    /// ---------------- PRODUCTION TRANSPORT ----------------
    final productionTransportState = ref.watch(productionTransportTableProvider(key));
    final productionTransportNotifier = ref.read(productionTransportTableProvider(key).notifier);

    /// ---------------- WASTE ----------------
    final wasteTransportState = ref.watch(wastesProvider(key));
    final wasteTransportNotifier = ref.read(wastesProvider(key).notifier);

    /// ---------------- USAGE CYCLE ----------------
    final usageCycleState = ref.watch(usageCycleTableProvider(key));
    final usageCycleNotifier = ref.read(usageCycleTableProvider(key).notifier);

    /// ---------------- END OF LIFE ----------------
    final endOfLifeState = ref.watch(endOfLifeTableProvider(key));
    final endOfLifeNotifier = ref.read(endOfLifeTableProvider(key).notifier);



    return PrimaryPages(
      childofmainpage: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // -------------------- MATERIAL ACQUISITION --------------------
          Labels(
            title:
                "Material Acquisition",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),
          _buildNormalMaterialTable(normalMaterialState, normalMaterialNotifier),
          const SizedBox(height: 30),

          // -------------------- MATERIAL ACQUISITION --------------------
          Labels(
            title:
                "Recycled Material Acquisition",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),
          _buildMaterialTable(materialState, materialNotifier),
          const SizedBox(height: 30),

          // -------------------- UPSTREAM TRANSPORT --------------------
          Labels(
            title: "Upstream Transport",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),
          _buildUpstreamTransportTable(upstreamTransportState, upstreamTransportNotifier),
          const SizedBox(height: 30),

          // -------------------- MACHINING --------------------
          Labels(
            title: "Machining",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),
          _buildMachiningTable(machiningState, machiningNotifier),
          const SizedBox(height: 30),

          // -------------------- FUGITIVE LEAKS --------------------
          Labels(
            title: "Fugitive Leaks",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),
          _buildFugitiveLeaksTable(leaksState, leaksNotifier),
          const SizedBox(height: 30),

          // -------------------- PRODUCTION TRANSPORT --------------------
          Labels(
            title: "Production Transport",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),
          _buildProductionTransportTable(productionTransportState, productionTransportNotifier),
          const SizedBox(height: 30),

          // -------------------- WASTE --------------------------
          Labels(
            title: "Manufacturing Wastes",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),
          _buildWasteTable(wasteTransportState, wasteTransportNotifier),
          const SizedBox(height: 30),

          // -------------------- USAGE CYCLE --------------------
          Labels(
            title: "Usage Cycle",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),
          _buildUsageCycleTable(usageCycleState, usageCycleNotifier),

          // --------------------- END OF LIFE -------------------
          Labels(
            title: 'End of Life', 
            color: Apptheme.textclrdark
          ),
          const SizedBox(height: 10,),
          _endOfLifeCycleTable(endOfLifeState, endOfLifeNotifier)
        ],
      ),
    );
  }
}




// -------------------- MATERIAL TABLE --------------------
Widget _buildNormalMaterialTable(NormalMaterialState s, NormalMaterialNotifier n) {
  final rowCount = s.normalMaterials.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      2: FixedColumnWidth(120),
      5: FlexColumnWidth(),
      6: FixedColumnWidth(70),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Material", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Country", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Mass (kg)", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Action", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.normalMaterials[i]),
            _staticCell(s.countries[i]),
            _staticCell(s.masses[i]),
            _editableCell(
              text: s.materialAllocationValues[i],
              onChanged: (v) {
                print('Updating row $i Allocation Value: $v');  // <-- debug print
                n.updateCell(row: i, column: 'Allocation Value', value: v);
              },
            ),
            _checkCell(),
          ],
        ),
    ],
  );
}


Widget _buildMaterialTable(MaterialTableState s, MaterialTableNotifier n) {
  final rowCount = s.materials.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      2: FixedColumnWidth(120),
      3: FixedColumnWidth(120),
      4: FixedColumnWidth(120),
      5: FlexColumnWidth(),
      6: FixedColumnWidth(70),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Material", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Country", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Mass (kg)", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Custom EF", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Internal EF", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Action", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.materials[i]),
            _staticCell(s.countries[i]),
            _staticCell(s.masses[i]),
            _staticCell(s.customEF[i]),
            _staticCell(s.internalEF[i]),
            _editableCell(
              text: s.materialAllocationValues[i],
              onChanged: (v) {
                print('Updating row $i Allocation Value: $v');  // <-- debug print
                n.updateCell(row: i, column: 'Allocation Value', value: v);
              },
            ),
            _checkCell(),
          ],
        ),
    ],
  );
}

// -------------------- UPSTREAM TRANSPORT TABLE --------------------
Widget _buildUpstreamTransportTable(UpstreamTransportTableState s, UpstreamTransportTableNotifier n) {
  final rowCount = s.vehicles.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      2: FixedColumnWidth(120),
      3: FixedColumnWidth(120),
      4: FlexColumnWidth(),
      5: FixedColumnWidth(70),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Vehicle", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Class", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Distance", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Mass", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Action", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.vehicles[i]),
            _staticCell(s.classes[i]),
            _staticCell(s.distances[i]),
            _staticCell(s.masses[i]),
            _editableCell(
              text: s.transportAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
            _checkCell(),
          ],
        ),
    ],
  );
}

// -------------------- MACHINING TABLE --------------------
Widget _buildMachiningTable(MachiningTableState s, MachiningTableNotifier n) {
  final rowCount = s.machines.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      2: FixedColumnWidth(120),
      3: FlexColumnWidth(),
      4: FixedColumnWidth(70),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Machine", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Country", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Time (hr)", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Action", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.machines[i]),
            _staticCell(s.countries[i]),
            _staticCell(s.times[i]),
            _editableCell(
              text: s.machiningAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
            _checkCell(),
          ],
        ),
    ],
  );
}

// -------------------- FUGITIVE LEAKS TABLE --------------------
Widget _buildFugitiveLeaksTable(FugitiveLeaksTableState s, FugitiveLeaksTableNotifier n) {
  final rowCount = s.ghg.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      2: FixedColumnWidth(120),
      3: FlexColumnWidth(),
      4: FixedColumnWidth(70),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "GHG", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Total (kg)", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Remaining (kg)", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Action", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.ghg[i]),
            _staticCell(s.totalCharge[i]),
            _staticCell(s.remainingCharge[i]),
            _editableCell(
              text: s.fugitiveAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
            _checkCell(),
          ],
        ),
    ],
  );
}

// ---------------------PRODUCTION TRANSPORT -----------------
Widget _buildProductionTransportTable(ProductionTransportTableState s, ProductionTransportTableNotifier n) {
  final rowCount = s.vehicles.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      2: FixedColumnWidth(120),
      3: FixedColumnWidth(120),
      4: FlexColumnWidth(),
      5: FixedColumnWidth(70),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Vehicle", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Class", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Distance", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Mass", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Action", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.vehicles[i]),
            _staticCell(s.classes[i]),
            _staticCell(s.distances[i]),
            _staticCell(s.masses[i]),
            _editableCell(
              text: s.transportAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
            _checkCell(),
          ],
        ),
    ],
  );
}

// ---------------------WASTE ---------------------------------
Widget _buildWasteTable(WastesTableState s, WastesTableNotifier n) {
  final rowCount = s.wasteType.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      4: FlexColumnWidth(),
      5: FixedColumnWidth(70),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Waste Material", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Mass (kg)", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Action", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.wasteType[i]),
            _staticCell(s.mass[i]),
            _editableCell(
              text: s.wasteAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
            _checkCell(),
          ],
        ),
    ],
  );
}

// -------------------- USAGE CYCLE TABLE --------------------
Widget _buildUsageCycleTable(UsageCycleState s, UsageCycleNotifier n) {
  final rowCount = s.usageFrequencies.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      2: FixedColumnWidth(120),
      3: FlexColumnWidth(),
      4: FixedColumnWidth(70),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Categories", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Product", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Usage Frequency", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Action", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.categories[i]),
            _staticCell(s.productTypes[i]),
            _staticCell(s.usageFrequencies[i]),
            _editableCell(
              text: s.usageCycleAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
            _checkCell(),
          ],
        ),
    ],
  );
}

Widget _endOfLifeCycleTable(EndOfLifeTableState s, EndOfLifeTableNotifier n) {
  final rowCount = s.endOfLifeOptions.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      3: FlexColumnWidth(),
      4: FixedColumnWidth(70),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Process", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Mass", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Action", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.endOfLifeOptions[i]),
            _staticCell(s.endOfLifeTotalMass[i]),
            _editableCell(
              text: s.endOfLifeAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
            _checkCell(),
          ],
        ),
    ],
  );
}





// -------------------- SHARED CELL HELPERS --------------------
Widget _staticCell(String? text) => Padding(
  padding: const EdgeInsets.only(top: 0),
  child: Textsinsidewidgets(
    words: text ?? '—',
    color: Apptheme.textclrdark,
    fontsize: 15,
    toppadding: 0,
    maxLines: 1,
    softWrap: false,
  ),
);

Widget _editableCell({
  required String? text,
  required void Function(String) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 2),
    child: TextFormField(
      initialValue: text,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 15, color: Apptheme.textclrdark),
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: '100',
        hintStyle: TextStyle(fontSize: 15, color: Apptheme.texthintclrdark),
        contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      ),
      onChanged: onChanged,
    ),
  );
}


Widget _checkCell() => const Padding(
  padding: EdgeInsets.all(6),
  child: Icon(Icons.check_circle_outline, color: Apptheme.iconsprimary, size: 18),
);
