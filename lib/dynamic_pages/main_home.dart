import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/app_logic/riverpod_calculation.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.productName != null) {
        ref.read(activeProductProvider.notifier).state = widget.productName;
        print('InitState: Active product set to ${widget.productName}');
      }
    });
  }

  /// ---------- TIMELINE DIALOG ----------
  Future<Map<String, String>?> _showTimelineDialog() async {
    final nameController = TextEditingController();
    final startController = TextEditingController();
    final endController = TextEditingController();

    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];

    String? selectedStartMonth;
    String? selectedEndMonth;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (_, setState) {
        return AlertDialog(
          title: const Text("Add Timeline"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Timeline Name"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: startController,
                  decoration: const InputDecoration(labelText: "Start Month"),
                  onChanged: (val) => setState(() {
                    selectedStartMonth = months.firstWhere(
                      (m) => m.toLowerCase().startsWith(val.toLowerCase()),
                      orElse: () => val,
                    );
                  }),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: endController,
                  decoration: const InputDecoration(labelText: "End Month"),
                  onChanged: (val) => setState(() {
                    selectedEndMonth = months.firstWhere(
                      (m) => m.toLowerCase().startsWith(val.toLowerCase()),
                      orElse: () => val,
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Add")),
          ],
        );
      }),
    );

    if (nameController.text.isEmpty) return null;
    return {
      "name": nameController.text,
      "start": selectedStartMonth ?? startController.text,
      "end": selectedEndMonth ?? endController.text,
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

    ref.read(timelineProvider(product).notifier).addTimeline(timelineName);
    ref.read(activeTimelineProvider.notifier).state = timelineName;
    ref.read(timelineDurationProvider(product).notifier).state = {
      ...ref.read(timelineDurationProvider(product).notifier).state,
      timelineName: {"start": start, "end": end},
    };
  }

  /// ---------- ADD PART ----------
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

    final emissionResult = ref.watch(convertedEmissionsTotalProvider((product, partName)));
    final totalValue = emissionResult.total;

    ref.read(pieChartProvider((product: product, timeline: timeline)).notifier)
        .addPart(partName, totalValue);
    ref.read(activePartProvider.notifier).setPart(partName);

  }

  @override
  Widget build(BuildContext context) {
    ref.watch(productTimelineResetProvider);

    final product = ref.watch(activeProductProvider);
    final activeTimeline = ref.watch(activeTimelineProvider);
    final activePart = ref.watch(activePartProvider);
    final timelines = product != null ? ref.watch(timelineProvider(product)) : null;
    final timelineValues = product != null ? ref.watch(timelineDurationProvider(product)) : {};

    final parts = (product != null && activeTimeline != null)
        ? ref.watch(pieChartProvider((product: product, timeline: activeTimeline))).parts
        : [];

    final results = List.generate(parts.length, (i) {
      final partName = parts[i];
      return product != null
          ? ref.watch(convertedEmissionsTotalProvider((product, partName)))
          : null;
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
                const Labels(title: "Timelines", color: Apptheme.textclrdark),
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
          .watch(pieChartProvider((product: product!, timeline: timelineName)))
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
            ref.watch(convertedEmissionsTotalProvider((product!, partName)));

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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5)),
                              label: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Textsinsidewidgetsdrysafe(
                                    words: t, 
                                    color: Apptheme.textclrdark,
                                    toppadding: 0,
                                  ),
                                  if (start.isNotEmpty || end.isNotEmpty) 
                                  Textsinsidewidgetsdrysafe(
                                    words: "$start → $end", 
                                    color: Apptheme.textclrdark, 
                                    fontsize: 10,
                                    toppadding: 1,
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
                  const Labels(title: "Parts Assembly", color: Apptheme.textclrdark),
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
                : results.map((r) => (r!.materialNormal + r.material)).reduce((a, b) => a > b ? a : b) * 1.2,
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
              final r = results[i]!;
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
                                value: (results[i] as EmissionResults).total, // <--- use .total
                                title: parts[i] as String,
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

                    const SizedBox(width: 16),

                    // ---------------- Parts List ----------------
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(parts.length, (index) {
                            final part = parts[index];
                            final result = results[index] as EmissionResults; // <-- use index
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ChoiceChip(
                                selectedColor: Apptheme.widgetsecondaryclr,
                                backgroundColor: Apptheme.widgettertiaryclr,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                showCheckmark: false,
                                label: Textsinsidewidgetsdrysafe(
                                  words: "$part = ${result.total.toStringAsFixed(2)}",
                                  color: Apptheme.textclrdark,
                                  toppadding: 0,
                                ),
                                selected: activePart == part,
                                onSelected: (_) {
                                  ref.read(activePartProvider.notifier).setPart(part);
                                },
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
