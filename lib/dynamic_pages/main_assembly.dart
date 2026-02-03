import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/app_logic/riverpod_statemanagement.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';

class DynamicAssembly extends ConsumerStatefulWidget {
  const DynamicAssembly({super.key});

  @override
  ConsumerState<DynamicAssembly> createState() => _DynamicAssemblyState();
}

class _DynamicAssemblyState extends ConsumerState<DynamicAssembly> {
  final Set<String> selectedBasicParts = {};

  final ScrollController _partsScrollController = ScrollController();


Future<void> _showAddAssemblyDialog() async {
  if (selectedBasicParts.isEmpty) return;

  final nameController = TextEditingController();
  final scrollController = ScrollController();

  final product = ref.read(activeProductProvider);
  final timeline = ref.read(activeTimelineProvider);
  if (product == null || timeline == null) return;

  final result = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    builder: (dialogContext) {
      return Consumer(
        builder: (_, ref, __) {
          final assemblyList = ref.watch(assemblyProcessesProvider);
          final selectedProcess = ref.watch(selectedAssemblyProcessProvider);
          final timeTaken = ref.watch(assemblyTimeProvider);

          return AlertDialog(
            title: const Text("Add Assembly Process"),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Assembly Name
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Assembly Name",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          ref.read(assemblyNameProvider.notifier).state = value,
                    ),
                    const SizedBox(height: 10),

                    // Select Process (static list)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Process:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: assemblyList.length,
                          itemBuilder: (_, index) {
                            final process = assemblyList[index];
                            final isSelected = selectedProcess == process;
                            return ListTile(
                              title: Text(process),
                              tileColor: isSelected
                                  ? Colors.blue.withOpacity(0.2)
                                  : null,
                              onTap: () {
                                ref
                                    .read(selectedAssemblyProcessProvider.notifier)
                                    .state = process;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Time input
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Time taken',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          ref.read(assemblyTimeProvider.notifier).state = value,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(dialogContext, rootNavigator: true).pop(false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      selectedProcess == null ||
                      timeTaken.isEmpty) return;

                  Navigator.of(dialogContext, rootNavigator: true).pop(true);
                },
                child: const Text("Add"),
              ),
            ],
          );
        },
      );
    },
  );

  if (result != true) return;

  final assemblyNameValue = ref.read(assemblyNameProvider);

  // Add the compound part
  ref
      .read(
        compoundPartsProvider((product: product, timeline: timeline)).notifier,
      )
      .addCompound(assemblyNameValue, selectedBasicParts.toList());

  // Reset state
  ref.read(selectedAssemblyProcessProvider.notifier).state = null;
  ref.read(assemblyTimeProvider.notifier).state = '';
  ref.read(assemblyNameProvider.notifier).state = '';
}

