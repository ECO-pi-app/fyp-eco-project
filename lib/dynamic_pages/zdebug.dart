import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/riverpod.dart';

class DebugPage extends ConsumerWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ---------- PROVIDERS ----------
    final materialState = ref.watch(materialTableProvider);
    final materialNotifier = ref.read(materialTableProvider.notifier);

    final upstreamTransportState = ref.watch(upstreamTransportTableProvider);
    final upstreamTransportNotifier = ref.read(upstreamTransportTableProvider.notifier);

    final machiningState = ref.watch(machiningTableProvider);
    final machiningNotifier = ref.read(machiningTableProvider.notifier);

    final leaksState = ref.watch(fugitiveLeaksTableProvider);
    final leaksNotifier = ref.read(fugitiveLeaksTableProvider.notifier);

    return PrimaryPages(
      childofmainpage: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // -------------------- MATERIAL ACQUISITION --------------------
          Labels(
            title:
                "Material Acquisition (${materialState.materials.length} rows)",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),
          _buildMaterialTable(materialState, materialNotifier),
          const SizedBox(height: 30),

          // -------------------- UPSTREAM TRANSPORT --------------------
          Labels(
            title: "Upstream Transport (${upstreamTransportState.vehicles.length} rows)",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),
          _buildUpstreamTransportTable(upstreamTransportState, upstreamTransportNotifier),
          const SizedBox(height: 30),

          // -------------------- MACHINING --------------------
          Labels(
            title: "Machining (${machiningState.machines.length} rows)",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),
          _buildMachiningTable(machiningState, machiningNotifier),
          const SizedBox(height: 30),

          // -------------------- FUGITIVE LEAKS --------------------
          Labels(
            title: "Fugitive Leaks (${leaksState.ghg.length} rows)",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),
          _buildFugitiveLeaksTable(leaksState, leaksNotifier),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// -------------------- MATERIAL TABLE --------------------
Widget _buildMaterialTable(MaterialTableState s, MaterialTableNotifier n) {
  final rowCount = s.materials.length;

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
            _staticCell(s.materials[i]),
            _staticCell(s.countries[i]),
            _staticCell(s.masses[i]),
            _editableCell(
              text: s.materialAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
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
      3: FlexColumnWidth(),
      4: FixedColumnWidth(70),
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
  required Function(String) onChanged,
}) => Padding(
  padding: const EdgeInsets.only(top: 2),
  child: TextField(
    controller: TextEditingController(text: text ?? ''),
    decoration: const InputDecoration(
      isDense: true,
      border: InputBorder.none,
      hintText: '1.00',
      hintStyle: TextStyle(fontSize: 15, color: Apptheme.texthintclrdark),
    ),
    onChanged: onChanged,
  ),
);

Widget _checkCell() => const Padding(
  padding: EdgeInsets.all(6),
  child: Icon(Icons.check_circle_outline, color: Apptheme.iconsprimary, size: 18),
);
