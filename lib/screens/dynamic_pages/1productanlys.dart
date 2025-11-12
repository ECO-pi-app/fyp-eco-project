import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/dropdown_attributes.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/dropdown_attributes_linked.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets1.dart';


class Dynamicprdanalysis extends StatefulWidget {
  final VoidCallback settingstogglee;
  const Dynamicprdanalysis({super.key, required this.settingstogglee});

  @override
  State<Dynamicprdanalysis> createState() => _DynamicprdanalysisState();
}

class _DynamicprdanalysisState extends State<Dynamicprdanalysis> {
  String? selectedBoundary = 'Cradle';

  @override
  Widget build(BuildContext context) {

    final List<Widget> widgetofthispage=[
      //--ROW 1--
      Labels(title: 'Attribute: Materials',),
      Widgets1(aspectratio: 16/9, maxheight: 300,
      child: 
        DynamicDropdownMaterialAcquisition(
        columnTitles: ['Materials', 'Transport', 'Distance'], 
        isTextFieldColumn: [false, false, true], 
        addButtonLabel: 'Add material', 
        padding: 5, 
        apiEndpoints: ['http://127.0.0.1:8000/meta/options', 'http://127.0.0.1:8000/meta/options'])
      ),
     
      //--ROW 2--
      Labels(title: 'Attribute: Production',),
      Widgets1(aspectratio: 16/9, maxheight: 200,
      child:
      DynamicDropdownMaterialAcquisition(
        columnTitles: ['Process', 'Equipment', 'Time'], 
        isTextFieldColumn: [false, false, true], 
        addButtonLabel: 'Add material', 
        padding: 5, 
        apiEndpoints: ['http://127.0.0.1:8000/meta/options', 'http://127.0.0.1:8000/meta/options'])
      ),

      if (selectedBoundary == 'Grave') ...[
      //--ROW 3--
      Labels(title: 'Attribute: Distribution and Storage',),
      Widgets1(aspectratio: 16/9, maxheight: 400,
      child:
      DynamicDropdownGroup(
        columnTitles: ['Capital Consumption', 'Power', 'Time',], 
        dropdownItems: [
          ['Aluminium', 'Copper', 'Brass'],
          ['Aluminium', 'Copper', 'Brass']
        ], 
        isTextFieldColumn: [false, false, true,], 
        addButtonLabel: 'Add Process',
        padding: 5,
        ),
      ),
      

      //--ROW 4--
      Labels(title: 'Activity: Usage',),
      Widgets1(aspectratio: 16/9, maxheight: 400,
      child:
      DynamicDropdownGroup(
        columnTitles: ['Capital Consumption', 'Power', 'Time',], 
        dropdownItems: [
          ['Aluminium', 'Copper', 'Brass'],
          ['Aluminium', 'Copper', 'Brass']
        ], 
        isTextFieldColumn: [false, false, true,], 
        addButtonLabel: 'Add Process',
        padding: 5,
        ),
      ),

      //--ROW 5--
      Labels(title: 'Activity: End of Life',),
      Widgets1(aspectratio: 16/9, maxheight: 400,
      child:
      DynamicDropdownGroup(
        columnTitles: ['Capital Consumption', 'Power', 'Time',], 
        dropdownItems: [
          ['Aluminium', 'Copper', 'Brass'],
          ['Aluminium', 'Copper', 'Brass']
        ], 
        isTextFieldColumn: [false, false, true,], 
        addButtonLabel: 'Add Process',
        padding: 5,
        ),
      ),
    ]

    ];

    return SizedBox(
        child: 
          Column(
          children: [

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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: 
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                      
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedBoundary = 'Cradle';
                                                });
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 140,
                                                decoration: BoxDecoration(
                                                  color: Apptheme.widgetsecondaryclr,
                                                  borderRadius: BorderRadius.circular(15)
                                                ),
                                                child: Tabtext(words: 'Cradle', specifysize: 20),
                                              ),
                                            ),
                                          ),
                                      
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedBoundary = 'Gate';
                                                });
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 140,
                                                decoration: BoxDecoration(
                                                  color: selectedBoundary == 'Gate'
                                                  ? Apptheme.widgetsecondaryclr
                                                  : Apptheme.unselected,
                                                  borderRadius: BorderRadius.circular(15)
                                                ),
                                                child: Tabtext(words: 'Gate', specifysize: 20),
                                              ),
                                            ),
                                          ),
                                      
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (selectedBoundary == 'Cradle') {
                                                          selectedBoundary = null;
                                                        } else {
                                                          selectedBoundary = 'Grave';
                                                        }
                                                });
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 140,
                                                decoration: BoxDecoration(
                                                  color: selectedBoundary == 'Grave'
                                                  ? Apptheme.widgetsecondaryclr
                                                  : Apptheme.unselected,
                                                  borderRadius: BorderRadius.circular(15)
                                                ),
                                                child: Tabtext(words: 'Grave', specifysize: 20),
                                              ),
                                            ),
                                          ),
                                      
                                        ],
                                      ),
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
            
            //--Main Page--
            Expanded(
              child: 
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Padding(padding: EdgeInsetsGeometry.all(15),
                child: 
                ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: widgetofthispage.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      color: Apptheme.transparentcheat,
                      child: widgetofthispage[index],
                    );
                  },
                  )
                ),
              ),
            )
          ],
          ),
      );

      
  }
}