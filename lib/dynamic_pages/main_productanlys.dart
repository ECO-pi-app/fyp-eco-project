import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/attributes.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/auto_tabs.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/info_popup.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/dynamic_pages/popup_pages.dart';
import 'package:test_app/riverpod.dart';

class Dynamicprdanalysis extends ConsumerStatefulWidget {
  const Dynamicprdanalysis({super.key});

  @override
  ConsumerState<Dynamicprdanalysis> createState() => _DynamicprdanalysisState();
}

class _DynamicprdanalysisState extends ConsumerState<Dynamicprdanalysis> {
  double materialupstreamEmission = 0;
  double materialtransportEmission = 0;
  double fugitiveemissions = 0;
  double machiningemissions = 0;
  bool showThreePageTabs = true;

  final Map<String, String> apiKeymaterials = {
    "Country": "country",
    "Material": "material",
    "Mass (kg)": "mass_kg",
  };

  final Map<String, String> apiKeytransport = {
    "Class": "transport_type",
    "Distance": "distance_km",
  };

  final Map<String, String> apiKeyfugitive = {
    "GHG": "ghg_name",
    "Total Charge": "total_charged_amount_kg",
    "Remaining Charge": "current_charge_amount_kg",
  };

  final Map<String, String> apiKeymachining = {
    "Machine": "machine_model",
    "Country": "country",
    "Time of operation": "time_operated_hr",
  };

  @override
  Widget build(BuildContext context) {
    final emissions = ref.watch(convertedEmissionsProvider);

    // ------------------- Page 1 Widgets (Upstream) -------------------
    final List<Widget> widgetofpage1 = [
      //--ROW 1: Material Acquisition--
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Labels(
                title: 'Material Acquisition | ${emissions.material.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
                color: Apptheme.textclrdark,
              ),

              SizedBox(width: 10),

              SizedBox(
                width: 35,
                height: 20,
                child: ElevatedButton(
                  onPressed: () => showAdvancedMaterials(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Apptheme.widgettertiaryclr,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Icon(Icons.double_arrow_sharp, 
                    color: Apptheme.iconsdark,
                    size: 20,
                    ),
                ),
              ),
            ],
          ),
          InfoIconPopupDark(
            text: 'Sourcing and manufacturing/refining of raw materials purchased and used during production',
          ),
        ],
      ),
      // **Manual hardcoded Material Table**
      MaterialAttributesMenu(ref: ref),

      //--ROW 2: Upstream Transport--
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Upstream Transportation | ${emissions.transport.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InfoIconPopupDark(
              text: 'Transporting of materials purchased from it\'s origin to the production facility\'s gate.',
            ),
          ),
        ],
      ),
      UpstreamTransportAttributesMenu(ref: ref)
    ];

    // ------------------- Pages 2 & 3 remain unchanged -------------------
    final List<Widget> widgetofpage2 = [
      //--ROW 1: Machining--
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Machining | ${emissions.machining.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InfoIconPopupDark(
              text: 'Power consumed during the operation of all processes required to create a product',
            ),
          ),
        ],
      ),
      MachiningAttributesMenu(ref: ref),

      //--ROW 2: Fugitive leaks--
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Fugitive leaks | ${emissions.fugitive.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InfoIconPopupDark(
              text: 'Greenhouse Gases used by equipments as part of their functioning needs released into the atmosphere due to leak, damage or wear',
            ),
          ),
        ],
      ),
      FugitiveLeaksAttributesMenu(ref: ref)
    ];

    final List<Widget> widgetofpage3 = [
      //--ROW 1: Downstream Distribution--
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Downstream Distribution',
            color: Apptheme.textclrdark,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InfoIconPopupDark(
              text: 'Transporting of products from it\'s production facility to the site of storage or retail',
            ),
          ),
        ],
      ),
      Widgets1(
        maxheight: 250,
        child: AttributesMenu(
          columnTitles: ['Transportation', 'Distance'],
          isTextFieldColumn: [false, true],
          addButtonLabel: 'Add transport cycle',
          padding: 5,
          apiKeyMap: apiKeymaterials,
          endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
        ),
      ),
      // ... other downstream widgets remain unchanged ...
    ];

    return PrimaryPages(
      childofmainpage: Column(
        children: [
          Expanded(
            child: showThreePageTabs
                ? ManualTab3pages(
                    backgroundcolor: Apptheme.transparentcheat,
                    tab1: 'Upstream',
                    tab1fontsize: 15,
                    tab2: 'Production',
                    tab2fontsize: 15,
                    tab3: 'Downstream',
                    tab3fontsize: 15,
                    firstchildof1: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: widgetofpage1.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          color: Apptheme.widgetclrlight,
                          child: widgetofpage1[index],
                        );
                      },
                    ),
                    secondchildof1: Container(),
                    firstchildof2: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: widgetofpage2.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          color: Apptheme.widgetclrlight,
                          child: widgetofpage2[index],
                        );
                      },
                    ),
                    secondchildof2: Container(),
                    firstchildof3: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: widgetofpage3.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          color: Apptheme.widgetclrlight,
                          child: widgetofpage3[index],
                        );
                      },
                    ),
                    secondchildof3: Container(), 
                  )
                : ManualTab2pages(
                    backgroundcolor: Apptheme.widgetclrlight,
                    tab1: 'Upstream',
                    tab1fontsize: 15,
                    tab2: 'Production',
                    tab2fontsize: 15,
                    tab3: 'Not included anymore',
                    tab3fontsize: 15,
                    firstchildof1: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: widgetofpage1.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          color: Apptheme.widgetclrlight,
                          child: widgetofpage1[index],
                        );
                      },
                    ),
                    secondchildof1: Container(),
                    firstchildof2: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: widgetofpage2.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          color: Apptheme.widgetclrlight,
                          child: widgetofpage2[index],
                        );
                      },
                    ),
                    secondchildof2: Container(),
                    firstchildof3: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: widgetofpage3.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          color: Apptheme.widgetclrlight,
                          child: widgetofpage3[index],
                        );
                      },
                    ),
                    secondchildof3: Container(),
                  ),
          ),
        ],
      ),
    );
  }
}

