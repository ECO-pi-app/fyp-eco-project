import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
import 'package:test_app/app_logic/riverpod_states.dart';

// ------------------- DATA FETCHING  -------------------
class MetaOptions {
  final List<String> countries;
  final List<String> materials;
  final List<String> machines;
  final List<String> packagingTypes;
  final List<String> recyclingTypes;
  final List<String> transportTypes;
  final List<String> indicator;
  final List<String> ghg;
  final List<String> gwp;
  final List<String> process;
  final List<String> facilities;
  final List<String> usageTypes;
  final List<String> disassemblyByIndustry;
  final List<String> machineType;
  final List<String> ycmTypes;
  final List<String> amadaTypes;
  final List<String> mazakTypes;
  final List<String> vanMode;
  final List<String> hgvMode;
  final List<String> hgvRefrigeratedMode;
  final List<String> railMode;
  final List<String> freightFlightMode;
  final List<String> seaTankerMode;
  final List<String> cargoShipMode;
  final List<String> usageCycleCategories;
  final List<String> usageCycleElectronics;
  final List<String> usageCycleEnergy;
  final List<String> usageCycleConsumables;
  final List<String> usageCycleServices;
  final List<String> endOfLifeActivities;
  final List<String> assemblyProcesses;
  final List<String> wasteCategories;
  final List<String> municipalSolidWaste;
  final List<String> industrialWaste;
  final List<String> constructionWaste;
  final List<String> hazardousWaste;
  final List<String> organicWaste;
  final List<String> materialWaste;
  final List<String> energyWaste;

  MetaOptions({
    required this.countries,
    required this.materials,
    required this.machines,
    required this.packagingTypes,
    required this.recyclingTypes,
    required this.transportTypes,
    required this.indicator,
    required this.ghg,
    required this.gwp,
    required this.process,
    required this.facilities,
    required this.usageTypes,
    required this.disassemblyByIndustry,
    required this.machineType,
    required this.ycmTypes,
    required this.amadaTypes,
    required this.mazakTypes,
    required this.vanMode,
    required this.hgvMode,
    required this.hgvRefrigeratedMode,
    required this.railMode,
    required this.freightFlightMode,
    required this.seaTankerMode,
    required this.cargoShipMode,
    required this.usageCycleCategories,
    required this.usageCycleElectronics,
    required this.usageCycleEnergy,
    required this.usageCycleConsumables,
    required this.usageCycleServices,
    required this.endOfLifeActivities,
    required this.assemblyProcesses,
    required this.wasteCategories,
    required this.municipalSolidWaste,
    required this.industrialWaste,
    required this.constructionWaste,
    required this.hazardousWaste,
    required this.organicWaste,
    required this.materialWaste,
    required this.energyWaste,
  });

