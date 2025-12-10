import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/headers.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets.dart';


class DynamicCredits extends StatefulWidget {
  final VoidCallback settingstogglee;
  final VoidCallback menutoggle;

  const DynamicCredits({super.key, 
  required this.settingstogglee,
  required this.menutoggle,
  });

  @override
  State<DynamicCredits> createState() => _DynamicCreditsState();
}

class _DynamicCreditsState extends State<DynamicCredits> {
  @override
  Widget build(BuildContext context) {
    return PrimaryPages(
      menutogglee: widget.menutoggle, 
      header: Pageheaders(
        settingstogglee: widget.settingstogglee, 
        title: 'About Us', 
        child: null,
      ),
      childofmainpage: Widgets1(
        maxheight: 500,
        backgroundcolor: Apptheme.widgetsecondaryclr,
        child: null,
      ),
    );
  }
}