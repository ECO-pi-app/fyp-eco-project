import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/headers.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';


class DynamicAllocation extends StatefulWidget {

  const DynamicAllocation({super.key, 
  });

  @override
  State<DynamicAllocation> createState() => _DynamicProfileState();
}

class _DynamicProfileState extends State<DynamicAllocation> {
  @override
  Widget build(BuildContext context) {
    return PrimaryPages(
      childofmainpage: Labels(
        title: 'Thing', 
        color: Apptheme.textclrdark,
        fontsize: 20,
      )
    );
  }
}