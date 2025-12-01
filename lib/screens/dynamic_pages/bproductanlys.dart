import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/auto_tab_3pages.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/auto_tab_2pages.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/dropdown_attributes_linked.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets1.dart';

class Dynamicprdanalysis extends StatefulWidget {
  final VoidCallback settingstogglee;

  const Dynamicprdanalysis({super.key, 
  required this.settingstogglee,
  });

  @override
  State<Dynamicprdanalysis> createState() => _DynamicprdanalysisState();
}

class _DynamicprdanalysisState extends State<Dynamicprdanalysis> {

  String? result;
  List<dynamic> tableData = [];
  double materialupstreamEmission = 0;
  double materialtransportEmission = 0;
  double fugitiveemissions = 0;
  double totalemissions = 0;
  bool showThreePageTabs = true;

  final  Map<String, String> apiKeymaterials = {
      "Country": "country",
      "Material": "material",
      "Mass (kg)": "mass_kg",
  };

    final  Map<String, String> apiKeyfugitive = 
    {
      "GHG": "ghg_name",
      "Total Charge": "total_charged_amount_kg",
      "Remaining Charge": "current_charge_amount_kg",
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

    final List<Widget> widgetofpage1=[

      //--ROW 1--
      Labels(
        title: 'Material Emissions: ${materialupstreamEmission.toStringAsFixed(2)} kg CO₂', 
        color: Apptheme.textclrlight,
      ),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Country','Material', 'Mass (kg)'], 
        isTextFieldColumn: [false, false, true], 
        addButtonLabel: 'Add material', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options','http://127.0.0.1:8000/meta/options', '', ],
        jsonKeys: [ 'countries','materials', ''],
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
        title: 'Transport Emissions: ${materialtransportEmission.toStringAsFixed(2)} kg CO₂', 
        color: Apptheme.textclrlight,
      ),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Transport', 'Distance'], 
        isTextFieldColumn: [false, true], 
        addButtonLabel: 'Add material', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options', ''],
        jsonKeys: [ 'transport_types', ''],
        onTotalEmissionCalculated: (total) {
          setState(() {
            materialtransportEmission = total;
          });
        },
        apiKeyMap: apiKeymaterials,
        endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
        ),
      ),
    ];

    final List<Widget> widgetofpage2=[

      //--ROW 1--
      Labels(
        title: 'Attribute: Machining', 
        color: Apptheme.textclrlight,
        ),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Machine', 'Total time', 'Remaining Charge'], 
        isTextFieldColumn: [false, true, true,], 
        addButtonLabel: 'Add GHG', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options'],
        jsonKeys: [ 'Mazak_types'],
        apiKeyMap: apiKeymaterials,
        endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
        ),
      ),
     
      //--ROW 2--
      Labels(
        title: 'Fugitive Emissions: ${fugitiveemissions.toStringAsFixed(2)} kg CO₂', 
        color: Apptheme.textclrlight,
        ),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['GHG', 'Total Charge', 'Remaining Charge'], 
        isTextFieldColumn: [false, true, true,], 
        addButtonLabel: 'Add GHG', 
        padding: 5, 
        apiEndpoints: ['http://127.0.0.1:8000/meta/options'],
        jsonKeys: ['GHG' ],
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

    final List<Widget> widgetofpage3=[
      //--ROW 3--
      Labels(
        title: 'Attribute: Machining', 
        color: Apptheme.textclrlight,
        ),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Transportation', 'Distance'], 
        isTextFieldColumn: [false, true], 
        addButtonLabel: 'Add transport cycle', 
        padding: 5, 
        apiEndpoints: ['http://127.0.0.1:8000/meta/options'],
        jsonKeys: ['transport_types'],
        apiKeyMap: apiKeymaterials,
        endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
        ),
      ),

      //--ROW 3.A--
      Labels(
        title: 'Attribute: Machining', 
        color: Apptheme.textclrlight,
        ),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Facilities', 'Stored duration', 'Area', 'Select GHG'], 
        isTextFieldColumn: [false, true, true, false,], 
        addButtonLabel: 'Add facility', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options', '', '', 'http://127.0.0.1:8000/meta/options' ],
        jsonKeys: [ 'facilities', '', '', 'GHG'],
        apiKeyMap: apiKeymaterials,
        endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
        ),
      ),
      

      //--ROW 4--
      Labels(
        title: 'Attribute: Machining', 
        color: Apptheme.textclrlight,
        ),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Use activity', 'Expected use cycle', 'Unit'], 
        isTextFieldColumn: [false, true, true,], 
        addButtonLabel: 'Add use cycle', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options'],
        jsonKeys: [ 'usage_types'],
        apiKeyMap: apiKeymaterials,
        endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
        ),
      ),

      //--ROW 5--
      Labels(
        title: 'Attribute: Machining', 
        color: Apptheme.textclrlight,
        ),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Product Type', 'Mass', 'Energy required',], 
        isTextFieldColumn: [false, true, true,], 
        addButtonLabel: 'Add disassembly cycle', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options'],
        jsonKeys: [ 'disassembly_by_industry'],
        apiKeyMap: apiKeymaterials,
        endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
        ),
      ),

      //--ROW 6--
      Labels(
        title: 'Attribute: Machining', 
        color: Apptheme.textclrlight,
        ),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Process', 'Material', 'Amount',], 
        isTextFieldColumn: [false, false, true,], 
        addButtonLabel: 'Add process', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options', 'http://127.0.0.1:8000/meta/options'],
        jsonKeys: [ 'process', 'materials', ''],
        apiKeyMap: apiKeymaterials,
        endpoint: 'http://127.0.0.1:8000/calculate/material_emission',
        ),
      ),
    ];

    


    return SizedBox(
        child: 
          Stack(
          children: [

            //--Main Page--
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
              child: 
              Container(
                padding: EdgeInsets.only(bottom: 15, top:220),
                child: 
                showThreePageTabs 
                ?ManualTab3pages(
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

                    
                  ),
              )

              ),
            ),

            //--Custom Header for Home--
            Container(
            height: 200,
            width: double.infinity,
            decoration: 
            BoxDecoration(
              color: Apptheme.header,
                boxShadow: [
                  BoxShadow(
                    color: Apptheme.header,
                    spreadRadius: 4,
                    blurRadius: 4,
                    offset: const Offset(0, 4)
                  )
                ]
            ),
            child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                      //--"Title"--
                      Expanded(
                        child: 
                          Center(
                            child: Padding (padding: EdgeInsetsGeometry.only(left:20, right: 20, top: 15),
                                child:
                                ListView(
                                  children: [

                                    //--TITLE--
                                    Text('Attributes',
                                    style: TextStyle(
                                      color: Apptheme.textclrlight,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    ),


                                  
                                    //--Boundary Definer--
                                   Align(
                                    alignment: Alignment.centerLeft,
                                     child: 
                                     TextButton(
                                      child: 
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: 
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: 240,
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
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 20),
                                                  child: Icon(Icons.swap_horiz,
                                                  size: 30,
                                                  color: Apptheme.iconslight,
                                                  ),
                                                ),
                                          
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: Labelsinbuttons(
                                                    title: 'Cradle to Grave', 
                                                    color: Apptheme.textclrlight, 
                                                    fontsize: 20),
                                                ),
                                              ],
                                            ),
                                          )
                                          : Align(
                                              alignment: Alignment.centerLeft,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 20),
                                                  child: Icon(Icons.swap_horiz,
                                                  size: 30,
                                                  color: Apptheme.iconslight,
                                                  ),
                                                ),
                                          
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: Labelsinbuttons(
                                                    title: 'Cradle to Gate', 
                                                    color: Apptheme.textclrlight, 
                                                    fontsize: 20),
                                                ),
                                              ],
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
                                   )
                                  ],
                                ),
                                ),
                          ),
                        ),
                      
                      //--Settings (Trailing)--
                      Align(
                        alignment: AlignmentGeometry.center,
                        child:
                          Padding (padding: EdgeInsetsGeometry.only(right:35, left: 0, top: 5),
                            child: 
                              SizedBox(
                                height: double.infinity,
                                width: 40,
                                child:
                                  IconButton(
                                  onPressed: widget.settingstogglee,
                                  icon: 
                                    Icon(Icons.settings,
                                    size: 25,
                                    color: Apptheme.iconslight,
                                    ),
                                    alignment: AlignmentDirectional.center,
                                    padding: EdgeInsets.zero,
                                  ),                          
                              ),        
                            ), 
                      ),
                      
                    ],
                  ) ,
            ),
            
          ],
          ),
      );

      
  }
}