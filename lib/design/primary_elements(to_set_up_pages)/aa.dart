import 'package:flutter/material.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/app_design.dart';


class Example extends StatefulWidget {
  final VoidCallback settingstogglee;
  const Example({super.key, required this.settingstogglee});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: 
          Column(
          children: [

            //--Custom Header for Home--
            Pageheaders(
              settingstogglee: null, 
              title: 'Allocation', 
              child: null,
            ),
        
            
            //--Main Page--
            Expanded(
              child: Padding(padding: EdgeInsetsGeometry.all(20),
              child: null
              )
            ),
          ],),
      );
  }
}
