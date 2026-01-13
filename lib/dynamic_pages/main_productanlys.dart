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
  final String productID;
  const Dynamicprdanalysis({super.key, required this.productID});

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
    final emissions = ref.watch(convertedEmissionsProvider(widget.productID));

    // ------------------- Page 1 Widgets (Upstream) -------------------
    final List<Widget> widgetofpage1 = [
      
      Labels(
        title: 'Primary Inputs',
        color: Apptheme.textclrdark,
        toppadding: 0,
        fontsize: 22,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Material Input | ${emissions.material.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
            fontsize: 17,
          ),

          Row(
            children: [
              SizedBox(
                width: 35,
                height: 20,
                child: InkWell(
                  onTap: () => showAdvancedMaterials(context),
                  child: Icon(Icons.tune, 
                    color: Apptheme.iconsdark,
                    size: 17,
                    ),
                ),
              ),
              SizedBox(width: 10),
              InfoIconPopupDark(
                text: 'Sourcing and manufacturing/refining of raw materials purchased and used during production',
              ),
            ],
          ),
        ],
      ),
      MaterialAttributesMenu(productID: widget.productID),


      Labels(
        title: 'Secondary Inputs',
        color: Apptheme.textclrdark,
        toppadding: 30,
        fontsize: 22,
      ),
      //--ROW 2: Upstream Transportation--
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Upstream Transportation | ${emissions.transport.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
            fontsize: 17,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InfoIconPopupDark(
              text: 'Transporting of materials purchased from it\'s origin to the production facility\'s gate.',
              
            ),
          ),
        ],
      ),
      UpstreamTransportAttributesMenu(productID: widget.productID)
    ];

    // ------------------- Pages 2 & 3 remain unchanged -------------------
    final List<Widget> widgetofpage2 = [
      Labels(
        title: 'Primary Processes',
        color: Apptheme.textclrdark,
        toppadding: 0,
        fontsize: 22,
      ),
      //--ROW 1: Machining--
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Machining | ${emissions.machining.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
            fontsize: 17,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InfoIconPopupDark(
              text: 'Power consumed during the operation of all processes required to create a product',
            ),
          ),
        ],
      ),
      MachiningAttributesMenu(productID: widget.productID),


      Labels(
        title: 'Secondary Processes',
        color: Apptheme.textclrdark,
        toppadding: 30,
        fontsize: 22,
      ),

      //--ROW 2: Fugitive leaks--
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Fugitive leaks | ${emissions.fugitive.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
            fontsize: 17,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InfoIconPopupDark(
              text: 'Greenhouse Gases used by equipments as part of their functioning needs released into the atmosphere due to leak, damage or wear',
            ),
          ),
        ],
      ),
      FugitiveLeaksAttributesMenu(productID: widget.productID),

      //-Row 3: Production Transport --
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Production Transportation | ${emissions.productionTransport.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
            fontsize: 17,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InfoIconPopupDark(
              text: 'Greenhouse Gases used by equipments as part of their functioning needs released into the atmosphere due to leak, damage or wear',
            ),
          ),
        ],
      ),
      ProductionTransportAttributesMenu(productID: widget.productID)
    ];

    final List<Widget> widgetofpage3 = [
      //--ROW 1: Downstream Distribution--
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Usage Cycle | ${emissions.usageCycle.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InfoIconPopupDark(
              text: 'Emissions from the usage of the product by the end user.',
            ),
          ),
        ],
      ),
      UsageCycleAttributesMenu(productID: widget.productID),


      //--ROW 2: End of Life--
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'End of Life | ${emissions.endofLife.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InfoIconPopupDark(
              text: 'Emissions from the disposal and treatment of the product at the end of its useful life.',
            ),
          ),
        ],
      ),
      EndofLifeAttributesMenu(productID: widget.productID),
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
  final String productID;

  const MaterialAttributesMenu({super.key, required this.productID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(materialTableProvider(productID));
    final tableNotifier = ref.read(materialTableProvider(productID).notifier);

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
                    buildColumn(
                      title: 'Material',
                      values: tableState.materials,
                      items: materials,
                      onChanged: (row, value) =>
                          tableNotifier.updateCell(row: row, column: 'Material', value: value),
                    ),
                    const SizedBox(width: 10),
                    buildColumn(
                      title: 'Country',
                      values: tableState.countries,
                      items: countries,
                      onChanged: (row, value) =>
                          tableNotifier.updateCell(row: row, column: 'Country', value: value),
                    ),
                    const SizedBox(width: 10),
                    buildColumn(
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
                  await ref.read(emissionCalculatorProvider(productID).notifier).calculate('material', rows);
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

class UpstreamTransportAttributesMenu extends ConsumerWidget {
  final String productID;
  const UpstreamTransportAttributesMenu({super.key,required this.productID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(upstreamTransportTableProvider(productID));
    final tableNotifier = ref.read(upstreamTransportTableProvider(productID).notifier);

    final vehicles = ref.watch(transportTypesProvider);

    List<RowFormat> rows = List.generate(
      tableState.vehicles.length,
      (i) => RowFormat(
        columnTitles: ['Vehicle', 'Class', 'Distance (km)', 'Mass (kg)'],
        isTextFieldColumn: [false, false, true, true],
        selections: [
          tableState.vehicles[i],
          tableState.classes[i],
          tableState.distances[i],
          tableState.masses[i],
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
                buildColumn(
                  title: 'Vehicle',
                  values: tableState.vehicles,
                  items: vehicles,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Vehicle', value: value),
                ),
                const SizedBox(width: 10),
                buildDynamicColumn(
                  title: 'Class',
                  values: tableState.classes,
                  itemsPerRow: List.generate(tableState.vehicles.length, (i) {
                    final selectedVehicle = tableState.vehicles[i] ?? '';
                    return ref.watch(classOptionsProvider(selectedVehicle));
                  }),
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Class', value: value),
                ),
                const SizedBox(width: 10),
                buildColumn(
                  title: 'Distance (km)',
                  values: tableState.distances,
                  isTextField: true,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Distance (km)', value: value),
                ),
                const SizedBox(width: 10),
                buildColumn(
                  title: 'Mass (kg)',
                  values: tableState.masses,
                  isTextField: true,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Mass (kg)', value: value),
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
                  await ref.read(emissionCalculatorProvider(productID).notifier)
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
  final String productID;
  const MachiningAttributesMenu({super.key, required this.productID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(machiningTableProvider(productID));
    final tableNotifier = ref.read(machiningTableProvider(productID).notifier);

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
                buildColumn(
                  title: 'Machine',
                  values: tableState.machines,
                  items: machines,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Machine', value: value),
                ),
                const SizedBox(width: 10),
                buildColumn(
                  title: 'Country',
                  values: tableState.countries,
                  items: countries,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Country', value: value),
                ),
                const SizedBox(width: 10),
                buildColumn(
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
                  await ref.read(emissionCalculatorProvider(productID).notifier).calculate('machining', rows);
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
  final String productID;
  const FugitiveLeaksAttributesMenu({super.key, required this.productID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(fugitiveLeaksTableProvider(productID));
    final tableNotifier = ref.read(fugitiveLeaksTableProvider(productID).notifier);

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
                buildColumn(
                  title: 'GHG',
                  values: tableState.ghg,
                items: ghgList,
                onChanged: (row, value) =>
                    tableNotifier.updateCell(row: row, column: 'GHG', value: value),
              ),
              const SizedBox(width: 10),
              buildColumn(
                title: 'Total Charge (kg)',
                values: tableState.totalCharge,
                isTextField: true,
                onChanged: (row, value) =>
                    tableNotifier.updateCell(row: row, column: 'Total', value: value),
              ),
              const SizedBox(width: 10),
              buildColumn(
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
                  await ref.read(emissionCalculatorProvider(productID).notifier).calculate('fugitive', rows);
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

class ProductionTransportAttributesMenu extends ConsumerWidget {
  final String productID;
  const ProductionTransportAttributesMenu({super.key,required this.productID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(productionTransportTableProvider(productID));
    final tableNotifier = ref.read(productionTransportTableProvider(productID).notifier);

    final vehicles = ref.watch(transportTypesProvider);

    List<RowFormat> rows = List.generate(
      tableState.vehicles.length,
      (i) => RowFormat(
        columnTitles: ['Vehicle', 'Class', 'Distance (km)', 'Mass (kg)'],
        isTextFieldColumn: [false, false, true, true],
        selections: [
          tableState.vehicles[i],
          tableState.classes[i],
          tableState.distances[i],
          tableState.masses[i],
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
                buildColumn(
                  title: 'Vehicle',
                  values: tableState.vehicles,
                  items: vehicles,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Vehicle', value: value),
                ),
                const SizedBox(width: 10),
                buildDynamicColumn(
                  title: 'Class',
                  values: tableState.classes,
                  itemsPerRow: List.generate(tableState.vehicles.length, (i) {
                    final selectedVehicle = tableState.vehicles[i] ?? '';
                    return ref.watch(classOptionsProvider(selectedVehicle));
                  }),
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Class', value: value),
                ),
                const SizedBox(width: 10),
                buildColumn(
                  title: 'Distance (km)',
                  values: tableState.distances,
                  isTextField: true,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Distance (km)', value: value),
                ),
                const SizedBox(width: 10),
                buildColumn(
                  title: 'Mass (kg)',
                  values: tableState.masses,
                  isTextField: true,
                  onChanged: (row, value) =>
                      tableNotifier.updateCell(row: row, column: 'Mass (kg)', value: value),
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
                  await ref.read(emissionCalculatorProvider(productID).notifier)
                      .calculate('production_transport', rows);
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


class UsageCycleAttributesMenu extends ConsumerWidget {
  final String productID;
  const UsageCycleAttributesMenu({super.key, required this.productID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(usageCycleTableProvider(productID));
    final tableNotifier = ref.read(usageCycleTableProvider(productID).notifier);

    final usageCycleCategories = ref.watch(usageCycleCategoriesProvider);

    // Build rows for calculation
    List<RowFormat> rows = List.generate(
      tableState.usageCycleAllocationValues.length,
      (i) => RowFormat(
        columnTitles: ['Category', 'Product', 'Usage Frequency'],
        isTextFieldColumn: [false, false, true],
        selections: [
          tableState.categories[i],
          tableState.productTypes[i],
          tableState.usageFrequencies[i],
        ],
      ),
    );

    return Column(
      children: [
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
                    // ---------------- Category Column ----------------
                    buildColumn(
                      title: 'Category',
                      values: tableState.categories,
                      items: usageCycleCategories,
                      onChanged: (row, value) =>
                          tableNotifier.updateCell(row: row, column: 'Category', value: value),
                    ),
                    const SizedBox(width: 10),

                    // ---------------- Product Column ----------------
                    buildDynamicColumn(
                      title: 'Product',
                      values: tableState.productTypes,
                      itemsPerRow: List.generate(tableState.categories.length, (i) {
                        final selectedCategory = tableState.categories[i] ?? '';

                        // Watch the correct provider depending on the category
                        switch (selectedCategory) {
                          case 'Electronics':
                            return ref.watch(usageCycleElectronicsProvider);
                          case 'Energy':
                            return ref.watch(usageCycleEnergyProvider);
                          case 'Consumables':
                            return ref.watch(usageCycleConsumablesProvider);
                          case 'Services':
                            return ref.watch(usageCycleServicesProvider);
                          default:
                            return <String>[];
                        }
                      }),
                      onChanged: (row, value) =>
                          tableNotifier.updateCell(row: row, column: 'Product Type', value: value),
                    ),
                    const SizedBox(width: 10),

                    // ---------------- Usage Frequency Column ----------------
                    buildColumn(
                      title: 'Usage Frequency',
                      values: tableState.usageFrequencies,
                      isTextField: true,
                      onChanged: (row, value) =>
                          tableNotifier.updateCell(row: row, column: 'Usage Frequency', value: value),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ---------------- Calculate Button & Row Controls ----------------
        Row(
          children: [
            const SizedBox(width: 20),
            SizedBox(
              width: 200,
              height: 35,
              child: ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(emissionCalculatorProvider(productID).notifier)
                      .calculate('usage_cycle', rows);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Apptheme.widgettertiaryclr,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                child: const Labelsinbuttons(
                  title: 'Calculate Emissions',
                  color: Apptheme.textclrdark,
                  fontsize: 15,
                ),
              ),
            ),
            const SizedBox(width: 10),
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


class EndofLifeAttributesMenu extends ConsumerWidget {
  final String productID;
  const EndofLifeAttributesMenu({super.key, required this.productID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(endOfLifeTableProvider(productID));
    final tableNotifier = ref.read(endOfLifeTableProvider(productID).notifier);

    final endOfLifeMethods = ref.watch(endOfLifeActivitiesProvider);

    List<RowFormat> rows = List.generate(
      tableState.endOfLifeOptions.length,
      (i) => RowFormat(
        columnTitles: ['End of Life Method', 'Product Mass', 'Percentage of Mass'],
        isTextFieldColumn: [false, true, true],
        selections: [
          tableState.endOfLifeOptions[i],
          tableState.endOfLifeTotalMass[i],
          tableState.endOfLifePercentage[i],
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
                    buildColumn(
                      title: 'End of Life Method',
                      values: tableState.endOfLifeOptions,
                      items: endOfLifeMethods,
                      onChanged: (row, value) =>
                          tableNotifier.updateCell(row: row, column: 'End of Life Method', value: value),
                    ),
                    const SizedBox(width: 10),
                    buildColumn(
                      title: 'Product Mass (kg)',
                      values: tableState.endOfLifeTotalMass,
                      isTextField: true,
                      onChanged: (row, value) =>
                          tableNotifier.updateCell(row: row, column: 'Product Mass (kg)', value: value),
                    ),
                    const SizedBox(width: 10),
                    buildColumn(
                      title: 'Percentage of Mass (%)',
                      values: tableState.endOfLifePercentage,
                      isTextField: true,
                      onChanged: (row, value) =>
                          tableNotifier.updateCell(row: row, column: 'Percentage of Mass (%)', value: value),
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
                  await ref.read(emissionCalculatorProvider(productID).notifier).calculate('end_of_life', rows);
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


Widget buildColumn({
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
                color: Apptheme.widgettertiaryclr,
                borderRadius: BorderRadius.circular(6),
              ),
              child: isTextField
                  ? TextFormField(
                      initialValue: values[i],
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Apptheme.textclrdark, fontSize: 15),
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
                        dropdownColor: Apptheme.widgettertiaryclr,
                        value: (items != null && values[i] != null && items.contains(values[i]))
                            ? values[i]
                            : null,
                        hint: const Text("Select"),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Apptheme.iconsdark),
                        items: (items ?? [])
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: TextStyle(color: Apptheme.textclrdark, fontSize: 15),
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

Widget buildDynamicColumn({
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
                color: Apptheme.widgettertiaryclr,
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
                        dropdownColor: Apptheme.widgettertiaryclr,
                        value: (itemsPerRow[i].contains(values[i])) ? values[i] : null,
                        hint: const Text("Select"),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Apptheme.iconsdark),
                        items: itemsPerRow[i]
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: TextStyle(color: Apptheme.textclrdark, fontSize: 15),
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







