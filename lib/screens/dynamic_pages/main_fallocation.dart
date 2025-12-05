import 'package:flutter/material.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/app_design.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';


class DynamicAllocation extends StatefulWidget {
  final VoidCallback settingstogglee;
  final VoidCallback menutoggle;

  const DynamicAllocation({super.key, 
  required this.settingstogglee,
  required this.menutoggle,
  });

  @override
  State<DynamicAllocation> createState() => _DynamicProfileState();
}

class _DynamicProfileState extends State<DynamicAllocation> {
  @override
  Widget build(BuildContext context) {
    return PrimaryPages(
      menutogglee: widget.menutoggle,
      header: Pageheaders(
        settingstogglee: widget.settingstogglee, 
        title: 'Allocation', 
        child: null
        ),
      childofmainpage: null
    );
  }
}