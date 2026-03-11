import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:test_app/app_logic/riverpod_account.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/app_logic/riverpod_calculation.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/info_popup.dart';
import 'package:test_app/governing_screens/primarypage.dart';

/// ---------------- ACTIVE PART PROVIDER ----------------
class ActivePartNotifier extends StateNotifier<String?> {
  final Ref ref;
  ActivePartNotifier(this.ref) : super(null) {
    ref.listen<List<String>>(partsProvider, (previous, next) {
      if (next.isNotEmpty && state == null) {
        state = next.first;
      }
    });
  }

  void setPart(String? part) => state = part;
}

/// ---------------- MAIN PAGE ----------------
class Dynamichome extends ConsumerStatefulWidget {
  final String? productName;
  const Dynamichome({super.key, this.productName});

  @override
  ConsumerState<Dynamichome> createState() => _DynamichomeState();
}

class _DynamichomeState extends ConsumerState<Dynamichome> {
  final pieKey = GlobalKey();
@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final username = ref.read(usernameProvider).value;
    if (widget.productName != null && username != null) {

      final product = await fetchProductDetail(username, widget.productName!);
      ref.read(activeProductProvider.notifier).state = product;

      hydrateTimelines(ref, product);

      final timelines = (product.data["timelines"] as Map<String, dynamic>?)?.keys.toList();
      if (timelines != null && timelines.isNotEmpty) {
        final firstTimeline = timelines.first;
        ref.read(activeTimelineProvider.notifier).state = firstTimeline;

        final pieNotifier = ref.read(
          pieChartProvider((product: product, timeline: firstTimeline)).notifier,
        );
        pieNotifier.clear();

        final partsMap = product.data["timelines"]?[firstTimeline]?["parts"] as Map<String, dynamic>?;

        if (partsMap != null) {
          for (var partName in partsMap.keys) {
            pieNotifier.addPart(partName, 0);
          }
        }
      }
    }
  });
}


