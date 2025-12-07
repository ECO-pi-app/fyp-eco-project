import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ------------------- MATERIAL ACQUISITION -------------------
final materialSelectionsProvider = StateProvider<List<List<String?>>>((ref) {
  // Columns: Country, Material, Mass
  return [
    [''], // Country
    [''], // Material
    [''], // Mass
  ];
});

final materialTotalEmissionProvider = Provider<double>((ref) {
  final selections = ref.watch(materialSelectionsProvider);
  double total = 0;
  for (var row = 0; row < selections[2].length; row++) {
    total += double.tryParse(selections[2][row] ?? '0') ?? 0;
  }
  return total;
});

final savedMaterialTotalProvider = StateProvider<double>((ref) => 0.0);


// ------------------- TRANSPORT -------------------
final transportSelectionsProvider = StateProvider<List<List<String?>>>((ref) {
  return [
    [''], // Class
    [''], // Distance
  ];
});

final transportTotalEmissionProvider = Provider<double>((ref) {
  final selections = ref.watch(transportSelectionsProvider);
  double total = 0;
  for (var row = 0; row < selections[1].length; row++) {
    total += double.tryParse(selections[1][row] ?? '0') ?? 0;
  }
  return total;
});

// ------------------- MACHINING -------------------
final machiningSelectionsProvider = StateProvider<List<List<String?>>>((ref) {
  return [
    [''], // Machine
    [''], // Country
    [''], // Time of operation
  ];
});

final machiningTotalEmissionProvider = Provider<double>((ref) {
  final selections = ref.watch(machiningSelectionsProvider);
  double total = 0;
  for (var row = 0; row < selections[2].length; row++) {
    total += double.tryParse(selections[2][row] ?? '0') ?? 0;
  }
  return total;
});

// ------------------- FUGITIVE EMISSIONS -------------------
final fugitiveSelectionsProvider = StateProvider<List<List<String?>>>((ref) {
  return [
    [''], // GHG
    [''], // Total Charge
    [''], // Remaining Charge
  ];
});

final fugitiveTotalEmissionProvider = Provider<double>((ref) {
  final selections = ref.watch(fugitiveSelectionsProvider);
  double total = 0;
  for (var row = 0; row < selections[2].length; row++) {
    total += double.tryParse(selections[2][row] ?? '0') ?? 0;
  }
  return total;
});




// ------------------- DATA FETCHING  -------------------
class MetaOptions {
  final List<String> tester;

  MetaOptions({
    required this.tester,
  });

  factory MetaOptions.fromJson(Map<String, dynamic> json) {
    return MetaOptions(
      tester: List<String>.from(json['GHG'] ?? []),
    );
  }
}

final metaOptionsProvider = FutureProvider<MetaOptions>((ref) async {
  const url = 'http://127.0.0.1:8000/meta/options';
  final res = await http.get(Uri.parse(url));

  if (res.statusCode != 200) {
    throw Exception('Failed to load meta options');
  }

  final jsonMap = jsonDecode(res.body);
  return MetaOptions.fromJson(jsonMap);
});

// --- Providers ---

final testProvider = Provider<List<String>>((ref) {
  final test = ref.watch(metaOptionsProvider).value?.tester ?? [];
  debugPrint('testProvider returns: $test');
  return test;
});











