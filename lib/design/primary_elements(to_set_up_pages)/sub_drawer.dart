import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/dynamic_pages/popup_pages.dart';
import 'package:test_app/dynamic_pages/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/riverpod.dart';

class ContentofL extends ConsumerStatefulWidget {
  final Function(int) onSelectPage;
  final double widthoffirstsegment;

  const ContentofL({super.key,
  required this.onSelectPage,
  required this.widthoffirstsegment
  });

  @override
  ConsumerState<ContentofL> createState() => _ContentofLState();
}

class _ContentofLState extends ConsumerState<ContentofL> {
  @override
  Widget build(BuildContext context) {
    return 

    Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                _subdrawertile((Icons.settings), 'Settings',  () => showSettingsPopup(context)),
            
                _subdrawertile((Icons.scale), 'Units', () => showUnitsPopup(context)),
            
                _subdrawertile((Icons.supervised_user_circle), 'Method', () => showMethodologyPopup(context)),
            
                Container(
                  color:Apptheme.transparentcheat, 
                  height: 700,
                  width: 60,
                )
              
              ],
            ),
          ),
        ),
      
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 1),
              child: Container(
                color: Apptheme.widgetsecondaryclr,
                width: 150,
                height: 20,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<double>(
                    dropdownColor: Apptheme.highlights,
                    iconEnabledColor: Apptheme.textclrlight,
                    value: ref.watch(unitConversionProvider),
                    items: conversionFactors.entries.map((entry) {
                      return DropdownMenuItem<double>(
                        value: entry.value,
                        child: Labels(
                          title: entry.key, 
                          color: Apptheme.textclrlight,
                          fontsize: 12,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(unitConversionProvider.notifier).state = value;
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        )
      
      ],
    );

  }
}


Widget _subdrawertile (IconData icon, String title, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Container(
      color: Apptheme.transparentcheat,
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 25,
            child: InkWell(
              onTap: onTap,
              child: Icon(icon, 
                size: 25, 
                color: Apptheme.iconslight,
              )
            )
          ),
          SizedBox(
            height: 10,
            child: Labelsinsubdrawer(label: title)
          )
        ],
      ),
    ),
  );
}





class LShapeClipper extends CustomClipper<Path> {
  final double verticalWidth;
  final double horizontalHeight;
  final double outerRadius;
  final double innerRadius;
  final double heightsubtract;

  LShapeClipper({
    required this.verticalWidth,
    required this.horizontalHeight,
    this.outerRadius = 20,
    this.innerRadius = 20,
    this.heightsubtract= 400
  });

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final heightoffset = heightsubtract;

    final vw = verticalWidth;
    final hh = horizontalHeight;

    final maxOuterRadius = (h - horizontalHeight - heightoffset) / 2;
    final maxInnerRadius = (h - horizontalHeight - heightoffset) / 2;

    final or = outerRadius.clamp(0, maxOuterRadius);
    final ir = innerRadius.clamp(0, maxInnerRadius);

    final path = Path();

    path.moveTo(0, heightoffset);

    path.lineTo(vw - or, heightoffset);
    path.quadraticBezierTo(vw, heightoffset, vw, heightoffset+or);

    path.lineTo(vw , h - (hh+ir));
    path.quadraticBezierTo(vw, h - (hh), vw+ir, h- hh);

    path.lineTo(vw+ir , h - hh);

    path.lineTo(w, h-hh);

    path.lineTo(w, h);

    path.lineTo(0, h);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class LShapeContainer extends StatefulWidget {
  final double verticalWidth;
  final double horizontalHeight;
  final double outerRadius;
  final double innerRadius;
  final double heightoffset;
  final Function(int) onSelectPage;

  final Gradient? gradient;
  final DecorationImage? image;
  final Widget? child;

  const LShapeContainer({
    super.key,
    required this.verticalWidth,
    required this.horizontalHeight,
    this.outerRadius = 30,
    this.innerRadius = 50,
    this.heightoffset = 350,
    this.gradient,
    this.image,
    this.child,
    required this.onSelectPage,
  });

  @override
  State<LShapeContainer> createState() => _LShapeContainerState();
}

class _LShapeContainerState extends State<LShapeContainer> {
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: LShapeClipper(
        verticalWidth: widget.verticalWidth,
        horizontalHeight: widget.horizontalHeight,
        outerRadius: widget.outerRadius,
        innerRadius: widget.innerRadius,
        heightsubtract: widget.heightoffset
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Apptheme.tertiarysecondaryclr,
          gradient: widget.gradient,
          image: widget.image,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: widget.heightoffset+10, left: 0),
          child: ContentofL(
            widthoffirstsegment: widget.verticalWidth,
            onSelectPage: widget.onSelectPage,
          ),
        ),
      ),
    );
  }
}