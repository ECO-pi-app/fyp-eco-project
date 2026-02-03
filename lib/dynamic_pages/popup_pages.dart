import 'package:flutter/material.dart';
import 'package:test_app/app_logic/riverpod_states.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/dynamic_pages/main_productanlys.dart';
import 'package:test_app/app_logic/river_controls.dart';
import 'package:test_app/app_logic/riverpod_account.dart';
import 'package:test_app/app_logic/riverpod_fetch.dart';

//----------------------------------SETTINGS POPUP PAGES----------------------------------------------
void showAdvancedMaterials(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Popup",
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.0).animate(curved),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 70,
                right: 10,
                bottom: 70,
                child: Material(
                  color: Apptheme.transparentcheat,
                  child: Container(
                    width: 50,
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Apptheme.transparentcheat,
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: AdvancedMaterials(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
class AdvancedMaterials extends ConsumerWidget {
  const AdvancedMaterials({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FrostedBackgroundGeneral(
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: ListView(
              children: [
                MaterialAttributesMenu(productID: '')
              ],
            ),
          ),
        
         
        ],
      ),
    );
  }
}





//-------------------------------------GENERAL--------------------------------------------------------
class GeneralPage extends StatelessWidget {
  const GeneralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FrostedBackgroundGeneral(
      child: Center(
        child: Labels(
          title: "General Settings Page Content",
          color: Apptheme.textclrlight,
          fontsize: 20,
        ),
      ),
    );
  }
}

//-------------------------------------UNITS----------------------------------------------------------
void showUnitsPopup(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Popup",
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.0).animate(curved),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 70,
                right: 10,
                bottom: 70,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Apptheme.transparentcheat,
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: UnitsPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
class UnitsPage extends ConsumerWidget {
  const UnitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FrostedBackgroundGeneral(
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Labels(
                      title: "Display unit",
                      color: Apptheme.textclrlight,
                      fontsize: 19,
                      toppadding: 0,
                      leftpadding: 10,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Labels(
                      title: "[]",
                      color: Apptheme.textclrlight,
                      fontsize: 19,
                      toppadding: 0,
                      leftpadding: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
          Expanded(
            child: FrostedBackgroundGeneral(
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Textsinsidewidgets(
                      words: 'Output display unit: ${ref.watch(unitNameProvider)}', 
                      color: Apptheme.textclrlight,
                      fontsize: 17,
                    ),
                  )
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}

//-------------------------------------ECO-pi METHODOLOGY---------------------------------------------
void showMethodologyPopup(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Popup",
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.0).animate(curved),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 70,
                right: 10,
                bottom: 70,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Apptheme.transparentcheat,
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: MethodologyPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
class MethodologyPage extends ConsumerWidget {
  const MethodologyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FrostedBackgroundGeneral(
      child: ListView(
        children: [
          Labels(title: 'Uncertainies', color: Apptheme.textclrlight, fontsize: 30,),
          Labels(title: 'Parameter uncertainty', color: Apptheme.textclrlight, fontsize: 20,)
        ],
      )
    );
  }
}

//-------------------------------------CATEGORIES PAGES----------------------------------------
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





//-------------------------------------REUSEABLE TRANSLUCENT BACKGROUND----------------------------
class FrostedBackgroundGeneral extends StatelessWidget {
  final Widget child;
  const FrostedBackgroundGeneral({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7.5),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: Apptheme.widgetclrlight.withOpacity(0.2),
          child: child,
        ),
      ),
    );
  }
}

//-------------------------------------DEVELOPER'S PAGE----------------------------------------------

class DeveloperPage extends ConsumerWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaOptionsAsync = ref.watch(metaOptionsProvider);
    final productsAsync = ref.watch(productsProvider);
    final unit = ref.watch(unitLabelProvider);

    return 
      
      ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // ----------------- UNIT CONVERSION -----------------
          _sectionHeader('Unit Conversion'),
          Textsinsidewidgets(words: 'Current Unit: $unit', color: Apptheme.textclrlight,),
          Textsinsidewidgets(words: 'Raw Conversion Factor: ${ref.watch(unitConversionProvider)}', color: Apptheme.textclrlight,),

          const SizedBox(height: 20),

          // ----------------- META OPTIONS -----------------
          _sectionHeader('Meta Options'),
          metaOptionsAsync.when(
            data: (meta) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Textsinsidewidgets(words: 'Countries: ${meta.countries}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Materials: ${meta.materials}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Machines: ${meta.machines}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Packaging Types: ${meta.packagingTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Recycling Types: ${meta.recyclingTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Transport Types: ${meta.transportTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Indicator: ${meta.indicator}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'GHG: ${meta.ghg}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'GWP: ${meta.gwp}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Process: ${meta.process}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Facilities: ${meta.facilities}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Usage Types: ${meta.usageTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Disassembly by Industry: ${meta.disassemblyByIndustry}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Machine Type: ${meta.machineType}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'YCM Types: ${meta.ycmTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Amada Types: ${meta.amadaTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Mazak Types: ${meta.mazakTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Van Mode: ${meta.vanMode}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'HGV Mode: ${meta.hgvMode}', color: Apptheme.textclrlight),

              ],
            ),
            loading: () => const Text('Loading meta options...'),
            error: (e, st) => Text('Error: $e'),
          ),

          const SizedBox(height: 20),


          // ----------------- PRODUCTS -----------------
          _sectionHeader('Products / Profiles'),
          productsAsync.when(
            data: (products) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: products
                  .map((p) => Textsinsidewidgets( words: '- ${p.name}', color: Apptheme.textclrlight,))
                  .toList(),
            ),
            loading: () => const Text('Loading products...'),
            error: (e, st) => Text('Error: $e'),
          ),

          const SizedBox(height: 20),




          const SizedBox(height: 20),

          // ----------------- DEBUG PRINTS (API POSTS) -----------------
          _sectionHeader('Debug Prints / API Logs'),
          const Textsinsidewidgets(
              words: 'All prints from calculation, fetch, save, delete operations appear in your console.\nThis section can be extended to capture them in-app if needed.',
              color: Apptheme.textclrlight,
              ),
        ],
      );

  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Textsinsidewidgets(
        words: title,
        color: Apptheme.textclrlight,
        fontsize: 20,
        fontweight: FontWeight.bold,
      ),
    );
  }
}
















