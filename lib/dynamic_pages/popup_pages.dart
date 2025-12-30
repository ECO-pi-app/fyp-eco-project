import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/riverpod.dart';

//----------------------------------SETTINGS POPUP PAGES----------------------------------------------
void showAdvancedMaterials(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Popup",
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.0).animate(curved),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 70,
                right: 10,
                bottom: 70,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Apptheme.transparentcheat,
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: UnitsPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
class AdvancedMaterials extends ConsumerWidget {
  const AdvancedMaterials({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FrostedBackgroundGeneral(
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Labels(
                      title: "Display unit",
                      color: Apptheme.textclrlight,
                      fontsize: 19,
                      toppadding: 0,
                      leftpadding: 10,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Labels(
                      title: "[]",
                      color: Apptheme.textclrlight,
                      fontsize: 19,
                      toppadding: 0,
                      leftpadding: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
          Expanded(
            child: FrostedBackgroundGeneral(
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Textsinsidewidgets(
                      words: 'Output display unit: ${ref.watch(unitNameProvider)}', 
                      color: Apptheme.textclrlight,
                      fontsize: 17,
                    ),
                  )
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}



//-------------------------------------GENERAL--------------------------------------------------------
class GeneralPage extends StatelessWidget {
  const GeneralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FrostedBackgroundGeneral(
      child: Center(
        child: Labels(
          title: "General Settings Page Content",
          color: Apptheme.textclrlight,
          fontsize: 20,
        ),
      ),
    );
  }
}

//-------------------------------------UNITS----------------------------------------------------------
void showUnitsPopup(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Popup",
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.0).animate(curved),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 70,
                right: 10,
                bottom: 70,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Apptheme.transparentcheat,
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: UnitsPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
class UnitsPage extends ConsumerWidget {
  const UnitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FrostedBackgroundGeneral(
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Labels(
                      title: "Display unit",
                      color: Apptheme.textclrlight,
                      fontsize: 19,
                      toppadding: 0,
                      leftpadding: 10,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Labels(
                      title: "[]",
                      color: Apptheme.textclrlight,
                      fontsize: 19,
                      toppadding: 0,
                      leftpadding: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
          Expanded(
            child: FrostedBackgroundGeneral(
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Textsinsidewidgets(
                      words: 'Output display unit: ${ref.watch(unitNameProvider)}', 
                      color: Apptheme.textclrlight,
                      fontsize: 17,
                    ),
                  )
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}

//-------------------------------------ECO-pi METHODOLOGY---------------------------------------------
void showMethodologyPopup(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Popup",
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.0).animate(curved),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 70,
                right: 10,
                bottom: 70,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Apptheme.transparentcheat,
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: MethodologyPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
class MethodologyPage extends ConsumerWidget {
  const MethodologyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FrostedBackgroundGeneral(
      child: ListView(
        children: [
          Labels(title: 'Uncertainies', color: Apptheme.textclrlight, fontsize: 30,),
          Labels(title: 'Parameter uncertainty', color: Apptheme.textclrlight, fontsize: 20,)
        ],
      )
    );
  }
}








//-------------------------------------REUSEABLE TRANSLUCENT BACKGROUND----------------------------
class FrostedBackgroundGeneral extends StatelessWidget {
  final Widget child;
  const FrostedBackgroundGeneral({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7.5),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: Apptheme.widgetclrlight.withOpacity(0.2),
          child: child,
        ),
      ),
    );
  }
}

//-------------------------------------DEVELOPER'S PAGE----------------------------------------------

class DeveloperPage extends ConsumerWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaOptionsAsync = ref.watch(metaOptionsProvider);
    final productsAsync = ref.watch(productsProvider);
    final emissions = ref.watch(emissionCalculatorProvider);
    final convertedEmissions = ref.watch(convertedEmissionsProvider);
    final unit = ref.watch(unitLabelProvider);

    return 
      
      ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // ----------------- UNIT CONVERSION -----------------
          _sectionHeader('Unit Conversion'),
          Textsinsidewidgets(words: 'Current Unit: $unit', color: Apptheme.textclrlight,),
          Textsinsidewidgets(words: 'Raw Conversion Factor: ${ref.watch(unitConversionProvider)}', color: Apptheme.textclrlight,),

          const SizedBox(height: 20),

          // ----------------- META OPTIONS -----------------
          _sectionHeader('Meta Options'),
          metaOptionsAsync.when(
            data: (meta) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Textsinsidewidgets(words: 'Countries: ${meta.countries}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Materials: ${meta.materials}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Machines: ${meta.machines}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Packaging Types: ${meta.packagingTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Recycling Types: ${meta.recyclingTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Transport Types: ${meta.transportTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Indicator: ${meta.indicator}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'GHG: ${meta.ghg}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'GWP: ${meta.gwp}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Process: ${meta.process}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Facilities: ${meta.facilities}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Usage Types: ${meta.usageTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Disassembly by Industry: ${meta.disassemblyByIndustry}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Machine Type: ${meta.machineType}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'YCM Types: ${meta.ycmTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Amada Types: ${meta.amadaTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Mazak Types: ${meta.mazakTypes}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'Van Mode: ${meta.vanMode}', color: Apptheme.textclrlight),
                const SizedBox(height: 10),

                Textsinsidewidgets(words: 'HGV Mode: ${meta.hgvMode}', color: Apptheme.textclrlight),

              ],
            ),
            loading: () => const Text('Loading meta options...'),
            error: (e, st) => Text('Error: $e'),
          ),

          const SizedBox(height: 20),


          // ----------------- PRODUCTS -----------------
          _sectionHeader('Products / Profiles'),
          productsAsync.when(
            data: (products) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: products
                  .map((p) => Textsinsidewidgets( words: '- ${p.name}', color: Apptheme.textclrlight,))
                  .toList(),
            ),
            loading: () => const Text('Loading products...'),
            error: (e, st) => Text('Error: $e'),
          ),

          const SizedBox(height: 20),

          // ----------------- EMISSIONS -----------------
          _sectionHeader('Emissions (raw)'),
          Textsinsidewidgets(words: 'Material: ${emissions.material}', color: Apptheme.textclrlight),
          Textsinsidewidgets(words: 'Transport: ${emissions.transport}', color: Apptheme.textclrlight),
          Textsinsidewidgets(words: 'Machining: ${emissions.machining}', color: Apptheme.textclrlight),
          Textsinsidewidgets(words: 'Fugitive: ${emissions.fugitive}', color: Apptheme.textclrlight),
          Textsinsidewidgets(words: 'Total: ${emissions.total}', color: Apptheme.textclrlight),

          const SizedBox(height: 10),
          _sectionHeader('Emissions (converted)'),
          Textsinsidewidgets(words: 'Material: ${convertedEmissions.material} $unit', color: Apptheme.textclrlight),
          Textsinsidewidgets(words: 'Transport: ${convertedEmissions.transport} $unit', color: Apptheme.textclrlight),
          Textsinsidewidgets(words: 'Machining: ${convertedEmissions.machining} $unit', color: Apptheme.textclrlight),
          Textsinsidewidgets(words: 'Fugitive: ${convertedEmissions.fugitive} $unit', color: Apptheme.textclrlight),
          Textsinsidewidgets(words: 'Total: ${convertedEmissions.total} $unit', color: Apptheme.textclrlight),


          const SizedBox(height: 20),

          // ----------------- DEBUG PRINTS (API POSTS) -----------------
          _sectionHeader('Debug Prints / API Logs'),
          const Textsinsidewidgets(
              words: 'All prints from calculation, fetch, save, delete operations appear in your console.\nThis section can be extended to capture them in-app if needed.',
              color: Apptheme.textclrlight,
              ),
        ],
      );

  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Textsinsidewidgets(
        words: title,
        color: Apptheme.textclrlight,
        fontsize: 20,
        fontweight: FontWeight.bold,
      ),
    );
  }
}
















