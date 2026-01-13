import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:test_app/riverpod.dart';




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

    final emissions = ref.watch(convertedEmissionsProvider(widget.profileName));
    

    final List<Map<String, double>> toggleTotals = [
      // LCA Categories
      {
        'Material': emissions.material,
        'Transport': emissions.transport,
        'Machining': emissions.machining,
        'Fugitive': emissions.fugitive,
      },
      // Scope Categories
      {
        'Scope 1 (hardcoded for demo)': 60 ,
        'Scope 2 (hardcoded for demo)': 40,
        'Scope 3 (hardcoded for demo)': 30,
      },
      // Boundary
      {
        'Upstream': emissions.material + emissions.transport,
        'Production': emissions.machining+ emissions.fugitive,
        'Downstream': emissions.usageCycle+ emissions.endofLife,
      },
    ];

    final currentData = toggleTotals[selectedToggle];
    final total = currentData.values.fold<double>(0, (sum, value) => sum + value);


    final List<List<PieChartSectionData>> pieDataSets = [
      //--Sort by: Attributes--
      [
        PieChartSectionData(
          color: Apptheme.piechart1,
          value: emissions.material,
          title: 'Material Acqusition',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart2,
          value: emissions.transport,
          title: 'Upstream Transport',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart3,
          value: emissions.machining,
          title: 'Machining',
          radius: pieChartSize/2,
        ),

      PieChartSectionData(
          color: Apptheme.piechart4,
          value: emissions.fugitive,
          title: 'Fugitive',
          radius: pieChartSize/2,
        ),
      PieChartSectionData(
        color: Apptheme.piechart5,
        value: emissions.productionTransport
      )
      ],
      //--Sort by: Scope Categories--
      [
        PieChartSectionData(
          color: Apptheme.piechart1,
          value: 60,
          title: 'Scope 1',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart2,
          value: pieChartSize,
          title: 'Scope 2',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart3,
          value: 30,
          title: 'Scope 3',
          radius: pieChartSize/2,
        ),
      ],
      //--Sort by: Boundaries--
      [
        PieChartSectionData(
          color: Apptheme.piechart1,
          value: emissions.material + emissions.transport,
          title: 'Upstream',
          radius: pieChartSize/2,
        ),
        PieChartSectionData(
          color: Apptheme.piechart2,
          value: emissions.machining + emissions.fugitive,
          title: 'Production',
          radius: pieChartSize/2,
        ),

        PieChartSectionData(
          color: Apptheme.piechart3,
          value: emissions.usageCycle + emissions.endofLife,
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
                                    secondPart: ' emissions: ${value.toStringAsFixed(2)} ${ref.watch(unitLabelProvider)} CO2e',
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



         