import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';



class Dynamichome extends ConsumerStatefulWidget {
  const Dynamichome({super.key,
  });


  @override
  ConsumerState<Dynamichome> createState() => _DynamichomeState();
}

class _DynamichomeState extends ConsumerState<Dynamichome> {

int selectedToggle = 0;

final List<String> toggleOptions = [
  'Scope',
  'Attributes',
  'Boundary'
];


  @override
  Widget build(BuildContext context) {
       
    return PrimaryPages(
      backgroundcolor: Apptheme.widgetclrlight,
      childofmainpage: null
,
    );
  }
}



         