// ------------------- Manual Material Attributes Menu -------------------

class MaterialAttributesMenu extends ConsumerWidget {
  const MaterialAttributesMenu({super.key, required WidgetRef ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(materialTableProvider);
    final tableNotifier = ref.read(materialTableProvider.notifier);

    final materials = ref.watch(materialsProvider);
    final countries = ref.watch(countriesProvider);

    List<RowFormat> rows = List.generate(
      tableState.materials.length,
      (i) => RowFormat(
        columnTitles: ['Material', 'Country', 'Mass (kg)'],
        isTextFieldColumn: [false, false, true],
        selections: [
          tableState.materials[i],
          tableState.countries[i],
          tableState.masses[i]
        ],
      ),
    );

    return Column(
      children: [
        // ---------------- Table ----------------
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Apptheme.transparentcheat,
              borderRadius: BorderRadius.circular(6),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildColumn(
                      title: 'Material',
                      values: tableState.materials,
                      items: materials,
                      onChanged: (row, value) =>
                          tableNotifier.updateCell(row: row, column: 'Material', value: value),
                    ),
                    const SizedBox(width: 10),
                    _buildColumn(
                      title: 'Country',
                      values: tableState.countries,
                      items: countries,
                      onChanged: (row, value) =>
                          tableNotifier.updateCell(row: row, column: 'Country', value: value),
                    ),
                    const SizedBox(width: 10),
                    _buildColumn(
                      title: 'Mass (kg)',
                      values: tableState.masses,
                      isTextField: true,
                      onChanged: (row, value) =>
                          tableNotifier.updateCell(row: row, column: 'Mass', value: value),
                    ),
                    const SizedBox(width: 10),
                    
                  ],
                ),
              ),
            ),
          ),
        ),

        // ---------------- Calculate Button ----------------
        Row(
          children: [
            SizedBox(width: 20),

            SizedBox(
              width: 200,
              height: 35,
              child: ElevatedButton(
                onPressed: () async {
                  await ref.read(emissionCalculatorProvider.notifier).calculate('material', rows);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Apptheme.widgettertiaryclr,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Labelsinbuttons(
                  title: 'Calculate Emissions',
                  color: Apptheme.textclrdark,
                  fontsize: 15,
                ),
              ),
            ),

            SizedBox(width: 10),
          
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: tableNotifier.addRow,
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: tableNotifier.removeRow,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}


// ------------------- Manual Upstream Transport Attributes Menu -------------------
class UpstreamTransportAttributesMenu extends ConsumerWidget {
  const UpstreamTransportAttributesMenu({super.key, required WidgetRef ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(upstreamTransportTableProvider);
    final tableNotifier = ref.read(upstreamTransportTableProvider.notifier);

    final vehicles = ref.watch(transportTypesProvider);

    List<RowFormat> rows = List.generate(
      tableState.vehicles.length,
      (i) => RowFormat(
        columnTitles: ['Vehicle', 'Class', 'Distance (km)'],
        isTextFieldColumn: [false, false, true],
        selections: [
          tableState.vehicles[i],
          tableState.classes[i],
          tableState.distances[i],
        ],
      ),
    );

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildColumn(
                  title: 'Vehicle',
                  values: tableState.vehicles,
                  items: vehicles,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Vehicle', value: value),
                ),
                const SizedBox(width: 10),
                _buildDynamicColumn(
                  title: 'Class',
                  values: tableState.classes,
                  itemsPerRow: List.generate(tableState.vehicles.length, (i) {
                    // Provide fallback empty string if vehicle is null
                    final selectedVehicle = tableState.vehicles[i] ?? '';
                    return ref.watch(classOptionsProvider(selectedVehicle));
                  }),
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Class', value: value),
                ),
                const SizedBox(width: 10),
                _buildColumn(
                  title: 'Distance (km)',
                  values: tableState.distances,
                  isTextField: true,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Distance (km)', value: value),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(width: 20),
            SizedBox(
              width: 200,
              height: 35,
              child: ElevatedButton(
                onPressed: () async {
                  await ref.read(emissionCalculatorProvider.notifier)
                      .calculate('upstream_transport', rows);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Apptheme.widgettertiaryclr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Labelsinbuttons(
                  title: 'Calculate Emissions',
                  color: Apptheme.textclrdark,
                  fontsize: 15,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: tableNotifier.addRow,
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: tableNotifier.removeRow,
            ),
          ],
        ),
      ],
    );
  }
}


class MachiningAttributesMenu extends ConsumerWidget {
  const MachiningAttributesMenu({super.key, required WidgetRef ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(machiningTableProvider);
    final tableNotifier = ref.read(machiningTableProvider.notifier);

    final machines = ref.watch(mazakTypesProvider);
    final countries = ref.watch(countriesProvider);

    List<RowFormat> rows = List.generate(
      tableState.machines.length,
      (i) => RowFormat(
        columnTitles: ['Machine', 'Country', 'Time of operation (hr)'],
        isTextFieldColumn: [false, false, true],
        selections: [
          tableState.machines[i],
          tableState.countries[i],
          tableState.times[i],
        ],
      ),
    );

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildColumn(
                  title: 'Machine',
                  values: tableState.machines,
                  items: machines,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Machine', value: value),
                ),
                const SizedBox(width: 10),
                _buildColumn(
                  title: 'Country',
                  values: tableState.countries,
                  items: countries,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Country', value: value),
                ),
                const SizedBox(width: 10),
                _buildColumn(
                  title: 'Time of operation (hr)',
                  values: tableState.times,
                  isTextField: true,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Time', value: value),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(width: 20),
            SizedBox(
              width: 200,
              height: 35,
              child: ElevatedButton(
                onPressed: () async {
                  await ref.read(emissionCalculatorProvider.notifier).calculate('machining', rows);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Apptheme.widgettertiaryclr,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Labelsinbuttons(
                  title: 'Calculate Emissions',
                  color: Apptheme.textclrdark,
                  fontsize: 15,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: tableNotifier.addRow,
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: tableNotifier.removeRow,
            ),
          ],
        ),
      ],
    );
  }
}

class FugitiveLeaksAttributesMenu extends ConsumerWidget {
  const FugitiveLeaksAttributesMenu({super.key, required WidgetRef ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(fugitiveLeaksTableProvider);
    final tableNotifier = ref.read(fugitiveLeaksTableProvider.notifier);

    final ghgList = ref.watch(ghgProvider);

    List<RowFormat> rows = List.generate(
      tableState.ghg.length,
      (i) => RowFormat(
        columnTitles: ['GHG', 'Total Charge (kg)', 'Remaining Charge (kg)'],
        isTextFieldColumn: [false, true, true],
        selections: [
          tableState.ghg[i],
          tableState.totalCharge[i],
          tableState.remainingCharge[i],
        ],
      ),
    );

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildColumn(
                  title: 'GHG',
                  values: tableState.ghg,
                items: ghgList,
                onChanged: (row, value) =>
                    tableNotifier.updateCell(row: row, column: 'GHG', value: value),
              ),
              const SizedBox(width: 10),
              _buildColumn(
                title: 'Total Charge (kg)',
                values: tableState.totalCharge,
                isTextField: true,
                onChanged: (row, value) =>
                    tableNotifier.updateCell(row: row, column: 'Total', value: value),
              ),
              const SizedBox(width: 10),
              _buildColumn(
                title: 'Remaining Charge (kg)',
                values: tableState.remainingCharge,
                isTextField: true,
                onChanged: (row, value) =>
                    tableNotifier.updateCell(row: row, column: 'Remaining', value: value),
              ),
            ],
          ),
          ),
        ),
        Row(
          children: [
            SizedBox(width: 20),
            SizedBox(
              width: 200,
              height: 35,
              child: ElevatedButton(
                onPressed: () async {
                  await ref.read(emissionCalculatorProvider.notifier).calculate('fugitive', rows);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Apptheme.widgettertiaryclr,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Labelsinbuttons(
                  title: 'Calculate Emissions',
                  color: Apptheme.textclrdark,
                  fontsize: 15,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: tableNotifier.addRow,
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: tableNotifier.removeRow,
            ),
          ],
        ),
      ],
    );
  }
}



Widget _buildColumn({
  required String title,
  required List<String?> values,
  List<String>? items,
  bool isTextField = false,
  required void Function(int row, String? value) onChanged,
}) {
  return Container(
    width: 315,
    decoration: BoxDecoration(
      color: Apptheme.transparentcheat,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Apptheme.widgetclrdark),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Labels(title: title, color: Apptheme.textclrdark, fontsize: 16,),
        const SizedBox(height: 5),
        for (int i = 0; i < values.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              width: 305,
              height: 30,
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Apptheme.widgetsecondaryclr,
                borderRadius: BorderRadius.circular(6),
              ),
              child: isTextField
                  ? TextFormField(
                      initialValue: values[i],
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Apptheme.textclrlight, fontSize: 15),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Apptheme.iconsprimary),
                        ),
                      ),
                      onChanged: (value) => onChanged(i, value),
                    )
                  : DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Apptheme.widgetsecondaryclr,
                        value: (items != null && values[i] != null && items.contains(values[i]))
                            ? values[i]
                            : null,
                        hint: const Text("Select"),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Apptheme.iconslight),
                        items: (items ?? [])
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: TextStyle(color: Apptheme.textclrlight, fontSize: 15),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => onChanged(i, value),
                      ),

                    ),
            ),
          ),
      ],
    ),
  );
}

