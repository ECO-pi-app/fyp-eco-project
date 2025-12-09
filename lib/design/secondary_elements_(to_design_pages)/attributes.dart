import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';


class AttributesMenu extends ConsumerStatefulWidget {
  final List<String> columnTitles;
  final List<bool> isTextFieldColumn;
  
  final List<List<String>>? dropDownLists;


  final String addButtonLabel;
  final double padding;

  final void Function(double)? onTotalEmissionCalculated;
  final String endpoint; 
  final Map<String, String> apiKeyMap; 
  final String type; 


  const AttributesMenu({
    super.key,
    required this.columnTitles,
    required this.isTextFieldColumn,

    this.dropDownLists,

    required this.addButtonLabel,
    required this.padding,

    this.onTotalEmissionCalculated,
    required this.endpoint,
    required this.apiKeyMap,
    this.type = 'material',
  });

  @override
  ConsumerState<AttributesMenu> createState() =>
      _AttributesMenuState();
}

class _AttributesMenuState
    extends ConsumerState<AttributesMenu> {
  
  String? result;
  List<dynamic> tableData = [];

  Map<int, List<Map<String, dynamic>>> fullArticleData = {};

  late List<List<String>> dropDownListsInternal;


@override
void initState() {
  super.initState();

    dropDownListsInternal = widget.dropDownLists ??
      List.generate(widget.columnTitles.length, (_) => <String>[]);
}


List<Map<String, String?>> formattedRows(TableState tableState) {
  final rows = <Map<String, String?>>[];
  final rowCount = tableState.selections.isNotEmpty ? tableState.selections[0].length : 0;

  for (int row = 0; row < rowCount; row++) {
    final rowData = <String, String?>{};
    for (int col = 0; col < widget.columnTitles.length; col++) {
      rowData[widget.columnTitles[col]] = tableState.selections[col][row];
    }
    rows.add(rowData);
  }

  return rows;
}



  @override
  Widget build(BuildContext context) {
    

    final columns = widget.columnTitles.length;

    // ✅ Pass the number of columns to the family provider
final tableState = ref.watch(tableControllerProvider(columns));
final tableNotifier = ref.read(tableControllerProvider(columns).notifier);

    final numRows = tableState.selections.isNotEmpty ? tableState.selections[0].length : 0;

    // Convert TableState to RowFormat
    List<RowFormat> rows = List.generate(
      tableState.selections[0].length,
      (rowIndex) => RowFormat(
        columnTitles: widget.columnTitles,
        isTextFieldColumn: widget.isTextFieldColumn,
        selections: List.generate(columns, (colIndex) => tableState.selections[colIndex][rowIndex]),
      ),
    );

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
                                      
                                      Expanded(child: widget.isTextFieldColumn[col]
                                        ? TextFormField(
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
                                              onChanged:(value) {
  ref.read(tableControllerProvider(widget.columnTitles.length).notifier)
      .updateCell(col, row, value);
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
                                                        value: dropDownListsInternal[col].contains(tableState.selections[col][row])
      ? tableState.selections[col][row]
      : null, 
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
    if (value != null) {
      tableNotifier.updateCell(col, row, value);
    }
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
onPressed: () {
  final rowCount = tableState.selections.isNotEmpty ? tableState.selections[0].length : 0;
  if (rowCount > 0) {
    ref.read(tableControllerProvider(widget.columnTitles.length).notifier)
       .removeRow(rowCount - 1);
  }
},

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
                                      onPressed: () =>
  ref.read(tableControllerProvider(widget.columnTitles.length).notifier)
     .addRow(widget.columnTitles.length),
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
                    onPressed:  () async {
                await ref
                    .read(emissionCalculatorProvider.notifier)
                    .calculate(widget.type, rows);
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