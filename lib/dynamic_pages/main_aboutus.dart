import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/headers.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets.dart';


class DynamicCredits extends StatefulWidget {

  const DynamicCredits({super.key, 
  });

  @override
  State<DynamicCredits> createState() => _DynamicCreditsState();
}

class _DynamicCreditsState extends State<DynamicCredits> {
  @override
  Widget build(BuildContext context) {
    return PrimaryPages( 
      childofmainpage: Widgets1(
        maxheight: 500,
        backgroundcolor: Apptheme.widgetsecondaryclr,
        child: null,
      ),
    );
  }
}