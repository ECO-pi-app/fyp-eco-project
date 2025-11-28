import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/manual_tab_3pages.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/dropdown_attributes_linked.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets1.dart';


class Dynamicprdanalysis extends StatefulWidget {
  final VoidCallback settingstogglee;
  const Dynamicprdanalysis({super.key, required this.settingstogglee});

  @override
  State<Dynamicprdanalysis> createState() => _DynamicprdanalysisState();
}

class _DynamicprdanalysisState extends State<Dynamicprdanalysis> {


  @override
  Widget build(BuildContext context) {

    final List<Widget> widgetofpage1=[

      //--ROW 1--
      Labels(title: 'Attribute: Materials',),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Material', 'Mass', 'Distance', 'Transport Mode'], 
        isTextFieldColumn: [false, true, true, false,], 
        addButtonLabel: 'Add material', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options', '', '', 'http://127.0.0.1:8000/meta/options' ],
        jsonKeys: [ 'materials', '', '', 'transport_types'],
        ),
      ),
    ];

    final List<Widget> widgetofpage2=[

      //--ROW 1--
      Labels(title: 'Attribute: Machining',),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Machine', 'Total time', 'Remaining Charge'], 
        isTextFieldColumn: [false, true, true,], 
        addButtonLabel: 'Add GHG', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options'],
        jsonKeys: [ 'machine_types'],
        ),
      ),
     
      //--ROW 2--
      Labels(title: 'Attribute: Fugitive',),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Select GHG', 'Total Charge', 'Remaining Charge'], 
        isTextFieldColumn: [false, true, true,], 
        addButtonLabel: 'Add GHG', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options'],
        jsonKeys: [ 'GHG'],
        ),
      ),
    ];

    final List<Widget> widgetofpage3=[
      //--ROW 3--
      Labels(title: 'Attribute: Distribution',),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Transportation', 'Distance'], 
        isTextFieldColumn: [false, true], 
        addButtonLabel: 'Add transport cycle', 
        padding: 5, 
        apiEndpoints: ['http://127.0.0.1:8000/meta/options'],
        jsonKeys: ['transport_types'],
        ),
      ),

      //--ROW 3.A--
      Labels(title: 'Attribute: Storage',),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Facilities', 'Stored duration', 'Area', 'Select GHG'], 
        isTextFieldColumn: [false, true, true, false,], 
        addButtonLabel: 'Add facility', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options', '', '', 'http://127.0.0.1:8000/meta/options' ],
        jsonKeys: [ 'facilities', '', '', 'GHG'],
        ),
      ),
      

      //--ROW 4--
      Labels(title: 'Attribute: Usage Cycle',),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Use activity', 'Expected use cycle', 'Unit'], 
        isTextFieldColumn: [false, true, true,], 
        addButtonLabel: 'Add use cycle', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options'],
        jsonKeys: [ 'usage_types'],
        ),
      ),

      //--ROW 5--
      Labels(title: 'Attribute: Disassembly',),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Product Type', 'Mass', 'Energy required',], 
        isTextFieldColumn: [false, true, true,], 
        addButtonLabel: 'Add disassembly cycle', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options'],
        jsonKeys: [ 'disassembly_by_industry'],
        ),
      ),

      //--ROW 6--
      Labels(title: 'Attribute: End of Life',),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Process', 'Material', 'Amount',], 
        isTextFieldColumn: [false, false, true,], 
        addButtonLabel: 'Add process', 
        padding: 5, 
        apiEndpoints: [ 'http://127.0.0.1:8000/meta/options', 'http://127.0.0.1:8000/meta/options'],
        jsonKeys: [ 'process', 'materials', ''],
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
                child: ManualTabpages(
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    ),

                                    //--Summary--
                                    Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Subtitlesummary(
                                        words: 'Define product parameters. All excluded categories must be declared in the declaration section', 
                                        color: Apptheme.widgetsecondaryclr,),
                                    ),
                                  
                                    //--Boundary Definer--
                                   
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