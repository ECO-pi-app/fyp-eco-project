import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/auto_tabs.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/info_popup.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/app_logic/river_controls.dart';
import 'package:test_app/app_logic/riverpod_calculation.dart';
import 'package:test_app/app_logic/riverpod_fetch.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
import 'package:test_app/dynamic_pages/main_productanlys.dart';
import 'package:test_app/dynamic_pages/popup_pages.dart';

class Scopeanalysis extends ConsumerStatefulWidget {
  final String productID;
  const Scopeanalysis({super.key, required this.productID});

  @override
  ConsumerState<Scopeanalysis> createState() => ScopeanalysisState();
}

class ScopeanalysisState extends ConsumerState<Scopeanalysis> {

  bool showThreePageTabs = true;

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(activeProductProvider);
    final part = ref.watch(activePartProvider);

    double totalNormalMaterial = 0;
    double totalMaterial = 0;
    double totalTransport = 0;
    double totalMachining = 0;
    double totalFugitive = 0;
    double totalProductionTransport = 0;
    double totalWaste = 0;
    double totalDownstreamTransport = 0;
    double totalUsageCycle = 0;
    double totalEndOfLife = 0;

    if (product != null && part != null) {
      final key = (product: product.name, part: part);

      // Get each table individually
      final normalMaterialTable = ref.watch(normalMaterialTableProvider(key));
      final materialTable = ref.watch(materialTableProvider(key));
      final transportTable = ref.watch(upstreamTransportTableProvider(key));
      final machiningTable = ref.watch(machiningTableProvider(key));
      final fugitiveTable = ref.watch(fugitiveLeaksTableProvider(key));
      final productionTransportTable = ref.watch(productionTransportTableProvider(key));
      final downsteamTransportTable = ref.watch(downstreamTransportTableProvider(key));
      final wasteTable = ref.watch(wastesProvider(key));
      final usageCycleTable = ref.watch(usageCycleTableProvider(key));
      final endOfLifeTable = ref.watch(endOfLifeTableProvider(key));

      // Determine the number of rows (use the longest table as row count)
      final rowCount = [
        normalMaterialTable.normalMaterials.length,
        materialTable.materials.length,
        transportTable.vehicles.length,
        machiningTable.machines.length,
        fugitiveTable.ghg.length,
        productionTransportTable.vehicles.length,
        downsteamTransportTable.vehicles.length,
        wasteTable.wasteType.length,
        usageCycleTable.categories.length,
        endOfLifeTable.endOfLifeOptions.length,
      ].reduce((a, b) => a > b ? a : b);

      // Loop through each row and sum the converted emissions
      // Loop through each row and sum the converted emissions
for (int i = 0; i < rowCount; i++) {
  final normal = ref.watch(
    convertedEmissionRowProvider((product.name, part, EmissionCategory.materialNormal, i))
  );
  final material = ref.watch(
    convertedEmissionRowProvider((product.name, part, EmissionCategory.material, i))
  );
  final transport = ref.watch(
    convertedEmissionRowProvider((product.name, part, EmissionCategory.transportUpstream, i))
  );
  final machining = ref.watch(
    convertedEmissionRowProvider((product.name, part, EmissionCategory.machining, i))
  );
  final fugitive = ref.watch(
    convertedEmissionRowProvider((product.name, part, EmissionCategory.fugitive, i))
  );
  final prodTransport = ref.watch(
    convertedEmissionRowProvider((product.name, part, EmissionCategory.productionTransport, i))
  );
  final downstream = ref.watch(
    convertedEmissionRowProvider((product.name, part, EmissionCategory.transportDownstream, i))
  );
  final waste = ref.watch(
    convertedEmissionRowProvider((product.name, part, EmissionCategory.waste, i))
  );
  final usage = ref.watch(
    convertedEmissionRowProvider((product.name, part, EmissionCategory.usageCycle, i))
  );
  final endOfLife = ref.watch(
    convertedEmissionRowProvider((product.name, part, EmissionCategory.endOfLife, i))
  );

  totalNormalMaterial += normal.materialNormal;
  totalMaterial += material.material;
  totalTransport += transport.transport;
  totalMachining += machining.machining;
  totalFugitive += fugitive.fugitive;
  totalProductionTransport += prodTransport.productionTransport;
  totalDownstreamTransport += downstream.downstreamTransport;
  totalWaste += waste.waste;
  totalUsageCycle += usage.usageCycle;
  totalEndOfLife += endOfLife.endofLife;
}
    }

    if (product == null || part == null) {
      return const SizedBox();
    }

    final key = (product: product.name, part: part);

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

