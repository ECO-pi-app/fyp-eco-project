import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/app_design.dart';


class DynamicAllocation extends StatefulWidget {
  final VoidCallback settingstogglee;
  const DynamicAllocation({super.key, 
  required this.settingstogglee});

  @override
  State<DynamicAllocation> createState() => _DynamicProfileState();
}

class _DynamicProfileState extends State<DynamicAllocation> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: 
          Column(
          children: [

            //--Custom Header for Home--
            PageHeaderFour(title: 'Allocation',
            summary: 'Type here', 
            whathappens: widget.settingstogglee,
            color: Apptheme.auxilary,
            ),
        
            
            //--Main Page--
            Expanded(
              child: Padding(padding: EdgeInsetsGeometry.all(20),
              child: null
              ),
            )
          ],
          ),
      );
  }
}