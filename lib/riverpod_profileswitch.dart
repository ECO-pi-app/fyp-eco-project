import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

/// ===============================================================
/// 1️⃣ ACTIVE SELECTION CONTEXT
/// ===============================================================

/// Currently selected product (set from Home / Inkwell)
final activeProductProvider = StateProvider<String?>((ref) => null);

/// Currently selected timeline (inside a product)
final activeTimelineProvider = StateProvider<String?>((ref) => null);


/// ===============================================================
/// 2️⃣ RESET TIMELINE WHEN PRODUCT CHANGES
/// ===============================================================
/// Call: ref.watch(productTimelineResetProvider); ONCE inside Home

final productTimelineResetProvider = Provider<void>((ref) {
  ref.listen<String?>(
    activeProductProvider,
    (_, __) {
      ref.read(activeTimelineProvider.notifier).state = null;
    },
  );
});


/// ===============================================================
/// 3️⃣ TIMELINE STATE (PER PRODUCT)
/// ===============================================================

class TimelineState {
  final List<String> timelines;

  const TimelineState({this.timelines = const []});

  TimelineState copyWith({List<String>? timelines}) {
    return TimelineState(
      timelines: timelines ?? this.timelines,
    );
  }
}

class TimelineNotifier extends StateNotifier<TimelineState> {
  TimelineNotifier() : super(const TimelineState());

  void addTimeline(String timeline) {
    if (state.timelines.contains(timeline)) return;
    state = state.copyWith(timelines: [...state.timelines, timeline]);
  }

  void clear() {
    state = const TimelineState();
  }
}

/// 🔑 Keyed by product
final timelineProvider =
    StateNotifierProvider.family<TimelineNotifier, TimelineState, String>(
  (ref, product) => TimelineNotifier(),
);


/// ===============================================================
/// 4️⃣ LINE CHART STATE (PER PRODUCT)
/// ===============================================================

class LineChartState {
  final List<String> dates;
  final List<double> values;

  const LineChartState({
    this.dates = const [],
    this.values = const [],
  });

  LineChartState copyWith({
    List<String>? dates,
    List<double>? values,
  }) {
    return LineChartState(
      dates: dates ?? this.dates,
      values: values ?? this.values,
    );
  }
}

class LineChartNotifier extends StateNotifier<LineChartState> {
  LineChartNotifier() : super(const LineChartState());

  void addDate(String date, double value) {
    state = state.copyWith(
      dates: [...state.dates, date],
      values: [...state.values, value],
    );
  }

  void clear() {
    state = const LineChartState();
  }
}

/// 🔑 Keyed by product
final lineChartProvider =
    StateNotifierProvider.family<LineChartNotifier, LineChartState, String>(
  (ref, product) => LineChartNotifier(),
);


/// ===============================================================
/// 5️⃣ PARTS / PIE CHART STATE (PER PRODUCT + TIMELINE)
/// ===============================================================

class PieChartState {
  final List<String> parts;
  final List<double> values;

  const PieChartState({
    this.parts = const [],
    this.values = const [],
  });

  PieChartState copyWith({
    List<String>? parts,
    List<double>? values,
  }) {
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

  void clear() {
    state = const PieChartState();
  }
}

/// Composite key: Product + Timeline
typedef PieKey = ({String product, String timeline});

final pieChartProvider =
    StateNotifierProvider.family<PieChartNotifier, PieChartState, PieKey>(
  (ref, key) => PieChartNotifier(),
);

final partsProvider = Provider<List<String>>((ref) {
  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);

  if (product == null || timeline == null) {
    return [];
  }

  final pieState = ref.watch(
    pieChartProvider((product: product, timeline: timeline)),
  );

  return pieState.parts;
});


/// ===============================================================
/// 6️⃣ DEBUG PROVIDER (OPTIONAL BUT RECOMMENDED)
/// ===============================================================

final debugSelectionProvider = Provider<String>((ref) {
  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);

  return 'ACTIVE → product: $product | timeline: $timeline';
});


class CompoundPart {
  final String name;
  final List<String> components; // names of basic parts
  CompoundPart({required this.name, required this.components});
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



final activePartProvider = StateProvider<String?>((ref) => null);
