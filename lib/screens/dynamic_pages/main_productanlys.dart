import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/app_design.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/auto_tabs.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/dropdown_attributes.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/riverpod.dart';

class Dynamicprdanalysis extends ConsumerStatefulWidget {
  final VoidCallback settingstogglee;
  final VoidCallback menutogglee;

  const Dynamicprdanalysis({super.key, 
  required this.settingstogglee,
  required this.menutogglee,
  });

  @override
  ConsumerState<Dynamicprdanalysis> createState() => _DynamicprdanalysisState();
}

class _DynamicprdanalysisState extends ConsumerState<Dynamicprdanalysis> {

  String? result;
  List<dynamic> tableData = [];
  double materialupstreamEmission = 0;
  double materialtransportEmission = 0;
  double fugitiveemissions = 0;
  double machiningemissions = 0;
  double totalemissions = 0;
  bool showThreePageTabs = true;

  

  final  Map<String, String> apiKeymaterials = {
      "Country": "country",
      "Material": "material",
      "Mass (kg)": "mass_kg",
  };

  final  Map<String, String> apiKeytransport = {
      "Class": "transport_type",
      "Distance": "distance_km",
  };

  final  Map<String, String> apiKeyfugitive = 
    {
      "GHG": "ghg_name",
      "Total Charge": "total_charged_amount_kg",
      "Remaining Charge": "current_charge_amount_kg",
    };

  final  Map<String, String> apiKeymachining = 
    {
      "Machine": "machine_model",
      "Country": "country",
      "Time of operation": "time_operated_hr",
    };


//Future<void> fetchTableData() async {
//final url = Uri.parse("$apiBaseUrl");

//final response = await http.get(url);
//if (response.statusCode == 200) {
//   setState(() => tableData = jsonDecode(response.body));
//   }
//}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

final List<Widget> widgetofpage1 = [
  //--ROW 1--
  Labels(
    title: 'Material Acquisition | ${materialupstreamEmission.toStringAsFixed(2)} kg CO₂',
    color: Apptheme.textclrlight,
  ),
  Widgets1(
    maxheight: 250,
    child: DynamicDropdownMaterialAcquisition(
      columnTitles: ['Country', 'Material', 'Mass (kg)'],
      isTextFieldColumn: [false, false, true],
      dropDownLists: [
        ref.watch(countriesProvider),
        ref.watch(materialsProvider),
        [],
      ],
      addButtonLabel: 'Add material',
      padding: 5,
      onTotalEmissionCalculated: (total) {
        setState(() {
          materialupstreamEmission = total;
        });
      },
      apiKeyMap: apiKeymaterials,
      endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
    ),
  ),

  //--ROW 2--
  Labels(
    title: 'Upstream Transportation | ${materialtransportEmission.toStringAsFixed(2)} kg CO₂',
    color: Apptheme.textclrlight,
  ),
  Widgets1(
    maxheight: 250,
    child: DynamicDropdownMaterialAcquisition(
      columnTitles: ['Class', 'Distance'],
      isTextFieldColumn: [false, true],
      dropDownLists: [
        ref.watch(vanModeProvider),
        [],
      ],
      addButtonLabel: 'Add transport cycle',
      padding: 5,
      onTotalEmissionCalculated: (total) {
        setState(() {
          materialtransportEmission = total;
        });
      },
      apiKeyMap: apiKeytransport,
      endpoint: 'http://127.0.0.1:8000/calculate/van',
    ),
  ),
];

final List<Widget> widgetofpage2 = [
  //--ROW 1--
  Labels(
    title: 'Machining | ${machiningemissions.toStringAsFixed(2)} kg CO₂',
    color: Apptheme.textclrlight,
  ),
  Widgets1(
    maxheight: 250,
    child: DynamicDropdownMaterialAcquisition(
      columnTitles: ['Machine', 'Country', 'Time of operation'],
      isTextFieldColumn: [false, false, true],
      dropDownLists: [
        ref.watch(mazakTypesProvider),
        ref.watch(countriesProvider),
        [],
      ],
      addButtonLabel: 'Add machine cycle',
      padding: 5,
      apiKeyMap: apiKeymachining,
      endpoint: 'http://127.0.0.1:8000/calculate/machine_power_emission',
      onTotalEmissionCalculated: (total) {
        setState(() {
          machiningemissions = total;
        });
      },
    ),
  ),

  //--ROW 2--
  Labels(
    title: 'Fugitive leaks | ${fugitiveemissions.toStringAsFixed(2)} kg CO₂',
    color: Apptheme.textclrlight,
  ),
  Widgets1(
    maxheight: 250,
    child: DynamicDropdownMaterialAcquisition(
      columnTitles: ['GHG', 'Total Charge', 'Remaining Charge'],
      isTextFieldColumn: [false, true, true],
      dropDownLists: [
        ref.watch(ghgProvider),
        [],
        [],
      ],
      addButtonLabel: 'Add GHG',
      padding: 5,
      onTotalEmissionCalculated: (total) {
        setState(() {
          fugitiveemissions = total;
        });
      },
      apiKeyMap: apiKeyfugitive,
      endpoint: 'http://127.0.0.1:8000/calculate/fugitive_emissions',
    ),
  ),
];

final List<Widget> widgetofpage3 = [
  //--ROW 1--
  Labels(
    title: 'Downstream Distribution',
    color: Apptheme.textclrlight,
  ),
  Widgets1(
    maxheight: 250,
    child: DynamicDropdownMaterialAcquisition(
      columnTitles: ['Transportation', 'Distance'],
      isTextFieldColumn: [false, true],
      addButtonLabel: 'Add transport cycle',
      padding: 5,
      apiKeyMap: apiKeymaterials,
      endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
    ),
  ),

  //--ROW 2--
  Labels(
    title: 'Downstream Storage',
    color: Apptheme.textclrlight,
  ),
  Widgets1(
    maxheight: 250,
    child: DynamicDropdownMaterialAcquisition(
      columnTitles: ['Facilities', 'Stored duration', 'Area', 'Select GHG'],
      isTextFieldColumn: [false, true, true, false],
      addButtonLabel: 'Add facility',
      padding: 5,
      apiKeyMap: apiKeymaterials,
      endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
    ),
  ),

  //--ROW 3--
  Labels(
    title: 'Use Phase',
    color: Apptheme.textclrlight,
  ),
  Widgets1(
    maxheight: 250,
    child: DynamicDropdownMaterialAcquisition(
      columnTitles: ['Use activity', 'Expected use cycle', 'Unit'],
      isTextFieldColumn: [false, true, true],
      addButtonLabel: 'Add use cycle',
      padding: 5,
      apiKeyMap: apiKeymaterials,
      endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
    ),
  ),

  //--ROW 4--
  Labels(
    title: 'End-of-life treatment',
    color: Apptheme.textclrlight,
  ),
  Widgets1(
    maxheight: 250,
    child: DynamicDropdownMaterialAcquisition(
      columnTitles: ['Product Type', 'Mass', 'Energy required'],
      isTextFieldColumn: [false, true, true],
      addButtonLabel: 'Add disassembly cycle',
      padding: 5,
      apiKeyMap: apiKeymaterials,
      endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
    ),
  ),
];

    


