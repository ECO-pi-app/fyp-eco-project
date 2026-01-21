import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/app_logic/riverpod_calculation.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
import 'package:test_app/app_logic/riverpod_states.dart';

/// ===========================
/// REUSABLE FINE-TUNE POPUP
/// ===========================
class FineTunePopup extends StatelessWidget {
  final String title;
  final String tooltip;
  final Widget content;
  final double width;
  final double height;

  const FineTunePopup({
    super.key,
    required this.title,
    required this.tooltip,
    required this.content,
    this.width = 900,
    this.height = 600,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 300),
      child: IconButton(
        icon: const Icon(Icons.tune, color: Apptheme.iconsprimary, size: 19,),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => Dialog(
              backgroundColor: Apptheme.backgroundlight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: width,
                height: height,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Apptheme.textclrdark,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: content,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ===========================
/// DEBUG PAGE
/// ===========================
class DebugPage extends ConsumerWidget {
  final String productID;
  const DebugPage({super.key, required this.productID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ---------- ACTIVE CONTEXT ----------
    final product = ref.watch(activeProductProvider);
    final part = ref.watch(activePartProvider);

    if (product == null || part == null) {
      return const SizedBox();
    }

    final key = (product: product, part: part);

    /// ---------------- MATERIAL ----------------
    final normalMaterialState =
        ref.watch(normalMaterialTableProvider(key));
    final normalMaterialNotifier =
        ref.read(normalMaterialTableProvider(key).notifier);

    final materialState =
        ref.watch(materialTableProvider(key));
    final materialNotifier =
        ref.read(materialTableProvider(key).notifier);

    /// ---------------- UPSTREAM TRANSPORT ----------------
    final upstreamTransportState =
        ref.watch(upstreamTransportTableProvider(key));
    final upstreamTransportNotifier =
        ref.read(upstreamTransportTableProvider(key).notifier);

    /// ---------------- MACHINING ----------------
    final machiningState =
        ref.watch(machiningTableProvider(key));
    final machiningNotifier =
        ref.read(machiningTableProvider(key).notifier);

    /// ---------------- FUGITIVE LEAKS ----------------
    final leaksState =
        ref.watch(fugitiveLeaksTableProvider(key));
    final leaksNotifier =
        ref.read(fugitiveLeaksTableProvider(key).notifier);

    /// ---------------- PRODUCTION TRANSPORT ----------------
    final productionTransportState =
        ref.watch(productionTransportTableProvider(key));
    final productionTransportNotifier =
        ref.read(productionTransportTableProvider(key).notifier);

    /// ---------------- DOWNSTREAM TRANSPORT ----------------
    final downstreamTransportState =
        ref.watch(downstreamTransportTableProvider(key));
    final downstreamTransportNotifier =
        ref.read(downstreamTransportTableProvider(key).notifier);

    /// ---------------- WASTE ----------------
    final wasteTransportState =
        ref.watch(wastesProvider(key));
    final wasteTransportNotifier =
        ref.read(wastesProvider(key).notifier);

    /// ---------------- USAGE CYCLE ----------------
    final usageCycleState =
        ref.watch(usageCycleTableProvider(key));
    final usageCycleNotifier =
        ref.read(usageCycleTableProvider(key).notifier);

    /// ---------------- END OF LIFE ----------------
    final endOfLifeState =
        ref.watch(endOfLifeTableProvider(key));
    final endOfLifeNotifier =
        ref.read(endOfLifeTableProvider(key).notifier);

    return PrimaryPages(
      childofmainpage: ListView(
        padding: const EdgeInsets.all(16),
        children: [
              sectionRow(
                title: "Material Acquisition",
                tooltip: "Fine-tune raw material inputs",
                popupContent: buildNormalMaterialTable(
                  normalMaterialState,
                  normalMaterialNotifier,
                ),
              ),
              const SizedBox(height: 30),

              sectionRow(
                title: "Recycled Material Acquisition",
                tooltip: "Fine-tune recycled material inputs",
                popupContent: buildMaterialTable(
                  materialState,
                  materialNotifier,
                ),
              ),
              const SizedBox(height: 30),

              sectionRow(
                title: "Upstream Transport",
                tooltip: "Adjust upstream transport allocation",
                popupContent: buildUpstreamTransportTable(
                  upstreamTransportState,
                  upstreamTransportNotifier,
                ),
              ),
              const SizedBox(height: 30),

              sectionRow(
                title: "Machining",
                tooltip: "Adjust machining allocation",
                popupContent: buildMachiningTable(
                  machiningState,
                  machiningNotifier,
                ),
              ),
              const SizedBox(height: 30),

              sectionRow(
                title: "Fugitive Leaks",
                tooltip: "Adjust fugitive emissions allocation",
                popupContent: buildFugitiveLeaksTable(
                  leaksState,
                  leaksNotifier,
                ),
              ),
              const SizedBox(height: 30),

              sectionRow(
                title: "Production Transport",
                tooltip: "Adjust production transport allocation",
                popupContent: buildProductionTransportTable(
                  productionTransportState,
                  productionTransportNotifier,
                ),
              ),
              const SizedBox(height: 30),

              sectionRow(
                title: "Manufacturing Wastes",
                tooltip: "Adjust waste mass allocation",
                popupContent: buildWasteTable(
                  wasteTransportState,
                  wasteTransportNotifier,
                ),
              ),
              const SizedBox(height: 30),

              sectionRow(
                title: "Downstream Transportation",
                tooltip: "Adjust downstream transport allocation",
                popupContent: buildDownstreamTransportTable(
                  downstreamTransportState,
                  downstreamTransportNotifier,
                ),
              ),
              const SizedBox(height: 30),

              sectionRow(
                title: "Usage Cycle",
                tooltip: "Adjust usage cycle allocation",
                popupContent: buildUsageCycleTable(
                  usageCycleState,
                  usageCycleNotifier,
                ),
              ),
              const SizedBox(height: 30),

              sectionRow(
                title: "End of Life",
                tooltip: "Adjust end-of-life allocation",
                popupContent: endOfLifeCycleTable(
                  endOfLifeState,
                  endOfLifeNotifier,
                ),
              ),
        ],
      ),
    );
  }
}


Widget sectionRow({
  required String title,
  required String tooltip,
  required Widget popupContent,
}) {
  return FineTunePopup(
    title: title,
    tooltip: tooltip,
    content: popupContent,
  );
}

// -------------------- MATERIAL TABLE --------------------
Widget buildNormalMaterialTable(NormalMaterialState s, NormalMaterialNotifier n) {
  final rowCount = s.normalMaterials.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      2: FlexColumnWidth(),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Material", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Country", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Center(child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16))),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.normalMaterials[i]),
            _staticCell(s.countries[i]),
            _editableCell(
              text: s.materialAllocationValues[i],
              onChanged: (v) {
                print('Updating row $i Allocation Value: $v');  // <-- debug print
                n.updateCell(row: i, column: 'Allocation Value', value: v);
              },
            ),
          ],
        ),
    ],
  );
}


