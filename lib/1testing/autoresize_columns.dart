import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';

//--COLUMN BASED (EQUIVALENT TO FIRSTTAB)--
class AutoColumn extends StatefulWidget {
  final int containernum;
  final List<int> flexvalues;
  final Widget childof1;

  
  const AutoColumn({super.key,
  required this.containernum,
  required this.flexvalues,
  required this.childof1,
  
  });

  @override
  State<AutoColumn> createState() => _AutoColumnState();
}

class _AutoColumnState extends State<AutoColumn> {

  @override
  Widget build(BuildContext context) {
    return
    Expanded(child:
      Padding(padding: EdgeInsetsGeometry.all(5),
      child: 
        Align(
          alignment: AlignmentGeometry.topCenter,
          child:
          Flexbox(
            numberOfContainers: widget.containernum,
            direction: Axis.horizontal,
            flexValues: widget.flexvalues,
            childofthis: widget.childof1,
            ),
          )
      ),
    );
  }
}

//--GENERATES THE ASKED NUMBER OF FLEXIBLE BOXES,--
//--NUMBER OF X AT THE END REPRESENTS THE PAGE (Flexboxx=2nd Tabbed Page)
class Flexbox extends StatelessWidget {
  final int numberOfContainers;
  final Axis direction; 
  final List<int> flexValues;
  final Widget childofthis;

  const Flexbox({super.key,
    required this.numberOfContainers,
    this.direction = Axis.vertical,
    required this.flexValues,
    required this.childofthis,
  });

  @override
  Widget build(BuildContext context) {
 

    final children = List.generate(
      numberOfContainers,
      (index) => 

    //--INDIVIDUAL FLEXIBLE BOX--
    Flexible(
      fit: FlexFit.tight,
      flex: flexValues[index],
      child:
      Padding(padding: EdgeInsetsGeometry.all(5),
      child: 
        Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Apptheme.error,
        ),
        child: childofthis,
        ),
      ),
    ),
    //--INDIVIDUAL FLEXIBLE BOX--
    );

    return direction == Axis.vertical
        ? Column(children: children)
        : Row(children: children);
  }
}