Future<void> _showAddHigherCompoundDialog() async {
  final product = ref.read(activeProductProvider);
  final timeline = ref.read(activeTimelineProvider);
  if (product == null || timeline == null) return;

  final compounds =
      ref.read(compoundPartsProvider((product: product, timeline: timeline))).compounds;

  if (compounds.isEmpty) return;

  final selected = <String>{};
  final nameController = TextEditingController();

  final result = await showDialog<String>(
    context: context,
    useRootNavigator: true,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (_, setState) {
          return AlertDialog(
            title: const Text("New Higher-Level Compound"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...compounds.map(
                    (c) => CheckboxListTile(
                      title: Text(c.name),
                      value: selected.contains(c.name),
                      onChanged: (v) {
                        setState(() {
                          if (v == true) {
                            selected.add(c.name);
                          } else {
                            selected.remove(c.name);
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: "Compound Name"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop(null);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  Navigator.of(dialogContext, rootNavigator: true).pop(name);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    },
  );

  if (result == null || result.isEmpty || selected.isEmpty) return;

  ref
      .read(
        higherCompoundPartsProvider((product: product, timeline: timeline))
            .notifier,
      )
      .addHigherCompound(result, selected.toList());
}

String _partsSearchQuery = '';

@override
void dispose() {
  _partsScrollController.dispose();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    final basicParts = ref.watch(partsProvider);

    final product = ref.watch(activeProductProvider);
    final timeline = ref.watch(activeTimelineProvider);

    final compoundParts = (product != null && timeline != null)
        ? ref.watch(compoundPartsProvider((product: product, timeline: timeline))).compounds
        : <CompoundPart>[];

    final higherCompounds = (product != null && timeline != null)
        ? ref.watch(higherCompoundPartsProvider((product: product, timeline: timeline))).compounds
        : <HigherCompoundPart>[];

    final filteredParts = basicParts
        .where((part) => part.toLowerCase().contains(_partsSearchQuery))
        .toList();

    return PrimaryPages(
      childofmainpage: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            // ----------------- BASIC PARTS -----------------
            const Labels(title: "Basic Parts", color: Apptheme.textclrdark),
            const SizedBox(height: 5),

            // Search box
            TextField(
              decoration: const InputDecoration(
                labelText: "Search Parts",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _partsSearchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 8),

            // Parts list (scrollable horizontal)
SizedBox(
  height: 80,
  child: Scrollbar(
    controller: _partsScrollController,
    thumbVisibility: true,
    child: ListView(
      controller: _partsScrollController,
      scrollDirection: Axis.horizontal,
      children: filteredParts.map((part) {
        final selected = selectedBasicParts.contains(part);
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            backgroundColor: Apptheme.widgettertiaryclr,
            selectedColor: Apptheme.widgetsecondaryclr,
            label: Container(
              height: 25,
              color: Apptheme.transparentcheat,
              child: Textsinsidewidgetsdrysafe(
                words: part,
                color: Apptheme.textclrdark,
                toppadding: 0,
              ),
            ),
            selected: selected,
            onSelected: (v) {
              setState(() {
                v
                    ? selectedBasicParts.add(part)
                    : selectedBasicParts.remove(part);
              });
            },
          ),
        );
      }).toList(),
    ),
  ),
),
            const SizedBox(height: 8),

            // Button to add assembly
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Apptheme.widgettertiaryclr,
                foregroundColor: Apptheme.widgetclrdark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _showAddAssemblyDialog,
              child: const SizedBox(
                width: 180,
                child: Textsinsidewidgets(
                  words: "Create Compound Part",
                  color: Apptheme.textclrdark,
                  toppadding: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ----------------- COMPOUND PARTS -----------------
            const Labels(title: "Compound Parts", color: Apptheme.textclrdark),
            const SizedBox(height: 5),
            if (compoundParts.isEmpty)
              const Textsinsidewidgetsdrysafe(
                words: "No compound parts created yet",
                color: Apptheme.textclrdark,
                toppadding: 0,
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: compoundParts.length,
              itemBuilder: (_, index) {
                final c = compoundParts[index];
                return ListTile(
                  contentPadding: const EdgeInsets.only(bottom: 5, left: 17),
                  title: Textsinsidewidgetsdrysafe(
                    words: c.name,
                    color: Apptheme.textclrdark,
                    fontsize: 17,
                    toppadding: 0,
                  ),
                  subtitle: Textsinsidewidgetsdrysafe(
                    words:
                        "Components: ${c.components.join(", ")} | Process: ${c.assemblyProcess ?? 'N/A'}",
                    color: Apptheme.textclrdark,
                    fontsize: 13,
                    toppadding: 5,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Apptheme.widgettertiaryclr,
                foregroundColor: Apptheme.widgetclrdark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _showAddHigherCompoundDialog,
              child: const SizedBox(
                width: 225,
                child: Textsinsidewidgets(
                  words: "Add Higher-Level Compound",
                  color: Apptheme.textclrdark,
                  toppadding: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ----------------- HIGHER LEVEL -----------------
            if (higherCompounds.isNotEmpty) ...[
              const Labels(title: "Higher-Level Compounds", color: Apptheme.textclrdark),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: higherCompounds.length,
                itemBuilder: (_, index) {
                  final c = higherCompounds[index];
                  return ListTile(
                    title: Textsinsidewidgetsdrysafe(
                      words: c.name,
                      color: Apptheme.textclrdark,
                      fontsize: 17,
                      toppadding: 0,
                    ),
                    subtitle: Textsinsidewidgetsdrysafe(
                      words: "Components: ${c.components.join(", ")}",
                      color: Apptheme.textclrdark,
                      fontsize: 13,
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