Widget buildMaterialTable(MaterialTableState s, MaterialTableNotifier n) {
  final rowCount = s.materials.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FlexColumnWidth(),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Material", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.materials[i]),
            _editableCell(
              text: s.materialAllocationValues[i],
              onChanged: (v) {
                print('Updating row $i Allocation Value: $v');  // <-- debug print
                n.updateCell(row: i, column: 'Allocation Value', value: v);
              },
            ),
          ],
        ),
    ],
  );
}

// -------------------- UPSTREAM TRANSPORT TABLE --------------------
Widget buildUpstreamTransportTable(UpstreamTransportTableState s, UpstreamTransportTableNotifier n) {
  final rowCount = s.vehicles.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      2: FlexColumnWidth(),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Vehicle", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Class", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.vehicles[i]),
            _staticCell(s.classes[i]),
            _editableCell(
              text: s.transportAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
          ],
        ),
    ],
  );
}

// -------------------- MACHINING TABLE --------------------
Widget buildMachiningTable(MachiningTableState s, MachiningTableNotifier n) {
  final rowCount = s.machines.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      3: FlexColumnWidth(),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Machine", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Country", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.machines[i]),
            _staticCell(s.countries[i]),
            _editableCell(
              text: s.machiningAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
          ],
        ),
    ],
  );
}

// -------------------- FUGITIVE LEAKS TABLE --------------------
Widget buildFugitiveLeaksTable(FugitiveLeaksTableState s, FugitiveLeaksTableNotifier n) {
  final rowCount = s.ghg.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      3: FlexColumnWidth(),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "GHG", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.ghg[i]),
            _editableCell(
              text: s.fugitiveAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
          ],
        ),
    ],
  );
}

// ---------------------PRODUCTION TRANSPORT -----------------
Widget buildProductionTransportTable(ProductionTransportTableState s, ProductionTransportTableNotifier n) {
  final rowCount = s.vehicles.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      4: FlexColumnWidth(),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Vehicle", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Class", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.vehicles[i]),
            _staticCell(s.classes[i]),
            _editableCell(
              text: s.transportAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
          ],
        ),
    ],
  );
}

// ---------------------WASTE ---------------------------------
Widget buildWasteTable(WastesTableState s, WastesTableNotifier n) {
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
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.wasteType[i]),
            _editableCell(
              text: s.wasteAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
          ],
        ),
    ],
  );
}

// ---------------------PRODUCTION TRANSPORT -----------------
Widget buildDownstreamTransportTable(DownstreamTransportTableState s, DownstreamTransportTableNotifier n) {
  final rowCount = s.vehicles.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      4: FlexColumnWidth(),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Vehicle", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Class", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.vehicles[i]),
            _staticCell(s.classes[i]),
            _editableCell(
              text: s.transportAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
          ],
        ),
    ],
  );
}

// -------------------- USAGE CYCLE TABLE --------------------
Widget buildUsageCycleTable(UsageCycleState s, UsageCycleNotifier n) {
  final rowCount = s.usageFrequencies.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      1: FixedColumnWidth(120),
      3: FlexColumnWidth(),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Categories", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Product", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.categories[i]),
            _staticCell(s.productTypes[i]),
            _editableCell(
              text: s.usageCycleAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
          ],
        ),
    ],
  );
}

Widget endOfLifeCycleTable(EndOfLifeTableState s, EndOfLifeTableNotifier n) {
  final rowCount = s.endOfLifeOptions.length;

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
    columnWidths: const {
      0: FixedColumnWidth(200),
      3: FlexColumnWidth(),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Apptheme.widgettertiaryclr,
        ),
        children: const [
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Process", color: Apptheme.textclrdark, fontsize: 16)),
          Padding(padding: EdgeInsets.all(8), child: Labels(title: "Allocation Value", color: Apptheme.textclrdark, fontsize: 16)),
        ],
      ),

      for (int i = 0; i < rowCount; i++)
        TableRow(
          children: [
            _staticCell(s.endOfLifeOptions[i]),
            _editableCell(
              text: s.endOfLifeAllocationValues[i],
              onChanged: (v) => n.updateCell(row: i, column: 'Allocation Value', value: v),
            ),
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
