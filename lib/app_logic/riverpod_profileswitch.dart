import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/dynamic_pages/main_home.dart';
import 'package:test_app/app_logic/riverpod_calculation.dart';


final activeProductProvider = StateProvider<String?>((ref) => null);
final activeTimelineProvider = StateProvider<String?>((ref) => null);

/// Reset timeline when product changes
final productTimelineResetProvider = Provider<void>((ref) {
  ref.listen<String?>(
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

  void clear() => state = TimelineState();
}

final timelineProvider =
    StateNotifierProvider.family<TimelineNotifier, TimelineState, String>(
  (ref, product) => TimelineNotifier(),
);


class TimelineDurationNotifier
    extends StateNotifier<Map<String, Map<String, String>>> {
  TimelineDurationNotifier() : super({});

  void setDuration(String timelineName, String start, String end) {
    state = {...state, timelineName: {"start": start, "end": end}};
  }

  void clear() => state = {};
}

final timelineDurationProvider = StateNotifierProvider.family<
    TimelineDurationNotifier,
    Map<String, Map<String, String>>,
    String>(
  (ref, product) => TimelineDurationNotifier(),
);


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
    StateNotifierProvider.family<BarChartNotifier, BarChartState, String>(
  (ref, product) => BarChartNotifier(),
);


typedef PieKey = ({String product, String timeline});

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
  PieChartNotifier() : super(const PieChartState());

  void addPart(String part, double value) {
    state = state.copyWith(
      parts: [...state.parts, part],
      values: [...state.values, value],
    );
  }

  void clear() => state = const PieChartState();
}

final pieChartProvider =
    StateNotifierProvider.family<PieChartNotifier, PieChartState, PieKey>(
  (ref, key) => PieChartNotifier(),
);

final partsProvider = Provider<List<String>>((ref) {
  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  if (product == null || timeline == null) return [];

  final pieState =
      ref.watch(pieChartProvider((product: product, timeline: timeline)));
  return pieState.parts;
});


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




