import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/app_logic/riverpod_account.dart';
import 'package:test_app/dynamic_pages/main_home.dart';
import 'package:test_app/app_logic/riverpod_calculation.dart';


final activeProductProvider = StateProvider<Product?>((ref) => null);
final activeTimelineProvider = StateProvider<String?>((ref) => null);

/// Reset timeline when product changes
final productTimelineResetProvider = Provider<void>((ref) {
  ref.listen<Product?>(
    activeProductProvider,
    (_, __) => ref.read(activeTimelineProvider.notifier).state = null,
  );
});

class TimelineState {
  final List<String> timelines; // only names
  TimelineState({this.timelines = const []});
  TimelineState copyWith({List<String>? timelines}) =>
      TimelineState(timelines: timelines ?? this.timelines);
}

class TimelineNotifier extends StateNotifier<TimelineState> {
  TimelineNotifier() : super(TimelineState());

  void addTimeline(String timeline) {
    if (!state.timelines.contains(timeline)) {
      state = state.copyWith(timelines: [...state.timelines, timeline]);
    }
  }

  
  void renameTimeline(String oldName, String newName) {
    if (oldName == newName) return;

    final updated = [
      for (final t in state.timelines)
        if (t == oldName) newName else t
    ];

    state = state.copyWith(timelines: updated);
  }

  void clear() => state = TimelineState();
}

class TimelineDurationNotifier
    extends StateNotifier<Map<String, Map<String, String>>> {
  TimelineDurationNotifier() : super({});

  void setDuration(String timelineName, String start, String end) {
    state = {...state, timelineName: {"start": start, "end": end}};
  }

  void renameTimeline(String oldName, String newName) {
  if (!state.containsKey(oldName)) return;

  final updated = {...state};
  updated[newName] = updated.remove(oldName)!;

  state = updated;
}

  void clear() => state = {};
}

final timelineProvider =
    StateNotifierProvider.family<TimelineNotifier, TimelineState, String>(
  (ref, product) => TimelineNotifier(),
);

final timelineDurationProvider = StateNotifierProvider.family<
    TimelineDurationNotifier,
    Map<String, Map<String, String>>,
    String>(
  (ref, product) => TimelineDurationNotifier(),
);

void hydrateTimelines(WidgetRef ref, Product product) {
  final timelineNames = (product.data["timelines"] as Map<String, dynamic>?)?.keys.toList() ?? [];
  final timelineNotifier = ref.read(timelineProvider(product.name).notifier);
  final timelineDurationNotifier = ref.read(timelineDurationProvider(product.name).notifier);

  timelineNotifier.clear();
  for (var t in timelineNames) {
    timelineNotifier.addTimeline(t);
  }

  timelineDurationNotifier.clear();
  for (var t in timelineNames) {
    final timelineData = product.data["timelines"][t] as Map<String, dynamic>? ?? {};
    final start = timelineData["start_month"] ?? "";
    final end = timelineData["end_month"] ?? "";
    timelineDurationNotifier.setDuration(t, start, end);
  }
}



// ------------------- BAR CHART PROVIDER -------------------
class BarChartState {
  final List<String> timelineNames;
  final List<double> values;

  BarChartState({this.timelineNames = const [], this.values = const []});

  BarChartState copyWith({List<String>? timelineNames, List<double>? values}) {
    return BarChartState(
      timelineNames: timelineNames ?? this.timelineNames,
      values: values ?? this.values,
    );
  }
}

class BarChartNotifier extends StateNotifier<BarChartState> {
  BarChartNotifier() : super(BarChartState());

  void addTimelineValue(String name, double value) {
    state = state.copyWith(
      timelineNames: [...state.timelineNames, name],
      values: [...state.values, value],
    );
  }

  void clear() => state = BarChartState();
}

final barChartProvider =
    StateNotifierProvider.family<BarChartNotifier, BarChartState, Product>(
  (ref, product) => BarChartNotifier(),
);


typedef PieKey = ({Product product, String timeline});

class PieChartState {
  final List<String> parts;
  final List<double> values;

  const PieChartState({this.parts = const [], this.values = const []});

  PieChartState copyWith({List<String>? parts, List<double>? values}) {
    return PieChartState(
      parts: parts ?? this.parts,
      values: values ?? this.values,
    );
  }
}

class PieChartNotifier extends StateNotifier<PieChartState> {
  final StateNotifierProviderRef<PieChartNotifier, PieChartState> ref;
  final Product product;
  final String timeline;

  PieChartNotifier(this.ref, this.product, this.timeline)
      : super(const PieChartState());

  void addPart(String part, double value) {
    state = state.copyWith(
      parts: [...state.parts, part],
      values: [...state.values, value],
    );
  }

  /// Rename a part and migrate all associated data
  void renamePart(String oldName, String newName) {
    if (oldName == newName) return;

    // Update parts list
    final updatedParts = [
      for (final p in state.parts) if (p == oldName) newName else p
    ];
    state = state.copyWith(parts: updatedParts);

    // Migrate data in all emission/material/transport tables
    _migrateTable(oldName, newName, normalMaterialTableProvider, (part) => (product: product.name, part: part),);
    _migrateTable(oldName, newName, materialTableProvider, (part) => (product: product.name, part: part),);
    _migrateTable(oldName, newName, upstreamTransportTableProvider, (part) => (product: product.name, part: part),);
    _migrateTable(oldName, newName, machiningTableProvider, (part) => (product: product.name, part: part),);
    _migrateTable(oldName, newName, fugitiveLeaksTableProvider, (part) => (product: product.name, part: part),);
    _migrateTable(oldName, newName, productionTransportTableProvider, (part) => (product: product.name, part: part),);
    _migrateTable(oldName, newName, downstreamTransportTableProvider, (part) => (product: product.name, part: part),);
    _migrateTable(oldName, newName, wastesTableProvider, (part) => (product: product.name, part: part),);
    _migrateTable(oldName, newName, usageCycleTableProvider, (part) => (product: product.name, part: part),);
    _migrateTable(oldName, newName, endOfLifeTableProvider, (part) => (product: product.name, part: part),);
  }

void removePart(String partName) {
  // Remove part from parts list
  final updatedParts = List<String>.from(state.parts)..remove(partName);

  // Remove corresponding value
  final index = state.parts.indexOf(partName);
  final updatedValues = List<double>.from(state.values);
  if (index >= 0 && index < updatedValues.length) {
    updatedValues.removeAt(index);
  }

  // Update state
  state = state.copyWith(parts: updatedParts, values: updatedValues);
}

