import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';


class DynamicDropdownMaterialAcquisition extends ConsumerStatefulWidget {
  final List<String> columnTitles;
  final List<bool> isTextFieldColumn;
  
  final List<List<String>>? dropDownLists;


  final String addButtonLabel;
  final double padding;

  final void Function(double)? onTotalEmissionCalculated;
  final String endpoint; 
  final Map<String, String> apiKeyMap; 


  const DynamicDropdownMaterialAcquisition({
    super.key,
    required this.columnTitles,
    required this.isTextFieldColumn,

    this.dropDownLists,

    required this.addButtonLabel,
    required this.padding,

    this.onTotalEmissionCalculated,
    required this.endpoint,
    required this.apiKeyMap,
  });

  @override
  ConsumerState<DynamicDropdownMaterialAcquisition> createState() =>
      _DynamicDropdownMaterialAcquisitionState();
}

class _DynamicDropdownMaterialAcquisitionState
    extends ConsumerState<DynamicDropdownMaterialAcquisition> {
  
  String? result;
  List<dynamic> tableData = [];

  Map<int, List<Map<String, dynamic>>> fullArticleData = {};

  List<List<String?>> selections = [];

  late List<List<String>> dropDownListsInternal;

 


Future<void> calculateAndSendAllRows() async {
  if (selections.isEmpty || selections[0].isEmpty) return;

  setState(() => result = null);
  double totalEmission = 0;

  final int numRows = selections[0].length;

  try { 
    for (int row = 0; row < numRows; row++) {
      final data = <String, dynamic>{};

      for (int col = 0; col < widget.columnTitles.length; col++) {
        final apiKey = widget.apiKeyMap[widget.columnTitles[col]];
      if (apiKey == null) continue;



        if (widget.isTextFieldColumn[col]) {
          final textValue = selections[col][row] ?? '0';
          data[apiKey] = double.tryParse(textValue) ?? 0;
        } else {
          data[apiKey] = selections[col][row] ?? '';
        }
      }

      debugPrint("POST payload: $data");

      final response = await http.post(
        Uri.parse(widget.endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        totalEmission += (json["materialacq_emission"] ?? 0).toDouble();
        totalEmission += (json["total_emission"] ?? 0).toDouble();
        totalEmission += (json["emissions_kgco2e"] ?? 0).toDouble();
        totalEmission += (json["emissions"] ?? 0).toDouble();
      } else {
        debugPrint("API error on row $row: ${response.statusCode}");
      }
    }
    
    setState(() => result = totalEmission.toStringAsFixed(2));
    debugPrint("Total emission calculated: $result");
    if (widget.onTotalEmissionCalculated != null) {
      widget.onTotalEmissionCalculated!(totalEmission);
    }
  } catch (e) {
    setState(() => result = "Error: $e");
  }
}


@override
void initState() {
  super.initState();

  final defaultList = ref.read(countriesProvider); 

  dropDownListsInternal = widget.dropDownLists ??
      List.generate(widget.columnTitles.length, (index) => defaultList);

  selections = List.generate(
    widget.columnTitles.length,
    (col) => [
      widget.isTextFieldColumn[col]
          ? ''
          : (dropDownListsInternal[col].isNotEmpty
              ? dropDownListsInternal[col].first
              : '')
    ],
  );
}


  List<Map<String, String?>> formattedRows() {
    final rows = <Map<String, String?>>[];
    final rowCount = selections[0].length;

    for (int row = 0; row < rowCount; row++) {
      final rowData = <String, String?>{};
      for (int col = 0; col < widget.columnTitles.length; col++) {
        rowData[widget.columnTitles[col]] = selections[col][row];
      }
      rows.add(rowData);
    }

    return rows;
  }

  void _addRow() {
    setState(() {
      for (int col = 0; col < selections.length; col++) {
        if (widget.isTextFieldColumn[col]) {
          selections[col].add('');
        } else {
          final items = dropDownListsInternal[col];
          selections[col].add(items.isNotEmpty ? items.first : '');
        }
      }
    });
  }

  void _removeRow(int index) {
    setState(() {
      for (final col in selections) {
        if (index < col.length) col.removeAt(index);
      }
    });
  }

  void postSelections() {
  final body = formattedRows();
  print(body);
}

  @override
  Widget build(BuildContext context) {
    final numRows = selections.isNotEmpty ? selections[0].length : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        const double columnwidthmin = 180;
        final double parentwidth = constraints.maxWidth;
        final int columnno = widget.columnTitles.length;
    
        double paddingcompensate = ((widget.padding*2) * columnno);
    
        double calculatedwidth = (parentwidth - paddingcompensate)/columnno;
    
        double columnwidth = calculatedwidth < columnwidthmin
        ? columnwidthmin
        : calculatedwidth;
    
    
        return 
        Column(
          children: [

            SizedBox(
              height: 200,
              child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: 
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int col = 0; col < widget.columnTitles.length; col++)
                      Padding(
                        padding: EdgeInsets.all(widget.padding),
                        child: 
                        Container(
                          width: columnwidth,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: 
                          ListView(
                            children: [
                              Text(
                                widget.columnTitles[col],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Apptheme.textclrdark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              for (int row = 0; row < numRows; row++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  child: 
                                  Container(
                                    height: 30,
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Apptheme.widgetsecondaryclr,
                                      borderRadius: BorderRadius.circular(6)
                                    ),
                                  child: Row(
                                    children: [
                
                                      Padding(
                                          padding: const EdgeInsets.only(right: 4),
                                          child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: Apptheme.transparentcheat,
                                                borderRadius: BorderRadius.circular(6)
                                              ),
                                              child:
                                              Center(
                                              child: 
                                                Text('${row + 1}',
                                                style: TextStyle(
                                                  color: Apptheme.textclrdark,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold
                                                ),
                                                ),
                                              ),
                                            ),
                                        ),
                                      
                                      Expanded(child: widget.isTextFieldColumn[col]
                                        ? TextField(
                                          enabled: true,
                                            cursorColor: Apptheme.textclrlight,
                                            cursorHeight: 15,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9.]')),
                                              ],
                                              style: TextStyle(
                                                  color: Apptheme.textclrlight),
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                                                                
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Apptheme.widgetclrlight,
                                                  )
                                                ),
            
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Apptheme.widgetclrlight
                                                  )
                                                ),
            
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Apptheme.error,
                                                  )
                                                ),
            
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Apptheme.error,
                                                  )
                                                ),
            
                                                disabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Apptheme.transparentcheat,
                                                  )
                                                ),
            
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 4, vertical: 0),
                                              ),
                                              onChanged: (val) {
                                                setState(() {
                                                  selections[col][row] = val;
                                                });
                                              },
                                            )
                                        : ((dropDownListsInternal[col].isEmpty))
                                          ? const Center(
                                              child: SizedBox(
                                                height: 16,
                                                width: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Apptheme.eXTRA2,
                                                  ),
                                              ),
                                            )
                                          : DropdownButtonHideUnderline(
                                                      child: 
                                                      DropdownButton<String>(
                                                        dropdownColor: Apptheme.widgetsecondaryclr,
                                                        icon:
                                                          Icon(Icons.arrow_drop_down,
                                                            color: Apptheme.iconslight,
                                                            size: 20,
                                                          ),
                                                        padding: EdgeInsets.zero,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Apptheme.textclrlight,
                                                            fontWeight: FontWeight.w500
                                                          ),
                                                        value: selections[col][row],
                                                        isExpanded: true,
                                                        items: (dropDownListsInternal[col]).isEmpty
                                                            ? [const DropdownMenuItem(value: '',child: Text("Loading..."),)]
                                                            : dropDownListsInternal[col]
                                                                .map((item) => DropdownMenuItem(
                                                                  value: item,
                                                                  child: Text(
                                                                    item,
                                                                    overflow: TextOverflow.fade,
                                                                    maxLines: 1,
                                                                    softWrap: false,
                                                                  ),
                                                                ))
                                                                .toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selections[col][row] = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                      ),
                
                                      if (col == 0)
                                        Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              color: Apptheme.widgetclrlight,
                                              borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(Icons.delete,
                                                  size: 16, color: Apptheme.iconsprimary),
                                              onPressed: () => _removeRow(row),
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                              if (col == 0)
                                Center(
                                  child: 
                                  SizedBox(
                                    width: 200,
                                    height: 20,
                                    child: ElevatedButton.icon(
                                      onPressed: _addRow,
                                      label: Labelsinbuttons(
                                        title: widget.addButtonLabel,
                                        color: Apptheme.textclrlight,
                                        fontsize: 12,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Apptheme.widgetsecondaryclr,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ),
                       
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: widget.padding),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      calculateAndSendAllRows();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Apptheme.widgetsecondaryclr,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Labelsinbuttons(
                      title: 'Calculate Emissions',
                      color: Apptheme.textclrlight,
                      fontsize: 17,
                      ),
                  ),
                ),
              ),
            ),
        ]
        );
      },
    );
  }
}