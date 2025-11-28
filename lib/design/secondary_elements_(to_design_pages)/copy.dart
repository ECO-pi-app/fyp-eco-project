import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/design/apptheme/colors.dart';

class DynamicDropdownMaterialAcq extends StatefulWidget {
  final List<String> columnTitles;
  final List<bool> isTextFieldColumn;
  final String addButtonLabel;
  final double padding;

  // ['https://api.com/materials', 'https://api.com/transports', '']
  final List<String> apiEndpoints;
  final List<String?> jSONkeys;

  const DynamicDropdownMaterialAcq({
    super.key,
    required this.columnTitles,
    required this.isTextFieldColumn,
    required this.addButtonLabel,
    required this.padding,
    required this.apiEndpoints,
    required this.jSONkeys,
  });

  @override
  State<DynamicDropdownMaterialAcq> createState() =>
      _DynamicDropdownMaterialAcqState();
}

class _DynamicDropdownMaterialAcqState
    extends State<DynamicDropdownMaterialAcq> {
  late List<List<String?>> selections;
  Map<int, List<String>> dropdownData ={};

  Map<String, double> materialFactors = {};
  List<String> materialNames = [];
  List<String> transportTypes = [];

  @override
  void initState() {
    super.initState();
    selections = List.generate(
      widget.columnTitles.length,
      (col) => [widget.isTextFieldColumn[col] ? '' : ''],
    );

    fetchColumnData();
  }

Future<void> fetchColumnData() async {
  dropdownData.clear();

  for (int i = 0; i < widget.apiEndpoints.length; i++) {
    String endpoint = widget.apiEndpoints[i];
    String? jsonKey = widget.jSONkeys[i];

    if (endpoint.isEmpty || jsonKey == null) continue;

    try {
      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (jsonKey.isEmpty) continue;

        List<String> items = [];
        if (data[jsonKey] != null && data[jsonKey] is List) {
          items = List<String>.from(data[jsonKey] ?? []);
        }

        setState(() {
          if (i == 0) {
           
            
            dropdownData[i] = items;
            selections[i][0] = items.isNotEmpty ? items.first : '';
          } else if (i == 1) {
            
           
            transportTypes = items;
            selections[i][0] = items.isNotEmpty ? items.first : '';
          }
        });
      } else {
        debugPrint('Failed to load data from $endpoint');
      }
    } catch (e) {
      debugPrint('Error fetching $endpoint: $e');
    }
  }
}

  void _addRow() {
    setState(() {
      for (int i = 0; i < selections.length; i++) {
        if (widget.isTextFieldColumn[i]) {
          selections[i].add('');
        } else if (i == 0) {
          selections[i].add(materialNames.isNotEmpty ? materialNames.first : '');
        } else if (i == 1) {
          selections[i].add(transportTypes.isNotEmpty ? transportTypes.first : '');
        } else {
          selections[i].add('');
        }
      }
    });
  }

  void _removeRow(int index) {
    setState(() {
      for (final column in selections) {
        if (index < column.length) column.removeAt(index);
      }
    });
  }


  double calculateResult(int rowIndex) {
    if (selections.isEmpty) return 0.0;
    String? material = selections[0][rowIndex];
    String valueStr = selections[2][rowIndex] ?? '';
    double factor = materialFactors[material] ?? 0.0;
    double input = double.tryParse(valueStr) ?? 0.0;
    return factor * input;
  }


  @override
  Widget build(BuildContext context) {
    final numRows = selections.isNotEmpty ? selections[0].length : 0;

    return 
    LayoutBuilder(
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
          SingleChildScrollView(
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
                        border: Border.all(
                          width: 1, 
                          color: Apptheme.drawer
                        ),
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
                                height: 25,
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
                                            color: Apptheme.widgetclrlight,
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

                                    Expanded(
                                      child: widget.isTextFieldColumn[col]
                                          ? TextField(
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
                                                border: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 4, vertical: 0),
                                              ),
                                              onChanged: (val) {
                                                setState(() {
                                                  selections[col][row] = val;
                                                });
                                              },
                                            )
                                          : DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
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
                                                items: col == 0
                                                    ? materialNames
                                                        .map(
                                                          (item) => DropdownMenuItem(
                                                            value: item,
                                                            child: Text(item,),
                                                          ),
                                                        )
                                                        .toList()
                                                    : transportTypes
                                                        .map(
                                                          (item) => DropdownMenuItem(
                                                            value: item,
                                                            child: Text(item),
                                                          ),
                                                        )
                                                        .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selections[col][row] = value!;
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
                              child: SizedBox(
                                width: 200,
                                height: 20,
                                child: ElevatedButton.icon(
                                  onPressed: _addRow,
                                  icon: const Icon(Icons.add, size: 16),
                                  label: Text(widget.addButtonLabel),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Apptheme.auxilary,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );     
      }
    );
  
  }
}