  void _migrateTable<S, N extends StateNotifier<S>, K>(
    String oldName,
    String newName,
    StateNotifierProviderFamily<N, S, K> provider,
    K Function(String partName) keyBuilder,
  ) {
    final oldKey = keyBuilder(oldName);
    final newKey = keyBuilder(newName);

    final oldState = ref.read(provider(oldKey));
    if (oldState == null) return;

    ref.read(provider(newKey).notifier).state = oldState;
  }

    void clear() => state = const PieChartState();
  }

final pieChartProvider =
    StateNotifierProvider.family<PieChartNotifier, PieChartState, PieKey>(
  (ref, key) => PieChartNotifier(ref, key.product, key.timeline),
);

final partsProvider = Provider<List<String>>((ref) {
  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  if (product == null || timeline == null) return [];

  final pieState =
      ref.watch(pieChartProvider((product: product, timeline: timeline)));
  return pieState.parts;
});

void hydrateParts(WidgetRef ref, Product product, String timeline) {
  final timelineData =
      product.data["timelines"]?[timeline] as Map<String, dynamic>?;

  if (timelineData == null) return;

  final partsMap = timelineData["parts"] as Map<String, dynamic>?;

  if (partsMap == null) return;

  final pieNotifier =
      ref.read(pieChartProvider((product: product, timeline: timeline)).notifier);

  pieNotifier.clear();

  for (var partName in partsMap.keys) {
    pieNotifier.addPart(partName, 0); // default value 0
  }
}




//------------------- RESULTS PROVIDER -------------------
final emissionResultsProvider = Provider.family<EmissionResults, PieKey>(
  (ref, key) {
    return EmissionResults(
      material: 5,
      transport: 3,
      machining: 2,
      fugitive: 1,
      productionTransport: 1,
      waste: 0,
      usageCycle: 0,
      endofLife: 0,
    );
  },
);

final pieValuesProvider = Provider.family<List<double>, PieKey>((ref, key) {
  final emission = ref.watch(emissionResultsProvider(key));
  return [
    emission.material,
    emission.transport,
    emission.machining,
    emission.fugitive,
    emission.productionTransport,
    emission.waste,
    emission.usageCycle,
    emission.endofLife,
  ];
});

final activePartProvider = StateNotifierProvider<ActivePartNotifier, String?>(
  (ref) {
    final notifier = ActivePartNotifier(ref);
    return notifier;
  },
);


final debugSelectionProvider = Provider<String>((ref) {
  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  return 'ACTIVE → product: $product | timeline: $timeline';
});



class CompoundPart {
  final String name;
  final List<String> components;
  final String? assemblyProcess; // NEW
  final String? timeTaken;       // optional, but you already collect it

  CompoundPart({
    required this.name,
    required this.components,
    this.assemblyProcess,
    this.timeTaken,
  });
}


class CompoundPartsState {
  final List<CompoundPart> compounds;
  CompoundPartsState({this.compounds = const []});

  CompoundPartsState copyWith({List<CompoundPart>? compounds}) {
    return CompoundPartsState(compounds: compounds ?? this.compounds);
  }
}

class CompoundPartsNotifier extends StateNotifier<CompoundPartsState> {
  CompoundPartsNotifier() : super(CompoundPartsState());

  void addCompound(String name, List<String> components) {
    state = state.copyWith(
      compounds: [...state.compounds, CompoundPart(name: name, components: components)],
    );
  }

  void clear() {
    state = CompoundPartsState();
  }
}

// Keyed by product + timeline
typedef CompoundKey = ({String product, String timeline});

final compoundPartsProvider = StateNotifierProvider.family<
    CompoundPartsNotifier, CompoundPartsState, CompoundKey>(
  (ref, key) => CompoundPartsNotifier(),
);


class HigherCompoundPart {
  final String name;
  final List<String> components; // names of compound parts
  HigherCompoundPart({required this.name, required this.components});
}

class HigherCompoundPartsState {
  final List<HigherCompoundPart> compounds;
  HigherCompoundPartsState({this.compounds = const []});

  HigherCompoundPartsState copyWith({List<HigherCompoundPart>? compounds}) {
    return HigherCompoundPartsState(compounds: compounds ?? this.compounds);
  }
}

class HigherCompoundPartsNotifier extends StateNotifier<HigherCompoundPartsState> {
  HigherCompoundPartsNotifier() : super(HigherCompoundPartsState());

  void addHigherCompound(String name, List<String> components) {
    state = state.copyWith(
      compounds: [...state.compounds, HigherCompoundPart(name: name, components: components)],
    );
  }

  void clear() {
    state = HigherCompoundPartsState();
  }
}

final higherCompoundPartsProvider = StateNotifierProvider.family<
    HigherCompoundPartsNotifier, HigherCompoundPartsState, CompoundKey>(
  (ref, key) => HigherCompoundPartsNotifier(),
);