    final List<Widget> widgetofpage1 = [
      Labels(
        title: 'Manufacturing',
        color: Apptheme.textclrdark,
        toppadding: 0,
        fontsize: 22,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Machining | ${totalMachining.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
            fontsize: 17,
          ),
          Row(
            children: [
              sectionRow(
                title: "Machining",
                tooltip: "Adjust machining allocation",
                popupContent: buildMachiningTable(
                  machiningState,
                  machiningNotifier,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InfoIconPopupDark(
                  text: 'Power consumed during the operation of all processes required to create a product',
                ),
              ),
            ],
          ),
        ],
      ),
      MachiningAttributesMenu(productID: widget.productID),

      Labels(
        title: 'Optional Processes',
        color: Apptheme.textclrdark,
        toppadding: 30,
        fontsize: 22,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Fugitive leaks |  ${totalFugitive.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
            fontsize: 17,
          ),
          Row(
            children: [
              sectionRow(
                title: "Fugitive Leaks",
                tooltip: "Adjust fugitive emissions allocation",
                popupContent: buildFugitiveLeaksTable(
                  leaksState,
                  leaksNotifier,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InfoIconPopupDark(
                  text: 'Greenhouse Gases used by equipments as part of their functioning needs released into the atmosphere due to leak, damage or wear',
                ),
              ),
            ],
          ),
        ],
      ),
      FugitiveLeaksAttributesMenu(productID: widget.productID),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Production Transportation | ${totalProductionTransport.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
            fontsize: 17,
          ),
          Row(
            children: [
              GoogleMapsIconButton(
              ),
              sectionRow(
                title: "Production Transport",
                tooltip: "Adjust production transport allocation",
                popupContent: buildProductionTransportTable(
                  productionTransportState,
                  productionTransportNotifier,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InfoIconPopupDark(
                  text: 'Greenhouse Gases used by equipments as part of their functioning needs released into the atmosphere due to leak, damage or wear',
                ),
              ),
            ],
          ),
        ],
      ),
      ProductionTransportAttributesMenu(productID: widget.productID),
    ];

    final List<Widget> widgetofpage2 = [

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Category 1 & 2',
            color: Apptheme.textclrdark,
            toppadding: 0,
            fontsize: 22,
          ),
          InfoIconPopupDark(
            text: 'Sourcing and manufacturing/refining of raw materials purchased and used during production',
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Material Input | ${totalNormalMaterial.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
            fontsize: 17,
          ),
          sectionRow(
            title: "Material Acquisition",
            tooltip: "Fine-tune raw material inputs",
            popupContent: buildNormalMaterialTable(
              normalMaterialState,
              normalMaterialNotifier,
            ),
          ),
        ],
      ),
      NormalMaterialAttributesMenu(productID: widget.productID),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Custom Material Input | ${totalMaterial.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
            fontsize: 17,
          ),

          sectionRow(
            title: "Recycled Material Acquisition",
            tooltip: "Fine-tune recycled material inputs",
            popupContent: buildMaterialTable(
              materialState,
              materialNotifier,
            ),
          ),
        ],
      ),
      MaterialAttributesMenu(productID: widget.productID),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Category 4',
            color: Apptheme.textclrdark,
            toppadding: 30,
            fontsize: 22,
          ),
          InfoIconPopupDark(
            text: 'Transportation of materials purchased from it\'s origin to the production facility\'s gate.',
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Upstream Transportation | ${totalTransport.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
            fontsize: 17,
          ),
          Row(
            children: [
              GoogleMapsIconButton(
              ),
              sectionRow(
                title: "Upstream Transport",
                tooltip: "Adjust upstream transport allocation",
                popupContent: buildUpstreamTransportTable(
                  upstreamTransportState,
                  upstreamTransportNotifier,
                ),
              ),
            ],
          ),
        ],
      ),
      UpstreamTransportAttributesMenu(productID: widget.productID),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Category 5',
            color: Apptheme.textclrdark,
            toppadding: 30,
            fontsize: 22,
          ),
          InfoIconPopupDark(
            text: 'Wastes produced throughout the life cycle of the product that are generated during manufacturing processes.',
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Waste |  ${totalWaste.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
            fontsize: 17,
          ),
          sectionRow(
            title: "Manufacturing Wastes",
            tooltip: "Adjust waste mass allocation",
            popupContent: buildWasteTable(
              wasteTransportState,
              wasteTransportNotifier,
            ),
          ),
        ],
      ),
      WasteMaterialAttributesMenu(productID: widget.productID),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Category 9',
            color: Apptheme.textclrdark,
            toppadding: 30,
            fontsize: 22,
          ),
          InfoIconPopupDark(
            text: 'Transportation of finished products from the production facility to the end user.',
          ),  
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Downstream Transportation | ${totalDownstreamTransport.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
          ),
          Row(
            children: [
              GoogleMapsIconButton(
              ),
              sectionRow(
                title: "Downstream Transportation",
                tooltip: "Adjust downstream transport allocation",
                popupContent: buildDownstreamTransportTable(
                  downstreamTransportState,
                  downstreamTransportNotifier,
                ),
              ),
            ],
          ),
        ],
      ),
      DownstreamTransportAttributesMenu(productID: widget.productID),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Category 11',
            color: Apptheme.textclrdark,
            toppadding: 30,
            fontsize: 22,
          ),
          InfoIconPopupDark(
            text: 'Emissions generated during the use phase of the product by the end user.',
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Usage Cycle | ${totalUsageCycle.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
          ),
          Row(
            children: [
              sectionRow(
                title: "Usage Cycle",
                tooltip: "Adjust usage cycle allocation",
                popupContent: buildUsageCycleTable(
                  usageCycleState,
                  usageCycleNotifier,
                ),
              ),
            ],
          ),
        ],
      ),
      UsageCycleAttributesMenu(productID: widget.productID),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'Category 12',
            color: Apptheme.textclrdark,
            toppadding: 30,
            fontsize: 22,
          ),
          InfoIconPopupDark(
            text: 'Emissions from the disposal and treatment of the product at the end of its useful life.',
          ),],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Labels(
            title: 'End of Life |  ${totalEndOfLife.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO₂',
            color: Apptheme.textclrdark,
          ),
          Row(
            children: [
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
        ],
      ),
      EndofLifeAttributesMenu(productID: widget.productID),
    ];

    final List<Widget> widgetofpage3 = [
    ];

    return PrimaryPages(
      childofmainpage: Column(
        children: [
          Expanded(
            child: showThreePageTabs
                ? ManualTab3pages(
                    backgroundcolor: Apptheme.transparentcheat,
                    tab1: 'Main',
                    tab1fontsize: 15,
                    tab2: 'Scope 3',
                    tab2fontsize: 15,
                    tab3: 'Disclaimer',
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