  factory MetaOptions.fromJson(Map<String, dynamic> json) {
    return MetaOptions(
      countries: List<String>.from(json['countries'] ?? []),
      materials: List<String>.from(json['materials'] ?? []),
      machines: List<String>.from(json['machines'] ?? []),
      packagingTypes: List<String>.from(json['packaging_types'] ?? []),
      recyclingTypes: List<String>.from(json['recycling_types'] ?? []),
      transportTypes: List<String>.from(json['transport_types'] ?? []),
      indicator: List<String>.from(json['indicator'] ?? []),
      ghg: List<String>.from(json['GHG'] ?? []),
      gwp: List<String>.from(json['GWP'] ?? []),
      process: List<String>.from(json['process'] ?? []),
      facilities: List<String>.from(json['facilities'] ?? []),
      usageTypes: List<String>.from(json['usage_types'] ?? []),
      disassemblyByIndustry: List<String>.from(json['disassembly_by_industry'] ?? []),
      machineType: List<String>.from(json['machine_type'] ?? []),
      ycmTypes: List<String>.from(json['YCM_types'] ?? []),
      amadaTypes: List<String>.from(json['Amada_types'] ?? []),
      mazakTypes: List<String>.from(json['Mazak_types'] ?? []),
      vanMode: List<String>.from(json['Van_mode'] ?? []),
      hgvMode: List<String>.from(json['HGV_mode'] ?? []),
      hgvRefrigeratedMode: List<String>.from(json['HGV_r_mode'] ?? []),
      railMode: List<String>.from(json['Rail_mode'] ?? []),
      freightFlightMode: List<String>.from(json['Freight_flight_modes'] ?? []),
      seaTankerMode: List<String>.from(json['Sea_Tanker_mode'] ?? []),
      cargoShipMode: List<String>.from(json['Cargo_ship_mode'] ?? []),
      usageCycleCategories: List<String>.from(json['Usage_categories'] ?? []),
      usageCycleElectronics: List<String>.from(json['Usage_electronics'] ?? []),
      usageCycleEnergy: List<String>.from(json['Usage_energy'] ?? []),
      usageCycleConsumables: List<String>.from(json['Usage_consumables'] ?? []),
      usageCycleServices: List<String>.from(json['Usage_services'] ?? []),
      endOfLifeActivities: List<String>.from(json['End_of_Life_Activities'] ?? [],),
      assemblyProcesses: List<String>.from(json['type_here'] ?? [],),
      wasteCategories: List<String>.from(json['Waste_type'] ?? [],),
      municipalSolidWaste: List<String>.from(json['MSW'] ?? [],),
      industrialWaste: List<String>.from(json['Industrial_and_Process_Waste'] ?? [],),
      constructionWaste: List<String>.from(json['Construction_and_Demolition_Waste'] ?? [],),
      hazardousWaste: List<String>.from(json['Hazardous_Waste'] ?? [],),
      organicWaste: List<String>.from(json['Organic_Waste'] ?? [],),
      materialWaste: List<String>.from(json['Material_specific_waste'] ?? [],),
      energyWaste: List<String>.from(json['Energy_Related_Waste'] ?? [],),
    );
  }
}


final metaOptionsProvider = FutureProvider<MetaOptions>((ref) async {
  const url = 'http://127.0.0.1:8000/meta/options';

  final res = await http.get(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
  );

  if (res.statusCode != 200) {
    throw Exception('Failed to load meta options: ${res.statusCode}');
  }

  final jsonMap = jsonDecode(res.body) as Map<String, dynamic>;
  return MetaOptions.fromJson(jsonMap);
});


// --- Individual data fetching ---
final countriesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.countries,
    loading: () => [],
    error: (_, __) => [],
  );
});

final materialsProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.materials,
    loading: () => [],
    error: (_, __) => [],
  );
});

final machinesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.machines,
    loading: () => [],
    error: (_, __) => [],
  );
});

final packagingTypesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.packagingTypes,
    loading: () => [],
    error: (_, __) => [],
  );
});

final recyclingTypesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.recyclingTypes,
    loading: () => [],
    error: (_, __) => [],
  );
});

final transportTypesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.transportTypes,
    loading: () => [],
    error: (_, __) => [],
  );
});

final indicatorProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.indicator,
    loading: () => [],
    error: (_, __) => [],
  );
});

final ghgProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.ghg,
    loading: () => [],
    error: (_, __) => [],
  );
});

final gwpProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.gwp,
    loading: () => [],
    error: (_, __) => [],
  );
});

final processProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.process,
    loading: () => [],
    error: (_, __) => [],
  );
});

final facilitiesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.facilities,
    loading: () => [],
    error: (_, __) => [],
  );
});

final usageTypesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.usageTypes,
    loading: () => [],
    error: (_, __) => [],
  );
});

final disassemblyByIndustryProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.disassemblyByIndustry,
    loading: () => [],
    error: (_, __) => [],
  );
});

final machineTypeProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.machineType,
    loading: () => [],
    error: (_, __) => [],
  );
});

final ycmTypesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.ycmTypes,
    loading: () => [],
    error: (_, __) => [],
  );
});

final amadaTypesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.amadaTypes,
    loading: () => [],
    error: (_, __) => [],
  );
});

final mazakTypesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.mazakTypes,
    loading: () => [],
    error: (_, __) => [],
  );
});

final vanModeProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.vanMode,
    loading: () => [],
    error: (_, __) => [],
  );
});

final hgvModeProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.hgvMode,
    loading: () => [],
    error: (_, __) => [],
  );
});

final hgvRefrigeratedModeProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.hgvRefrigeratedMode,
    loading: () => [],
    error: (_, __) => [],
  );
}); 

final railmodeProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.railMode,
    loading: () => [],
    error: (_, __) => [],
  );
});

final freightFlightModeProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.freightFlightMode,
    loading: () => [],
    error: (_, __) => [],
  );
});

final seaTankerModeProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.seaTankerMode,
    loading: () => [],
    error: (_, __) => [],
  );
});

final cargoShipModeProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.cargoShipMode,
    loading: () => [],
    error: (_, __) => [],
  );
});

final usageCycleCategoriesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.usageCycleCategories,
    loading: () => [],
    error: (_, __) => [],
  );
});

final usageCycleElectronicsProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.usageCycleElectronics,
    loading: () => [],
    error: (_, __) => [],
  );
});

final usageCycleEnergyProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.usageCycleEnergy,
    loading: () => [],
    error: (_, __) => [],
  );
});

final usageCycleConsumablesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.usageCycleConsumables,
    loading: () => [],
    error: (_, __) => [],
  );
});

final usageCycleServicesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.usageCycleServices,
    loading: () => [],
    error: (_, __) => [],
  );
});

final endOfLifeActivitiesProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.endOfLifeActivities,
    loading: () => [],
    error: (_, __) => [],
  );
});

final assemblyprocesses = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.assemblyProcesses,
    loading: () => [],
    error: (_, __) => [],
  );
});

final wasteCategoryProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.wasteCategories,
    loading: () => [],
    error: (_, __) => [],
  );
});

final municipalSolidWasteProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.municipalSolidWaste,
    loading: () => [],
    error: (_, __) => [],
  );
});

final industrialWasteProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.industrialWaste,
    loading: () => [],
    error: (_, __) => [],
  );
});

final constructionWasteProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.constructionWaste,
    loading: () => [],
    error: (_, __) => [],
  );
});

final hazardousWasteProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.hazardousWaste,
    loading: () => [],
    error: (_, __) => [],
  );
});

final organicWasteProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.organicWaste,
    loading: () => [],
    error: (_, __) => [],
  );
});

final materialWasteProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.materialWaste,
    loading: () => [],
    error: (_, __) => [],
  );
});

final energyWasteProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.energyWaste,
    loading: () => [],
    error: (_, __) => [],
  );
});



final usageCategoriesProvider = Provider.family<List<String>, String>((ref, category) {
  switch (category) {
    case 'Electronics': return ref.watch(usageCycleElectronicsProvider);
    case 'Energy' : return ref.watch(usageCycleEnergyProvider);
    case 'Consumables' : return ref.watch(usageCycleConsumablesProvider);
    case 'Services' : return ref.watch(usageCycleServicesProvider);
    default:
      return [];
  }
});

final classOptionsProvider = Provider.family<List<String>, String>((ref, vehicle) {
  switch (vehicle) {
    case 'Van': return ref.watch(vanModeProvider);
    case 'HGV (Diesel)': return ref.watch(hgvModeProvider);
    case 'HGV Refrigerated (Diesel)': return ref.watch(hgvRefrigeratedModeProvider);
    case 'Rail': return ref.watch(railmodeProvider);
    case 'Freight Flights': return ref.watch(freightFlightModeProvider);
    case 'Sea Tanker': return ref.watch(seaTankerModeProvider);
    case 'Cargo Ship': return ref.watch(cargoShipModeProvider);
    default:
      return [];
  }
});

final brandOptionsProvider = Provider.family<List<String>, String>((ref, vehicle) {
  switch (vehicle) {
    case 'Van':
      return ref.watch(vanModeProvider);
    case 'HGV (Diesel)':
      return ref.watch(hgvModeProvider);
    default:
      return [];
  }
});

final wasteTypeProvider = Provider.family<List<String>, String>((ref, wasteType) {
  switch (wasteType) {
    case 'Municipal Solid Waste (MSW)': return ref.watch(municipalSolidWasteProvider);
    case 'Industrial&Process Waste': return ref.watch(industrialWasteProvider);
    case 'Construction&Demolition Waste': return ref.watch(constructionWasteProvider);
    case 'Hazardous Waste': return ref.watch(hazardousWasteProvider);
    case 'Organic  Waste': return ref.watch(organicWasteProvider);
    case 'Material-specific waste': return ref.watch(materialWasteProvider);
    case 'Energy-Related Waste': return ref.watch(energyWasteProvider);
    default:
      return [];
  }
});

