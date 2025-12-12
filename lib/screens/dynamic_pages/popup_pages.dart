import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/riverpod.dart';





//-------------------------------------GENERAL-------------------------------------------------------
class GeneralPage extends StatelessWidget {
  const GeneralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Labels(
        title: "General Settings Page Content",
        color: Apptheme.textclrlight,
        fontsize: 20,
      ),
    );
  }
}

//-------------------------------------UNITS-------------------------------------------------------
class UnitsPage extends ConsumerWidget {
  const UnitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Labels(
            title: "Output Unit: ${ref.watch(unitNameProvider)}",
            color: Apptheme.textclrdark,
            fontsize: 20,
            toppadding: 5,
            leftpadding: 10,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Labels(
            title: "Input Unit: [To be defined]",
            color: Apptheme.textclrdark,
            fontsize: 20,
            toppadding: 30,
            leftpadding: 10,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              Textsinsidewidgets(
                words: 'Keep input as same unit', 
                color: Apptheme.textclrdark,
                leftpadding: 15,
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  bool isChecked = true;

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() => isChecked = value ?? false);
                      },
                    ),
                  );
                },
              )

            ],
          )
        ),
      ],
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
          color: Apptheme.backgrounddark.withOpacity(0.6),
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
          Text('Current Unit: $unit'),
          Text('Raw Conversion Factor: ${ref.watch(unitConversionProvider)}'),

          const SizedBox(height: 20),

          // ----------------- META OPTIONS -----------------
          _sectionHeader('Meta Options'),
          metaOptionsAsync.when(
            data: (meta) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Countries: ${meta.countries}'),
                const SizedBox(height: 10),
                Text('Materials: ${meta.materials}'),
                const SizedBox(height: 10),
                Text('Machines: ${meta.machines}'),
                const SizedBox(height: 10),
                Text('Packaging Types: ${meta.packagingTypes}'),
                const SizedBox(height: 10),
                Text('Recycling Types: ${meta.recyclingTypes}'),
                const SizedBox(height: 10),
                Text('Transport Types: ${meta.transportTypes}'),
                const SizedBox(height: 10),
                Text('Indicator: ${meta.indicator}'),
                const SizedBox(height: 10),
                Text('GHG: ${meta.ghg}'),
                const SizedBox(height: 10),
                Text('GWP: ${meta.gwp}'),
                const SizedBox(height: 10),
                Text('Process: ${meta.process}'),
                const SizedBox(height: 10),
                Text('Facilities: ${meta.facilities}'),
                const SizedBox(height: 10),
                Text('Usage Types: ${meta.usageTypes}'),
                const SizedBox(height: 10),
                Text('Disassembly by Industry: ${meta.disassemblyByIndustry}'),
                const SizedBox(height: 10),
                Text('Machine Type: ${meta.machineType}'),
                const SizedBox(height: 10),
                Text('YCM Types: ${meta.ycmTypes}'),
                const SizedBox(height: 10),
                Text('Amada Types: ${meta.amadaTypes}'),
                const SizedBox(height: 10),
                Text('Mazak Types: ${meta.mazakTypes}'),
                const SizedBox(height: 10),
                Text('Van Mode: ${meta.vanMode}'),
                const SizedBox(height: 10),
                Text('HGV Mode: ${meta.hgvMode}'),
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
                  .map((p) => Text('- ${p.name}', style: const TextStyle(fontSize: 14)))
                  .toList(),
            ),
            loading: () => const Text('Loading products...'),
            error: (e, st) => Text('Error: $e'),
          ),

          const SizedBox(height: 20),

          // ----------------- EMISSIONS -----------------
          _sectionHeader('Emissions (raw)'),
          Text('Material: ${emissions.material}'),
          Text('Transport: ${emissions.transport}'),
          Text('Machining: ${emissions.machining}'),
          Text('Fugitive: ${emissions.fugitive}'),
          Text('Total: ${emissions.total}'),

          const SizedBox(height: 10),
          _sectionHeader('Emissions (converted)'),
          Text('Material: ${convertedEmissions.material} $unit'),
          Text('Transport: ${convertedEmissions.transport} $unit'),
          Text('Machining: ${convertedEmissions.machining} $unit'),
          Text('Fugitive: ${convertedEmissions.fugitive} $unit'),
          Text('Total: ${convertedEmissions.total} $unit'),

          const SizedBox(height: 20),

          // ----------------- DEBUG PRINTS (API POSTS) -----------------
          _sectionHeader('Debug Prints / API Logs'),
          const Text(
              'All prints from calculation, fetch, save, delete operations appear in your console.\nThis section can be extended to capture them in-app if needed.'),
        ],
      );

  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
















