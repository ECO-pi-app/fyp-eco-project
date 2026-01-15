import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:test_app/riverpod_profileswitch.dart';
import 'package:test_app/riverpod_states.dart';

final secureStorage = FlutterSecureStorage();

// -------------------  PAGE TRACKING  -------------------
final currentPageProvider = StateProvider<int>((ref) => 0);

// ------------------- UNIT CONVERSION -------------------

// Dropdown options you will show in UI
const Map<String, double> conversionFactors = {
  "Metric (kg CO₂)" : 1.0,     // default
  "Imperial (lb CO₂)" : 2.20462,
  "Grams (g CO₂)" : 1000.0,
  "Centimeters (cm)" : 100,
};
Map<double, String> unitLabels = {
  1.0: 'kg',
  2.20462: 'lb',
  1000.0: 'g',
  100.0 : 'cm'
};
Map<double, String> unitNames = {
  1.0: 'Metric',
  2.20462: 'Imperial',
  1000.0: 'Metric x10^-3',
  100 : 'Me'
};

// Stores the selected unit
final unitConversionProvider = StateProvider<double>((ref) => 1.0); // default 

final unitLabelProvider = Provider<String>((ref) {
  final factor = ref.watch(unitConversionProvider);
  return unitLabels[factor] ?? 'kg'; // default 
});

final unitNameProvider = Provider<String>((ref) {
  final factor = ref.watch(unitConversionProvider);
  return unitNames[factor] ?? 'Metric'; // default 
});

final myCheckboxProvider = StateProvider<bool>((ref) => false);


// ------------------- BUTTONS AND TRIGGERS -------------------
class TableState {
  final List<List<String?>> selections;
  TableState(this.selections);

  TableState copyWith({List<List<String?>>? selections}) {
    return TableState(selections ?? this.selections);
  }
}

class TableNotifier extends StateNotifier<TableState> {
  TableNotifier(int columns)
      : super(TableState(
            List.generate(columns, (_) => ['']) // 1 default row
          ));

  void updateCell(int col, int row, String? value) {
    final newSelections = [...state.selections];
    newSelections[col][row] = value;
    state = state.copyWith(selections: newSelections);
  }

  void addRow(int columns) {
    final newSelections = [...state.selections];
    for (int col = 0; col < columns; col++) {
      newSelections[col].add('');
    }
    state = state.copyWith(selections: newSelections);
  }

  void removeRow(int index) {
    final newSelections = [...state.selections];
    for (final col in newSelections) {
      if (index < col.length) col.removeAt(index);
    }
    state = state.copyWith(selections: newSelections);
  }
}


final tableControllerProvider =
    StateNotifierProvider.family<TableNotifier, TableState, int>(
        (ref, columns) => TableNotifier(columns));

