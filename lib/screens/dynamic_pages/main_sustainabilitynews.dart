import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/app_design.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets.dart';


class DynamicSustainabilityNews extends StatefulWidget {
  final VoidCallback settingstogglee;
  final VoidCallback menutoggle;

  const DynamicSustainabilityNews({super.key, 
  required this.settingstogglee,
  required this.menutoggle,
  });

  @override
  State<DynamicSustainabilityNews> createState() => _DynamicProfileState();
}

class _DynamicProfileState extends State<DynamicSustainabilityNews> {
  @override
  Widget build(BuildContext context) {
    return PrimaryPages(
      menutogglee: widget.menutoggle, 
      header: Pageheaders(
        settingstogglee: widget.settingstogglee, 
        title: 'Sustainability News', 
        child: null
      ),
      childofmainpage: Widgets1(
        maxheight: 500,
        backgroundcolor: Apptheme.widgetsecondaryclr,
        child: null,
      ),
    );
  }
}