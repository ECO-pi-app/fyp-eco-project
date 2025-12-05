import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets1.dart';

class AutoaddWidget extends StatefulWidget {
  final Color color;
  final String title;

  const AutoaddWidget({super.key, 
  required this.color,
  required this.title,
  });

  @override
  State<AutoaddWidget> createState() => _AutoaddWidgetState();
}

class _AutoaddWidgetState extends State<AutoaddWidget> {

  List<Map<String, dynamic>> products = [
    
  ];

  void autoaddwithparameters(BuildContext context) async {
    final controllertrack = TextEditingController();
    final outcome = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Product'),
        content: TextField(
          controller: controllertrack,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext,), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, controllertrack.text), child: const Text('Add Products')),
        ],
      )
      );

      if (outcome != null && outcome.isNotEmpty) {
        setState(() {
          products.add({'name':outcome});
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return 
    Padding(padding: const EdgeInsets.all(5),
      child: 
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: 
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: 
          Row(
            children: [
              ...products.map((products) => Padding(padding: EdgeInsetsGeometry.all(8),
              child: AutoAddedWidget(
              color: widget.color,
              child: Center(child: Labelsinbuttons(
                title: products['name']?? '', 
                color: Apptheme.textclrlight
              )
              ),
              ),
               ),),
          
              Padding(padding: const EdgeInsets.only(top: 15, bottom: 15, left: 8),
                child: InkWell(
                  onTap: () => autoaddwithparameters(context),
                  child: SizedBox(
                    height: 50,
                    child: AspectRatio(
                      aspectRatio: 1/1,
                      child: AutoAddedWidget(
                        color: Apptheme.widgetsecondaryclr,
                        child: 
                        FittedBox(
                          child: Icon(Icons.add,
                          color: Apptheme.iconslight,
                          
                          ),
                        ),
                      ),
                    ),
                  ),
          
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}