import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/app_design.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widget_autosum.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets.dart';



class Dynamichome extends StatefulWidget {
  final VoidCallback settingstogglee;
  final VoidCallback menutogglee;
  const Dynamichome({super.key, required this.settingstogglee
  , required this.menutogglee,});


  @override
  State<Dynamichome> createState() => _DynamichomeState();
}

class _DynamichomeState extends State<Dynamichome> {

int selectedToggle = 0;

final List<String> toggleOptions = [
  'Scope',
  'Attributes',
  'Boundary'
];

final List<List<PieChartSectionData>> pieDataSets = [
  //--Sort by: Scope Categories--
  [
    PieChartSectionData(
      color: Apptheme.piechart1,
      value: 60,
      title: 'Scope 1',
      radius: 170,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrdark,
      ),
    ),
    PieChartSectionData(
      color: Apptheme.piechart2,
      value: 40,
      title: 'Scope 2',
      radius: 170,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrdark,
      ),
    ),
    PieChartSectionData(
      color: Apptheme.piechart3,
      value: 30,
      title: 'Scope 3',
      radius: 170,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrdark,
      ),
    ),
  ],
  //--Sort by: Attributes--
  [
    PieChartSectionData(
      color: Apptheme.piechart1,
      value: 5,
      title: 'Material Acqusition',
      radius: 170,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrdark,
      ),
    ),
    PieChartSectionData(
      color: Apptheme.piechart2,
      value: 2,
      title: 'Upstream Transport',
      radius: 170,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrdark,
      ),
    ),
    PieChartSectionData(
      color: Apptheme.piechart3,
      value: 3,
      title: 'Machining',
      radius: 170,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrdark,
      ),
    ),

   PieChartSectionData(
      color: Apptheme.piechart4,
      value: 2,
      title: 'Fugitive',
      radius: 170,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrdark,
      ),
    ),
  ],
  //--Sort by: Boundaries--
  [
    PieChartSectionData(
      color: Apptheme.piechart1,
      value: 155,
      title: 'Upstream',
      radius: 170,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrdark,
      ),
    ),
    PieChartSectionData(
      color: Apptheme.piechart2,
      value: 134,
      title: 'Production',
      radius: 170,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrdark,
      ),
    ),

    PieChartSectionData(
      color: Apptheme.piechart3,
      value: 98,
      title: 'Downstream',
      radius: 170,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrdark,
      ),
    ),
  ],
];

final List<Map<String, double>> toggleTotals = [
  // Scope Categories
  {
    'Scope 1': 60,
    'Scope 2': 40,
    'Scope 3': 30,
  },
  // LCA Categories
  {
    'Material': 5,
    'Transport': 2,
    'Machining': 3,
  },
  // Boundary
  {
    'Upstream': 155,
    'Production': 134,
    'Downstream': 98,
  },
];


  @override
  Widget build(BuildContext context) {
    return PrimaryPages(
      menutogglee: widget.menutogglee, 
      header: PageHeaderTwo(
        title: 'ECO-pi',
        whathappens: widget.settingstogglee,
      ),
      childofmainpage: ListView(
        children: [

          SizedBox(
            height: 40,
          ),
                
          Center(child: 
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: double.infinity,
                height: 500,
                decoration: BoxDecoration(
                  color: Apptheme.widgetclrlight,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: 
                  [BoxShadow(
                      color: Apptheme.widgetborderdark,
                      spreadRadius: 2,
                      blurRadius: 2,
                    )],
                  ),
                child: 
                Row(
                  children: [
                                  
                    Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 3),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          color: Apptheme.transparentcheat,
                          constraints: BoxConstraints(
                            minHeight: 0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                        
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Align(
                                alignment: Alignment.center,
                                child: ToggleButtons(
                                  borderRadius: BorderRadius.circular(8),
                                  isSelected: List.generate(3, (index) => index == selectedToggle),
                                  onPressed: (index) {
                                    setState(() {
                                      selectedToggle = index;
                                    });
                                  },
                                  fillColor: Apptheme.widgetsecondaryclr,         // background for selected
                                  selectedColor: Apptheme.textclrlight,          // text color for selected
                                  color: Apptheme.textclrdark,                  // text color for unselected
                                  borderColor: Apptheme.widgetborderdark,             // border for unselected
                                  selectedBorderColor: Apptheme.widgetborderlight,     // border for selected
                                  children: toggleOptions.map((e) =>
                                    SizedBox(
                                      width: 150,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ).toList(),
                                ),
                              ),
                              ),
                        
                              SizedBox(height: 20,),
                        
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Textsinsidewidgets(
                                    words: 'Total ${toggleTotals[selectedToggle].keys.elementAt(0)} emissions: ${toggleTotals[selectedToggle].values.elementAt(0).toStringAsFixed(2)} kg CO2e',
                                    color: Apptheme.textclrdark,
                                    fontsize: 18,
                                  ),
                                ),
                              ),
                        
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Textsinsidewidgets(
                                    words: 'Total ${toggleTotals[selectedToggle].keys.elementAt(1)} emissions: ${toggleTotals[selectedToggle].values.elementAt(1).toStringAsFixed(2)} kg CO2e',
                                    color: Apptheme.textclrdark,
                                    fontsize: 18,
                                  ),
                                ),
                              ),
                        
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Textsinsidewidgets(
                                    words: 'Total ${toggleTotals[selectedToggle].keys.elementAt(2)} emissions: ${toggleTotals[selectedToggle].values.elementAt(2).toStringAsFixed(2)} kg CO2e',
                                    color: Apptheme.textclrdark,
                                    fontsize: 18,
                                  ),
                                ),
                              ),
                        
                            ],
                          ),
                        ),
                      ),
                    ),
                                  
                    Expanded(
                      child: SizedBox(
                        height: 300,
                        child: PieChart(duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                          PieChartData(
                            centerSpaceRadius: 0,
                            sections:
                              pieDataSets[selectedToggle],
                          ),
                        ),
                      ),
                    ),
                  
                  ],
                ),
              ),
            )
          ),
  
          Labels(title: 'Your Products', color: Apptheme.textclrlight,),
  
          Widgets1(
            maxheight: 150,
            child: AutoaddWidget(
              color: Apptheme.widgetsecondaryclr, 
              title: 'title'
            ),
          ) 
        ],
      ),
    );
  }
}



         