    return PrimaryPages(
      paddingadd: 15,
      menutogglee: widget.menutogglee, 
      header: Pageheaders(
        settingstogglee: widget.settingstogglee, 
        title: 'Attributes Analysis', 
        child: TextButton(
          child: 
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: 
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 170,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Apptheme.widgetsecondaryclr,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: 
                showThreePageTabs 
      
              ? Align(
                  alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Labelsinbuttons(
                    title: 'Cradle to Grave', 
                    color: Apptheme.textclrlight, 
                    fontsize: 20),
                ),
              )
              
              : Align(
                  alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Labelsinbuttons(
                    title: 'Cradle to Gate', 
                    color: Apptheme.textclrlight, 
                    fontsize: 20),
                ),
              )
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              showThreePageTabs = !showThreePageTabs;
            });
          },
        ),
      ),
      childofmainpage: showThreePageTabs 
        ? ManualTab3pages(
            tab1: 'Upstream', 
            tab1fontsize: 15, 
            tab2: 'Production', 
            tab2fontsize: 15, 
            tab3: 'Downstream', 
            tab3fontsize: 15, 
            
            pg1flexValue1: 1, 
            pg1flexValue2: 1, 
          
            pg2flexValue1: 1, 
            pg2flexValue2: 1, 
          
            pg3flexValue1: 1, 
            pg3flexValue2: 1, 
            
            firstchildof1: ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: widgetofpage1.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  color: Apptheme.transparentcheat,
                  child: widgetofpage1[index],
                );
              },
            ), 
    
            secondchildof1: Container(), 
    
            firstchildof2: ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: widgetofpage2.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  color: Apptheme.transparentcheat,
                  child: widgetofpage2[index],
                );
              },
            ), 
    
            secondchildof2: Container(),
    
            firstchildof3: ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: widgetofpage3.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  color: Apptheme.transparentcheat,
                  child: widgetofpage3[index],
                );
              },
            ), 
    
            secondchildof3: Container(),
          )
    
        : ManualTab2pages(
            tab1: 'Upstream', 
            tab1fontsize: 15, 
            tab2: 'Production', 
            tab2fontsize: 15, 
            tab3: 'Not included anymore', 
            tab3fontsize: 15, 
            
            pg1flexValue1: 1, 
            pg1flexValue2: 1, 
          
            pg2flexValue1: 1, 
            pg2flexValue2: 1, 
          
            pg3flexValue1: 1, 
            pg3flexValue2: 1, 
            
            firstchildof1: 
            ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: widgetofpage1.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  color: Apptheme.transparentcheat,
                  child: widgetofpage1[index],
                );
              },
            ), 
    
            secondchildof1: Container(), 
    
            firstchildof2: ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: widgetofpage2.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  color: Apptheme.transparentcheat,
                  child: widgetofpage2[index],
                );
              },
            ), 
    
            secondchildof2: Container(),
    
            firstchildof3: ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: widgetofpage3.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  color: Apptheme.transparentcheat,
                  child: widgetofpage3[index],
                );
              },
            ), 
    
            secondchildof3: Container(),
    
            
      ),
    );
  }
}