/// ---------- TIMELINE DIALOG ----------
Future<Map<String, String>?> _showTimelineDialog() async {
  const months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  // Generate a list of years, e.g., 2000 → current year + 5
  final currentYear = DateTime.now().year;
  final years = List.generate(30, (i) => (currentYear - 20 + i).toString());

  String? selectedYear;
  String? selectedStartMonth;
  String? selectedEndMonth;

  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (_, setState) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Add New Timeline"),
              InfoIconPopupDark(
                text: 'Define the time period of the study',
                iconSize: 20,
              )
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Year dropdown
                SizedBox(
                  width: 250,
                  child: DropdownButtonFormField<String>(
                    value: selectedYear,
                    hint: const Text("Select Year"),
                    items: years
                        .map((y) => DropdownMenuItem(
                              value: y,
                              child: Text(y),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedYear = val),
                    decoration: const InputDecoration(
                      labelText: "Year",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Start month dropdown
                DropdownButtonFormField<String>(
                  value: selectedStartMonth,
                  hint: const Text("Select Start Month"),
                  items: months
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(m),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => selectedStartMonth = val),
                  decoration: const InputDecoration(
                    labelText: "Start Month",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),

                // End month dropdown
                DropdownButtonFormField<String>(
                  value: selectedEndMonth,
                  hint: const Text("Select End Month"),
                  items: months
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(m),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => selectedEndMonth = val),
                  decoration: const InputDecoration(
                    labelText: "End Month",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Add"),
            ),
          ],
        );
      },
    ),
  );

  // Validate selection
  if (selectedYear == null || selectedStartMonth == null || selectedEndMonth == null) {
    return null;
  }

  return {
    "name": selectedYear!,
    "start": selectedStartMonth!,
    "end": selectedEndMonth!,
  };
}
  Future<void> _addTimeline() async {
    final product = ref.read(activeProductProvider);
    if (product == null) return;

    final result = await _showTimelineDialog();
    if (result == null) return;

    final timelineName = result["name"]!;
    final start = result["start"]!;
    final end = result["end"]!;

    ref.read(timelineProvider(product.name).notifier).addTimeline(timelineName);
    ref.read(activeTimelineProvider.notifier).state = timelineName;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    ref.read(timelineDurationProvider(product.name).notifier).state = {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      ...ref.read(timelineDurationProvider(product.name).notifier).state,
      timelineName: {"start": start, "end": end},
    };
  }

  Future<void> _addPart() async {
    final product = ref.read(activeProductProvider);
    final timeline = ref.read(activeTimelineProvider);
    if (product == null || timeline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a timeline first")),
      );
      return;
    }

    final nameController = TextEditingController();
    final partName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Part"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Part Name"),
          autofocus: true,
          onSubmitted: (val) => Navigator.pop(context, val),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, nameController.text), child: const Text("Add")),
        ],
      ),
    );

    if (partName == null || partName.trim().isEmpty) return;

    final emissionResult = ref.watch(savedEmissionsProvider((product: product.name, part: partName)));
    final totalValue = emissionResult.total;

    ref.read(pieChartProvider((product: product, timeline: timeline)).notifier)
        .addPart(partName, totalValue);
    ref.read(activePartProvider.notifier).setPart(partName);

  }

  Future<String?> showRenameDialog(
    BuildContext context,
    String currentName,
    String title,
  ) async {
    final nameController = TextEditingController(text: currentName);

    final result = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "New name",
                border: OutlineInputBorder(),
              ),
              autofocus: true,
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
                if (nameController.text.trim().isEmpty) return;
                Navigator.of(dialogContext, rootNavigator: true).pop(true);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );

    // If user pressed Save, return the new name
    if (result == true) return nameController.text.trim();
    return null;
  }

  Future<void> _renamePart(String oldName) async {
    final product = ref.read(activeProductProvider);
    final timeline = ref.read(activeTimelineProvider);
    if (product == null || timeline == null) return;

    final newName = await showRenameDialog(context, oldName, "Rename Part");
    if (newName == null || newName.trim().isEmpty) return;

    final oldKey = (product: product.name, part: oldName);
    final oldState = ref.read(savedEmissionsProvider(oldKey));

    final newKey = (product: product.name, part: newName);
    ref
        .read(savedEmissionsProvider(newKey).notifier)
        .setResults(oldState);

    ref.read(pieChartProvider((product: product, timeline: timeline)).notifier)
        .renamePart(oldName, newName);
    ref.read(activePartProvider.notifier).setPart(newName);

    ref.invalidate(savedEmissionsProvider(oldKey));
  }
    
  Future<void> _renameTimeline(String oldName) async {
    final product = ref.read(activeProductProvider);
    if (product == null) return;

    final newName = await showRenameDialog(context, oldName, "Rename Timeline");
    if (newName == null || newName.trim().isEmpty) return;

    ref.read(timelineProvider(product.name).notifier)
        .renameTimeline(oldName, newName);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(productTimelineResetProvider);
    ref.watch(activeProductLoaderProvider); 


    final product = ref.watch(activeProductProvider);
    final activeTimeline = ref.watch(activeTimelineProvider);
    final activePart = ref.watch(activePartProvider);
    final timelines = product != null ? ref.watch(timelineProvider(product.name)) : null;
    final timelineValues = product != null ? ref.watch(timelineDurationProvider(product.name)) : {};

    final parts = ref.watch(partsProvider);
    final results = List.generate(parts.length, (i) {
      final partName = parts[i];
      return ref.watch(
        savedEmissionsProvider((product: product!.name, part: partName)),
      );
    });

    final timelineTotals = (product != null && timelines != null)
      ? timelines.timelines.map((t) {
          return ref.watch(timelineTotalProvider((product, t)));
        }).toList()
      : <double>[];

    final maxTimelineY = timelineTotals.isEmpty
        ? 1.0
        : timelineTotals
                .reduce((a, b) => a > b ? a : b)
                .toDouble() *
            1.2;

    debugPrint('Active part: $activePart, All parts: $parts');

    return PrimaryPages(
      backgroundcolor: Apptheme.widgetclrlight,
      childofmainpage: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- TIMELINES ----------------
            Row(
              children: [
                const Labels(title: "Emission over time", color: Apptheme.textclrdark),
                const Spacer(),
                IconButton(onPressed: _addTimeline, icon: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (product != null && timelines != null)
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          maxY: maxTimelineY,
                          alignment: BarChartAlignment.spaceAround,
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (val, meta) {
                                  final idx = val.toInt();
                                  if (idx < 0 || idx >= timelines.timelines.length) {
                                    return const SizedBox();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      timelines.timelines[idx],
                                      style: const TextStyle(fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          barGroups: List.generate(timelines.timelines.length, (i) {
                            final timelineName = timelines.timelines[i];

                            final parts = ref
                                .watch(pieChartProvider((product: product, timeline: timelineName)))
                                .parts;

                            double runningTotal = 0;

                            const colors = [
                              Apptheme.piechart1,
                              Apptheme.piechart2,
                              Apptheme.piechart3,
                              Apptheme.piechart4,
                              Apptheme.piechart5,
                              Apptheme.piechart6,
                              Apptheme.piechart7,
                              Apptheme.piechart8,
                            ];

                            final stacks = <BarChartRodStackItem>[];

                            for (int p = 0; p < parts.length; p++) {
                              final partName = parts[p];
                              final result =
                                  ref.watch(savedEmissionsProvider((product:product.name,part: partName)));

                              final value = result.total;

                              stacks.add(
                                BarChartRodStackItem(
                                  runningTotal,
                                  runningTotal + value,
                                  colors[p % colors.length],
                                ),
                              );

                              runningTotal += value;
                            }

                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: runningTotal,
                                  rodStackItems: stacks,
                                  width: 18,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),

                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(5)),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                          children: List.generate(
                            timelines?.timelines.length ?? 0,
                            (index) {
                              final t = timelines!.timelines[index];
                              final start = timelineValues[t]?["start"] ?? "";
                              final end = timelineValues[t]?["end"] ?? "";

                              return ChoiceChip(
                                selectedColor: Apptheme.widgetsecondaryclr,
                                backgroundColor: Apptheme.widgettertiaryclr,
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                label: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Textsinsidewidgetsdrysafe(
                                      words: t,
                                      color: Apptheme.textclrdark,
                                    ),
                                    if (start.isNotEmpty || end.isNotEmpty)
                                      Textsinsidewidgetsdrysafe(
                                        words: "$start → $end",
                                        color: Apptheme.textclrdark,
                                        fontsize: 10,
                                      ),
                                  ],
                                ),
                                selected: activeTimeline == t,
                                onSelected: (_) {
                                  ref.read(activeTimelineProvider.notifier).state = t;
                                },
                              );
                            },
                          ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ---------------- PARTS / PIE CHART ----------------
            if (product != null && activeTimeline != null) ...[
              Row(
                children: [
                  const Labels(title: "Material emissions for all parts", color: Apptheme.textclrdark),
                  const Spacer(),
                  IconButton(onPressed: _addPart, icon: const Icon(Icons.add)),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 300,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    
                    Expanded(
                      flex: 2,
                      child: parts.isEmpty
                          ? Center(child: Text("No parts to display", style: TextStyle(color: Apptheme.textclrdark)))
                          : BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: results.isEmpty
                                    ? 1
                                    : results.map((r) => (r.materialNormal + r.material)).reduce((a, b) => a > b ? a : b) * 1.2,
                                titlesData: FlTitlesData(
                                                topTitles: AxisTitles(
                                                  sideTitles: SideTitles(showTitles: false),
                                                ),
                                                rightTitles: AxisTitles(
                                                  sideTitles: SideTitles(showTitles: false),
                                                ),
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    reservedSize: 40,
                                                  ),
                                                ),
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    getTitlesWidget: (value, meta) {
                                                      final idx = value.toInt();
                                                      if (idx < 0 || idx >= parts.length) {
                                                        return const SizedBox();
                                                      }
                                                      return Padding(
                                                        padding: const EdgeInsets.only(top: 4),
                                                        child: Text(
                                                          parts[idx],
                                                          style: const TextStyle(fontSize: 9),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                barGroups: List.generate(parts.length, (i) {
                                  final r = results[i];
                                  final materialTotal = r.materialNormal + r.material;
                                  return BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: materialTotal,
                                        width: 14,
                                        color: Apptheme.piechart2,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                    ),
                    // ---------------- Pie Chart ----------------
                    Expanded(
                      flex: 2,
                      child: RepaintBoundary(
                        key: pieKey,
                        child: PieChart(
                          PieChartData(
                            sections: List.generate(
                              parts.length,
                              (i) {
                                // Define a color palette
                                const colors = [
                                  Apptheme.piechart1,
                                  Apptheme.piechart2,
                                  Apptheme.piechart3,
                                  Apptheme.piechart4,
                                  Apptheme.piechart5,
                                  Apptheme.piechart6,
                                  Apptheme.piechart7,
                                  Apptheme.piechart8,
                                  Apptheme.piechart9,
                                  Apptheme.piechart10,
                                  Apptheme.piechart11,
                                  Apptheme.piechart12,
                                  Apptheme.piechart13,
                                  Apptheme.piechart14,
                                  Apptheme.piechart15,
                                  Apptheme.piechart16,
                                  Apptheme.piechart17,
                                ];
                                final color = colors[i % colors.length]; // cycle if more parts than colors
                        
                                return PieChartSectionData(
                                  value: (results[i]).total, // <--- use .total
                                  title: parts[i],
                                  color: color,
                                  radius: 120,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                        
                              },
                            ),
                            sectionsSpace: 2, // space between slices
                            centerSpaceRadius: 0, // no hole in the center
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // ---------------- Parts List ----------------
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Wrap(
                            children: List.generate(parts.length, (index) {
                              final part = parts[index];
                              final result = results[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Tooltip(
                                  message: "Double click to rename part",
                                  child: GestureDetector(
                                    onDoubleTap: () => _renamePart(part),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        // ---------------- ChoiceChip ----------------
                                        ChoiceChip(
                                          label: Text(part),
                                          selected: activePart == part,
                                          selectedColor: Apptheme.widgetsecondaryclr,
                                          backgroundColor: Apptheme.widgettertiaryclr,
                                          showCheckmark: false,
                                          onSelected: (_) => ref.read(activePartProvider.notifier).setPart(part),
                                        ),

                                        // ---------------- Delete Button ----------------
                                        Positioned(
                                          top: -6,
                                          right: -6,
                                          child: GestureDetector(
                                            onTap: () async {
                                              () async {
              final activeProduct = ref.read(activeProductProvider);
              final activePart = ref.read(activePartProvider);
              final username = await ref.read(usernameProvider.future);

              if (activeProduct == null ||
                  activePart == null ||
                  username == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Nothing to save!")),
                );
                return;
              }

              final key = (product: activeProduct.name, part: activePart);

              try {
                await saveProfile(
                  ref,
                  activeProduct.name,
                  username,
                  key,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Profile saved successfully!"),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error saving profile: $e")),
                );
              }
            };
                                              // Confirm deletion
                                              final confirmed = await showDialog<bool>(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text("Delete Part?"),
                                                  content: Text("Are you sure you want to delete '$part'?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
                                                      child: const Text("Cancel"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>  Navigator.of(context, rootNavigator: true).pop(true),
                                                      child: const Text("Delete"),
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirmed != true) return;

                                              final product = ref.read(activeProductProvider);
                                              final timeline = ref.read(activeTimelineProvider);
                                              if (product == null || timeline == null) return;

                                              // Clear active selection
                                              ref.read(activePartProvider.notifier).setPart(null);
                                              ref.read(pieChartProvider((product: product, timeline: timeline)).notifier).removePart(part);

                                              // TODO: Remove from pie chart & backend
                                              // await deletePartFromBackend(product.name, timeline, part);

                                              // Invalidate cached emissions
                                              ref.invalidate(savedEmissionsProvider((product: product.name, part: part)));
                                            },
                                            child: const CircleAvatar(
                                              radius: 8,
                                              backgroundColor: Colors.red,
                                              child: Icon(Icons.close, size: 12, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ),
                                ),
                              );
                            }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

          ],
        ),
      ),
    );
  }

}
