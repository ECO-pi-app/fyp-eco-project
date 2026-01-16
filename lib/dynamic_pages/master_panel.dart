import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:test_app/app_logic/river_controls.dart';
import 'package:test_app/app_logic/riverpod_calculation.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';




class MasterPanel extends ConsumerStatefulWidget {
  final String profileName;

  const MasterPanel({super.key, required this.profileName });


  @override
  ConsumerState<MasterPanel> createState() => _MasterPanelState();
}

class _MasterPanelState extends ConsumerState<MasterPanel> {

int selectedToggle = 0;

double pieChartSize = 240;
int touchedIndex = -1;

final List<String> toggleOptions = [
  'Attributes',
  'Scopes',
  'Boundary'
];

String getPercentageTitle(double value, double total) {
  final percent = (value / total * 100).round();
  return '$percent%';
}


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
      final key = (product: product, part: part);

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
for (int i = 0; i < rowCount; i++) {
  final normal = ref.watch(
    convertedEmissionRowProvider((product, part, EmissionCategory.materialNormal, i))
  );
  final material = ref.watch(
    convertedEmissionRowProvider((product, part, EmissionCategory.material, i))
  );
  final transport = ref.watch(
    convertedEmissionRowProvider((product, part, EmissionCategory.transportUpstream, i))
  );
  final machining = ref.watch(
    convertedEmissionRowProvider((product, part, EmissionCategory.machining, i))
  );
  final fugitive = ref.watch(
    convertedEmissionRowProvider((product, part, EmissionCategory.fugitive, i))
  );
  final prodTransport = ref.watch(
    convertedEmissionRowProvider((product, part, EmissionCategory.productionTransport, i))
  );
  final downstream = ref.watch(
    convertedEmissionRowProvider((product, part, EmissionCategory.transportDownstream, i))
  );
  final waste = ref.watch(
    convertedEmissionRowProvider((product, part, EmissionCategory.waste, i))
  );
  final usage = ref.watch(
    convertedEmissionRowProvider((product, part, EmissionCategory.usageCycle, i))
  );
  final endOfLife = ref.watch(
    convertedEmissionRowProvider((product, part, EmissionCategory.endOfLife, i))
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


    final List<Map<String, double>> toggleTotals = [
      // LCA Categories
      {
        'Material : ': totalMaterial + totalNormalMaterial,
        'Transport : ': totalTransport + totalDownstreamTransport + totalProductionTransport,
        'Machining : ': totalMachining,
        'Fugitive : ': totalFugitive,
        'Usage Cycle : ' : totalUsageCycle,
        'End of Life : ' : totalEndOfLife,
      },
      // Scope Categories
      {
        'Scope 1': 0 ,
        'Scope 2': totalMachining,
        'Category 1/2': totalMaterial + totalNormalMaterial,
        'Category 4' : totalTransport,
        'Category 5' : totalWaste,
        'Category 9' : totalDownstreamTransport,
        'Category 10' : 0,
        'Category 11' : totalUsageCycle,
        'Category 12' : totalEndOfLife,

      },
      // Boundary
      {
        'Upstream': totalMaterial + totalTransport,
        'Production': totalMachining+ totalFugitive + totalProductionTransport + totalWaste,
        'Downstream': totalUsageCycle+ totalEndOfLife,
      },
    ];

    final currentData = toggleTotals[selectedToggle];
    final total = currentData.values.fold<double>(0, (sum, value) => sum + value);


    final List<List<PieChartSectionData>> pieDataSets = [
      //--Sort by: Attributes--
      [
        PieChartSectionData(
          color: Apptheme.piechart1,
          value: totalMaterial + totalNormalMaterial,
          title: 'Material Acqusition',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart2,
          value: totalTransport + totalProductionTransport +totalDownstreamTransport,
          title: 'Transport',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart3,
          value: totalMachining,
          title: 'Machining',
          radius: pieChartSize/2,
        ),

      PieChartSectionData(
          color: Apptheme.piechart4,
          value: totalFugitive,
          title: 'Fugitive',
          radius: pieChartSize/2,
        ),
      PieChartSectionData(
          color: Apptheme.piechart4,
          value: totalUsageCycle,
          title: 'Usage Cycle',
          radius: pieChartSize/2,
        ),
      PieChartSectionData(
        color: Apptheme.piechart5,
        value: totalEndOfLife,
        title: 'End of Life',
        radius: pieChartSize/2,
      )
      ],
      //--Sort by: Scope Categories--
      [
        PieChartSectionData(
          color: Apptheme.piechart1,
          value: 0,
          title: 'Scope 1',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart2,
          value: totalMachining,
          title: 'Scope 2',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart3,
          value: totalMaterial + totalNormalMaterial,
          title: 'Category 1/2',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart4,
          value: totalTransport,
          title: 'Category 4',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart5,
          value: totalWaste,
          title: 'Category 5',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart6,
          value: totalDownstreamTransport,
          title: 'Category 9',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart7,
          value: 0,
          title: 'Category 10',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart8,
          value: totalUsageCycle,
          title: 'Category 11',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart9,
          value: totalEndOfLife,
          title: 'Category 12',
          radius: pieChartSize/2,
        ),
      ],
      //--Sort by: Boundaries--
      [
        PieChartSectionData(
          color: Apptheme.piechart1,
          value: totalMaterial + totalTransport,
          title: 'Upstream',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart2,
          value: totalMachining+ totalFugitive + totalProductionTransport + totalWaste,
          title: 'Production',
          radius: pieChartSize/2,
        ),

        PieChartSectionData(
          color: Apptheme.piechart3,
          value: totalUsageCycle+ totalEndOfLife,
          title: 'Downstream',
          radius: pieChartSize/2,
        ),
      ],
    ];
        
    List<PieChartSectionData> showingSections() {
      final data = pieDataSets[selectedToggle];
      final total = data.fold<double>(0, (sum, item) => sum + item.value);

      if (total == 0) {
       
        return [
          PieChartSectionData(
            color: Apptheme.widgetsecondaryclr, // color of the placeholder
            value: 1,
            title: 'No Data Defined',
            radius: pieChartSize / 2,
            titleStyle: bodyTextlightmini(16).copyWith(color: Apptheme.textclrlight),
            titlePositionPercentageOffset: 0,
          )
        ];
      }

      return List.generate(data.length, (i) {
        final section = data[i];
        final isTouched = i == touchedIndex;

        final double fontSize = isTouched ? 22 : 16;
        final double radius = isTouched ? (pieChartSize / 2 + 8) : (pieChartSize / 2);

        return section.copyWith(
          radius: radius,
          titleStyle:bodyTextlightmini(fontSize),
          title:  getPercentageTitle(section.value, total),
        );
      });
    }


    return Column(
        children: [
                
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Apptheme.widgetclrlight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )
              ),
              width: 320,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Apptheme.widgetsecondaryclr,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      )
                    ),
                    height: 25,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0),
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          Textsinsidewidgets(
                            words: widget.profileName, 
                            color: Apptheme.textclrlight,
                            fontsize: 17,
                            fontweight: FontWeight.w600,
                            toppadding: 0,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 35,
                    child: Row(
                      children: [
                    
                        const SizedBox(width: 15,),
                    
                        Textsinsidewidgets(
                          words: 'Sort  |', 
                          color: Apptheme.textclrdark,
                          fontsize: 15,
                          toppadding: 0,
                        ),
                    
                        const SizedBox(width: 8),
                    
                        SizedBox(
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: DropdownButton<int>(
                              isExpanded: true,
                              value: selectedToggle,
                              dropdownColor: Apptheme.widgetclrlight,
                              iconEnabledColor: Apptheme.textclrdark,
                              items: List.generate(toggleOptions.length, (index) {
                                return DropdownMenuItem<int>(
                                  value: index,
                                  child: Textsinsidewidgets(
                                    words: toggleOptions[index], 
                                    color: Apptheme.textclrdark,
                                    fontsize: 15,
                                    toppadding: 0,
                                  )
                                );
                              }),
                              onChanged: (int? newIndex) {
                                if (newIndex != null) {
                                  setState(() {
                                    selectedToggle = newIndex;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
                          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ListView(
                children: [
                  Container(height: 10,width: 50, color: Apptheme.transparentcheat,), //ONLY FOR DEBUGGING
              
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: pieChartSize,
                      child: PieChart(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        PieChartData(
                          centerSpaceRadius: 0,
                          sectionsSpace: 0,
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    response == null ||
                                    response.touchedSection == null) {
                                  touchedIndex = -1;
                                } else {
                                  touchedIndex =
                                      response.touchedSection!.touchedSectionIndex;
                                }
                              });
                            },
                          ),
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 10,),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: total == 0
                        ? [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Apptheme.widgetsecondaryclr,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Textsinsidewidgets(
                                    words: 'No Data Defined', 
                                    color: Apptheme.textclrdark,
                                  ),
                                ],
                              ),
                            )
                          ]
                        : List.generate(toggleTotals[selectedToggle].length, (i) {
                            final key = toggleTotals[selectedToggle].keys.elementAt(i);
                            final value = toggleTotals[selectedToggle].values.elementAt(i);
                            final color = pieDataSets[selectedToggle][i].color;
                  
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  RichTextsInsideWidget(
                                    firstPart: key,
                                    firstColor: color,
                                    secondPart: ' ${value.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO2e',
                                    secondColor: Apptheme.textclrdark,
                                  )
                                ],
                              ),
                            );
                          }),
                  ),
                  
                  SizedBox(height: 10,),
                      
                  
                
                ],
              ),
            ),
          )  
          
        ],
      );

  }
}



         