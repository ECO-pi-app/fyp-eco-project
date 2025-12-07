import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';


class DynamicDropdownMaterialAcquisition extends StatefulWidget {
  final List<String> columnTitles;
  final List<bool> isTextFieldColumn;
  final List<String> apiEndpoints;
  final List<String?> jsonKeys;
  final String addButtonLabel;
  final double padding;

  final void Function(double)? onTotalEmissionCalculated;
  final String endpoint; 
  final Map<String, String> apiKeyMap; 


  const DynamicDropdownMaterialAcquisition({
    super.key,
    required this.columnTitles,
    required this.isTextFieldColumn,
    required this.apiEndpoints,
    required this.jsonKeys,
    required this.addButtonLabel,
    required this.padding,

    this.onTotalEmissionCalculated,
    required this.endpoint,
    required this.apiKeyMap,
  });

  @override
  State<DynamicDropdownMaterialAcquisition> createState() =>
      DynamicDropdownMaterialAcquisitionState();
}

class DynamicDropdownMaterialAcquisitionState extends State<DynamicDropdownMaterialAcquisition> {

  late List<List<String?>> selections;
  Map<int, List<String>> dropdownData = {};
  
  String? result;
  List<dynamic> tableData = [];

  Map<int, List<Map<String, dynamic>>> fullArticleData = {};


 


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
    selections = List.generate(
      widget.columnTitles.length,
      (col) => [''],
    );
    fetchAllColumnData();
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

  Future<void> fetchAllColumnData() async {
    dropdownData.clear();

    for (int i = 0; i < widget.apiEndpoints.length; i++) {
      String endpoint = widget.apiEndpoints[i];
      String? jsonKey = widget.jsonKeys[i];

      if (endpoint.isEmpty || jsonKey == null) continue;

      debugPrint("🔍 Fetching column $i from $endpoint (jsonKey = $jsonKey)");

      try {
        final response = await http.get(Uri.parse(endpoint));
        debugPrint("📡 Column $i response status: ${response.statusCode}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String,dynamic>;
          debugPrint("📦 Column $i response keys: ${data.keys.toList()}");

          List<String> items = [];
          final dynamic raw = data[jsonKey];

           debugPrint("🧩 Column $i raw type: ${raw?.runtimeType}");
          
          if (raw is List) {

            if (raw.isNotEmpty && raw.first is String) {
              items = List<String>.from(raw);
            }

            else if (raw.isNotEmpty && raw.first is Map) {
              fullArticleData[i] =
                List<Map<String, dynamic>>.from(raw);

              items = raw.map<String>((article) => 
              (article['title'] ?? '').toString()).toList();
              
              items = raw.map<String>((article) => 
              (article['title'] ?? '').toString()).toList();
            }
          }

          debugPrint("✅ Column $i loaded ${items.length} items:");
        for (var item in items.take(5)) {
          debugPrint("   • $item");
        }
        if (items.length > 5) {
          debugPrint("   • ... (${items.length - 5} more)");
        }

          setState(() {
            dropdownData[i] = items;
              if (selections[i].isNotEmpty && items.isNotEmpty) {
              selections[i][0] = items.first;
            }
          });
        }
      } catch (e) {
        debugPrint("Failed load col $i : $e");
      }
    }
  }

  void _addRow() {
    setState(() {
      for (int col = 0; col < selections.length; col++) {
        if (widget.isTextFieldColumn[col]) {
          selections[col].add('');
        } else {
          final items = dropdownData[col] ?? [];
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
                            border: Border.all(
                              width: 1, 
                              color: Apptheme.widgetborderdark
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
                                                        color: Apptheme.unselected,
                                                      )
                                                    ),
                
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Apptheme.widgetborderlight
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
                                                        color: Apptheme.widgetsecondaryclr,
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
                                              : (dropdownData[col] == null || dropdownData[col]!.isEmpty)
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
                                                      items: (dropdownData[col] ?? []).isEmpty
                                                          ? [
                                                              const DropdownMenuItem(
                                                                value: '',
                                                                child: Text("Loading..."),
                                                              )
                                                            ]
                                                          : dropdownData[col]!
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
                                        backgroundColor: Apptheme.auxilary,
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