Widget _buildDynamicColumn({
  required String title,
  required List<String?> values,
  required List<List<String>> itemsPerRow,
  bool isTextField = false,
  required void Function(int row, String? value) onChanged,
}) {
  return Container(
    width: 315,
    decoration: BoxDecoration(
      color: Apptheme.transparentcheat,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Apptheme.widgetclrdark),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Labels(title: title, color: Apptheme.textclrdark, fontsize: 16,),
        const SizedBox(height: 5),
        for (int i = 0; i < values.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              width: 305,
              height: 30,
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Apptheme.widgetsecondaryclr,
                borderRadius: BorderRadius.circular(6),
              ),
              child: isTextField
                  ? TextFormField(
                      initialValue: values[i],
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Apptheme.textclrlight, fontSize: 15),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Apptheme.iconsprimary),
                        ),
                      ),
                      onChanged: (value) => onChanged(i, value),
                    )
                  : DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Apptheme.widgetsecondaryclr,
                        value: (itemsPerRow[i].contains(values[i])) ? values[i] : null,
                        hint: const Text("Select"),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Apptheme.iconslight),
                        items: itemsPerRow[i]
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: TextStyle(color: Apptheme.textclrlight, fontSize: 15),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => onChanged(i, value),
                      ),
                    ),
            ),
          ),
      ],
    ),
  );
}







