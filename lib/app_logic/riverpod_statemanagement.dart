// assembly_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assemblyProcessesProvider = Provider<List<String>>((ref) {
  return [
    'Welding',
    'Bolting',
    'Soldering',
    'Gluing',
    'Press Fit',
    'Riveting',
    'Injection Molding',
    'Laser Cutting',
  ];
});

final selectedAssemblyProcessProvider = StateProvider<String?>((ref) => null);
final assemblyTimeProvider = StateProvider<String>((ref) => '');
final assemblyNameProvider = StateProvider<String>((ref) => '');
final assemblySearchQueryProvider = StateProvider<String>((ref) => '');
final isDropdownVisibleProvider = StateProvider<bool>((ref) => false);
