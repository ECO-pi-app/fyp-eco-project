import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:test_app/riverpod_profileswitch.dart';



final secureStorage = FlutterSecureStorage();

// -------------------  PAGE TRACKING  -------------------
final currentPageProvider = StateProvider<int>((ref) => 0);

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
  final List<String> waste;

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
    required this.waste,
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
      waste: List<String>.from(json['Waste_mode'] ?? [],),
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

final wasteMaterialProvider = Provider<List<String>>((ref) {
  final asyncMeta = ref.watch(metaOptionsProvider);
  return asyncMeta.when(
    data: (meta) => meta.waste,
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


/// ------------------- CALCULATION INPUT -------------------
class RowFormat {
  final List<String> columnTitles;
  final List<bool> isTextFieldColumn;
  final List<String?> selections;

  RowFormat({
    required this.columnTitles,
    required this.isTextFieldColumn,
    required this.selections,
  });
}

/// ---------------- EMISSION RESULTS ----------------
class EmissionResults {
  final double materialNormal;
  final double material;
  final double transport;
  final double machining;
  final double fugitive;
  final double productionTransport;
  final double waste;
  final double usageCycle;
  final double endofLife;

  const EmissionResults({
    this.materialNormal = 0,
    this.material = 0,
    this.transport = 0,
    this.machining = 0,
    this.fugitive = 0,
    this.productionTransport = 0,
    this.waste = 0,
    this.usageCycle = 0,
    this.endofLife = 0,
  });

  factory EmissionResults.empty() => const EmissionResults();

  EmissionResults copyWith({
    double? materialNormal,
    double? material,
    double? transport,
    double? machining,
    double? fugitive,
    double? productionTransport,
    double? waste,
    double? usageCycle,
    double? endofLife,
  }) =>
      EmissionResults(
        materialNormal: materialNormal ?? this.materialNormal,
        material: material ?? this.material,
        transport: transport ?? this.transport,
        machining: machining ?? this.machining,
        fugitive: fugitive ?? this.fugitive,
        productionTransport: productionTransport ?? this.productionTransport,
        waste: waste ?? this.waste,
        usageCycle: usageCycle ?? this.usageCycle,
        endofLife: endofLife ?? this.endofLife,
      );

  EmissionResults operator +(EmissionResults other) {
    return EmissionResults(
      materialNormal: (materialNormal) + (other.materialNormal),
      material: (material) + (other.material),
      transport: (transport) + (other.transport),
      machining: (machining) + (other.machining),
      fugitive: (fugitive) + (other.fugitive),
      productionTransport: (productionTransport) + (other.productionTransport),
      waste: (waste) + (other.waste),
      usageCycle: (usageCycle) + (other.usageCycle),
      endofLife: (endofLife) + (other.endofLife),
    );
  }


  double get total =>
      (materialNormal ?? 0) +
      (material ?? 0) +
      (transport ?? 0) +
      (machining ?? 0) +
      (fugitive ?? 0) +
      (productionTransport ?? 0) +
      (waste ?? 0) +
      (usageCycle ?? 0) +
      (endofLife ?? 0);
}


/// ---------------- CALCULATOR STATE ----------------
class EmissionCalculatorState {
  final Map<String, List<EmissionResults>> rowsByPart;
  final Map<String, EmissionResults> totalsByPart;

  const EmissionCalculatorState({
    this.rowsByPart = const {},
    this.totalsByPart = const {},
  });

  EmissionCalculatorState copyWith({
    Map<String, List<EmissionResults>>? rowsByPart,
    Map<String, EmissionResults>? totalsByPart,
  }) {
    return EmissionCalculatorState(
      rowsByPart: rowsByPart ?? this.rowsByPart,
      totalsByPart: totalsByPart ?? this.totalsByPart,
    );
  }
}

/// ---------------- PROVIDERS ----------------
final emissionCalculatorProvider =
    StateNotifierProvider.family<
        EmissionCalculator,
        EmissionCalculatorState,
        String>(
  (ref, productId) => EmissionCalculator(),
);

final emissionRowsProvider =
    Provider.family<List<EmissionResults>, (String, String)>(
  (ref, args) {
    final (productId, partId) = args;
    return ref
            .watch(emissionCalculatorProvider(productId))
            .rowsByPart[partId] ??
        [];
  },
);

final emissionTotalsProvider =
    Provider.family<EmissionResults, (String, String)>(
  (ref, args) {
    final (productId, partId) = args;
    return ref
            .watch(emissionCalculatorProvider(productId))
            .totalsByPart[partId] ??
        EmissionResults.empty();
  },
);

/// ---------------- CONVERTED EMISSIONS PER PART ----------------
/// NOTE: assumes your existing allocation + unit providers already exist
final convertedEmissionsPerPartProvider =
    Provider.family<EmissionResults, (String, String)>(
  (ref, args) {
    final (productId, partId) = args;

    final rows =
        ref.watch(emissionRowsProvider((productId, partId)));
    final factor = ref.watch(unitConversionProvider);
    final key = (product: productId, part: partId);

    if (rows.isEmpty) return EmissionResults.empty();

    List<String> safe(List<String?>? list) =>
        list?.map((e) => e ?? '0').toList() ?? [];

    final allocations = {
      'material_normal': safe(ref
          .watch(normalMaterialTableProvider(key))
          .materialAllocationValues),
      'material': safe(ref
          .watch(materialTableProvider(key))
          .materialAllocationValues),
      'transport': safe(ref
          .watch(upstreamTransportTableProvider(key))
          .transportAllocationValues),
      'machining': safe(ref
          .watch(machiningTableProvider(key))
          .machiningAllocationValues),
      'fugitive': safe(ref
          .watch(fugitiveLeaksTableProvider(key))
          .fugitiveAllocationValues),
      'productionTransport': safe(ref
          .watch(productionTransportTableProvider(key))
          .transportAllocationValues),
      'waste': safe(
          ref.watch(wastesProvider(key)).wasteAllocationValues),
      'usageCycle': safe(ref
          .watch(usageCycleTableProvider(key))
          .usageCycleAllocationValues),
      'endofLife': safe(ref
          .watch(endOfLifeTableProvider(key))
          .endOfLifeAllocationValues),
    };

    double alloc(String cat, int i) {
      final list = allocations[cat]!;
      if (i >= list.length) return 0;
      return (double.tryParse(list[i]) ?? 0) / 100;
    }

    EmissionResults total = EmissionResults.empty();

    for (int i = 0; i < rows.length; i++) {
      final r = rows[i];
      total += EmissionResults(
        material: r.material * alloc('material', i) * factor,
        transport: r.transport * alloc('transport', i) * factor,
        machining: r.machining * alloc('machining', i) * factor,
        fugitive: r.fugitive * alloc('fugitive', i) * factor,
        productionTransport:
            r.productionTransport *
                alloc('productionTransport', i) *
                factor,
        waste: r.waste * alloc('waste', i) * factor,
        usageCycle:
            r.usageCycle * alloc('usageCycle', i) * factor,
        endofLife:
            r.endofLife * alloc('endofLife', i) * factor,
      );
    }

    return total;
  },
);

final partTotalAllocatedEmissionsProvider =
    Provider.family<double, (String, String)>(
  (ref, args) =>
      ref.watch(convertedEmissionsPerPartProvider(args)).total,
);

/// ---------------- EMISSION CALCULATOR ----------------
class EmissionCalculator
    extends StateNotifier<EmissionCalculatorState> {
  EmissionCalculator() : super(const EmissionCalculatorState());

  final Map<String, Map<String, dynamic>> _config = {
    'material': {
      'endpoint':
          'http://127.0.0.1:8000/calculate/material',
      'apiKeys': {
        "Country": "country",
        "Material": "material",
        "Mass (kg)": "total_material_purchased_kg",
      }
    },
    'material_custom': {
      'endpoint':
          'http://127.0.0.1:8000/calculate/material_emission_recycled',
      'apiKeys': {
        "Country": "country",
        "Material": "material",
        "Mass (kg)": "total_material_purchased_kg",
        "Custom Emission Factor": "custom_ef_of_material",
        "Internal Emission Factor": "custom_internal_ef",
      }
    },
    'upstream_transport': {
      'endpoint': 'http://127.0.0.1:8000/calculate/van',
      'apiKeys': {
        "Vehicle": "vehicle_type",
        "Class": "transport_type",
        "Distance (km)": "distance_km",
        "Mass (kg)": "mass_kg",
      }
    },
    'machining': {
      'endpoint':
          'http://127.0.0.1:8000/calculate/machine_power_emission',
      'apiKeys': {
        "Machine": "machine_model",
        "Country": "country",
        "Time of operation (hr)": "time_operated_hr",
      }
    },
    'fugitive': {
      'endpoint':
          'http://127.0.0.1:8000/calculate/fugitive_emissions',
      'apiKeys': {
        "GHG": "ghg_name",
        "Total Charge (kg)": "total_charged_amount_kg",
        "Remaining Charge (kg)": "current_charge_amount_kg",
      }
    },
    'production_transport': {
      'endpoint': 'http://127.0.0.1:8000/calculate/van',
      'apiKeys': {
        "Vehicle": "vehicle_type",
        "Class": "transport_type",
        "Distance (km)": "distance_km",
        "Mass (kg)": "mass_kg",
      }
    },
    'waste': {
      'endpoint': 'http://127.0.0.1:8000/calculate/waste',
      'apiKeys': {
        "Waste Material": "waste_mode",
        "Mass (kg)": "mass_kg",
      }
    },
    'usage_cycle': {
      'endpoint': 'http://127.0.0.1:8000/calculate/usage_cycle',
      'apiKeys': {
        "Category": "category",
        "Product" : "product",
        "Usage Frequency": "mass_kg",
      }
    },
    'end_of_life': {
      'endpoint': 'http://127.0.0.1:8000/calculate/end_of_life',
      'apiKeys': {
        "End of Life Option": "waste_mode",
        "Total Mass": "mass_kg",
      }
    },
  };

  final Map<String, String> _transportEndpoints = {
    'Van': 'http://127.0.0.1:8000/calculate/van',
    'HGV (Diesel)': 'http://127.0.0.1:8000/calculate/hgv',
    'HGV Refrigerated (Diesel)':
        'http://127.0.0.1:8000/calculate/hgv_r',
    'Freight Flights':
        'http://127.0.0.1:8000/calculate/freight_flight',
    'Rail': 'http://127.0.0.1:8000/calculate/rail_sheet',
    'Sea Tanker':
        'http://127.0.0.1:8000/calculate/sea_tanker',
    'Cargo Ship':
        'http://127.0.0.1:8000/calculate/cargo_ship',
  };

Future<void> calculate(
  String partId,
  String featureType,
  List<RowFormat> rows,
) async {
  final config = _config[featureType];
  if (config == null) return;

  final endpointDefault = config['endpoint'] as String;
  final apiKeys = config['apiKeys'] as Map<String, String>;

  // Type-safe initialization
  final List<EmissionResults> resultRows =
      (state.rowsByPart[partId] ?? <EmissionResults>[]).cast<EmissionResults>();

  for (int i = 0; i < rows.length; i++) {
    final row = rows[i];
    final payload = <String, dynamic>{};

    for (int col = 0; col < row.columnTitles.length; col++) {
      final apiKey = apiKeys[row.columnTitles[col]];
      if (apiKey == null) continue;

      payload[apiKey] = row.isTextFieldColumn[col]
          ? double.tryParse(row.selections[col] ?? '0') ?? 0
          : row.selections[col] ?? '';
    }

    String endpoint = endpointDefault;
    if (featureType.contains('transport')) {
      endpoint = _transportEndpoints[row.selections.first] ?? endpointDefault;
    }

    double value = 0;
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        value = (json["total_material_emissions"] ??
                json["total_transport_type_emission"] ??
                json["emissions_kgco2e"] ??
                json["emissions"] ??
                0)
            .toDouble();
      }
    } catch (_) {
      value = 0;
    }

    // Ensure we have a slot
    while (i >= resultRows.length) {
      resultRows.add(EmissionResults.empty());
    }

    final existing = resultRows[i];

    resultRows[i] = existing.copyWith(
      materialNormal: featureType == 'material' ? value : existing.materialNormal,
      material: featureType == 'material_custom' ? value : existing.material,
      transport: featureType == 'upstream_transport' ? value : existing.transport,
      machining: featureType == 'machining' ? value : existing.machining,
      fugitive: featureType == 'fugitive' ? value : existing.fugitive,
      productionTransport: featureType == 'production_transport' ? value : existing.productionTransport,
      waste: featureType == 'waste' ? value : existing.waste,
      usageCycle: featureType == 'usage_cycle' ? value :existing.usageCycle,
      endofLife:featureType == 'end_of_life' ? value :existing.endofLife,
    );
  }

  final totals = resultRows.fold(EmissionResults.empty(), (a, b) => a + b);

  state = state.copyWith(
    rowsByPart: {...state.rowsByPart, partId: resultRows},
    totalsByPart: {...state.totalsByPart, partId: totals},
  );
}

void addRow(String partId, EmissionResults row) {
  final List<EmissionResults> rows =
      (state.rowsByPart[partId] ?? <EmissionResults>[]).cast<EmissionResults>()
        ..add(row);

  final totals = rows.fold(EmissionResults.empty(), (a, b) => a + b);

  state = state.copyWith(
    rowsByPart: {...state.rowsByPart, partId: rows},
    totalsByPart: {...state.totalsByPart, partId: totals},
  );
}

void updateRow(String partId, int index, EmissionResults row) {
  final List<EmissionResults> rows =
      (state.rowsByPart[partId] ?? <EmissionResults>[]).cast<EmissionResults>();

  if (index >= rows.length) return;

  rows[index] = row;

  final totals = rows.fold(EmissionResults.empty(), (a, b) => a + b);

  state = state.copyWith(
    rowsByPart: {...state.rowsByPart, partId: rows},
    totalsByPart: {...state.totalsByPart, partId: totals},
  );
}


    }




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

// --------------- NORMAL MATERIAL STATE -----------------
class NormalMaterialState {
  final List<String?> normalMaterials;
  final List<String?> countries;
  final List<String?> masses;
  final List<String?> materialAllocationValues; 

  NormalMaterialState({
    required this.normalMaterials,
    required this.countries,
    required this.masses,
    required this.materialAllocationValues,
  });

  NormalMaterialState copyWith({
    List<String?>? normalMaterials,
    List<String?>? countries,
    List<String?>? masses,
    List<String?>? materialAllocationValues,
  }) {
    return NormalMaterialState(
      normalMaterials: normalMaterials ?? this.normalMaterials,
      countries: countries ?? this.countries,
      masses: masses ?? this.masses,
      materialAllocationValues: materialAllocationValues ?? this.materialAllocationValues,
    );
  }
}

class NormalMaterialNotifier extends StateNotifier<NormalMaterialState> {
  NormalMaterialNotifier()
      : super(
          NormalMaterialState(
            normalMaterials: [''],
            countries: [''],
            masses: [''],
            materialAllocationValues: [''],
          ),
        );

  void addRow() {
    state = state.copyWith(
      normalMaterials: [...state.normalMaterials, ''],
      countries: [...state.countries, ''],
      masses: [...state.masses, ''],
      materialAllocationValues: [...state.materialAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.normalMaterials.length > 1) {
      state = state.copyWith(
        normalMaterials: state.normalMaterials.sublist(0, state.normalMaterials.length - 1),
        countries: state.countries.sublist(0, state.countries.length - 1),
        masses: state.masses.sublist(0, state.masses.length - 1),
        materialAllocationValues: state.materialAllocationValues.sublist(0, state.materialAllocationValues.length - 1),
      );
    }
  }

  void updateCell({
    required int row,
    required String column, // 'Material', 'Country', 'Mass', 'Notes'
    required String? value,
  }) {
    final normalMaterials = [...state.normalMaterials];
    final countries = [...state.countries];
    final masses = [...state.masses];
    final materialAllocationValues = [...state.materialAllocationValues];

    switch (column) {
      case 'Material':
        normalMaterials[row] = value;
        break;
      case 'Country':
        countries[row] = value;
        break;
      case 'Mass':
        masses[row] = value;
        break;
      case 'Allocation Value':
        materialAllocationValues[row] = value;
        break;
    }

    state = state.copyWith(
      normalMaterials: normalMaterials,
      countries: countries,
      masses: masses,
      materialAllocationValues: materialAllocationValues,
    );
  }
}


// --------------- MATERIAL STATE -----------------
class MaterialTableState {
  final List<String?> materials;
  final List<String?> countries;
  final List<String?> masses;
  final List<String?> customEF;
  final List<String?> internalEF;
  final List<String?> materialAllocationValues; 

  MaterialTableState({
    required this.materials,
    required this.countries,
    required this.masses,
    required this.customEF,
    required this.internalEF,
    required this.materialAllocationValues,
  });

  MaterialTableState copyWith({
    List<String?>? materials,
    List<String?>? countries,
    List<String?>? masses,
    List<String?>? customEF,
    List<String?>? internalEF,
    List<String?>? materialAllocationValues,
  }) {
    return MaterialTableState(
      materials: materials ?? this.materials,
      countries: countries ?? this.countries,
      masses: masses ?? this.masses,
      customEF: customEF ?? this.customEF,
      internalEF : internalEF ?? this.internalEF,
      materialAllocationValues: materialAllocationValues ?? this.materialAllocationValues,
    );
  }
}

class MaterialTableNotifier extends StateNotifier<MaterialTableState> {
  MaterialTableNotifier()
      : super(
          MaterialTableState(
            materials: [''],
            countries: [''],
            masses: [''],
            customEF: [''],
            internalEF: [''],
            materialAllocationValues: [''],
          ),
        );

  void addRow() {
    state = state.copyWith(
      materials: [...state.materials, ''],
      countries: [...state.countries, ''],
      masses: [...state.masses, ''],
      customEF : [...state.customEF, ''],
      internalEF: [...state.internalEF, ''],
      materialAllocationValues: [...state.materialAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.materials.length > 1) {
      state = state.copyWith(
        materials: state.materials.sublist(0, state.materials.length - 1),
        countries: state.countries.sublist(0, state.countries.length - 1),
        masses: state.masses.sublist(0, state.masses.length - 1),
        customEF: state.customEF.sublist(0, state.customEF.length - 1),
        internalEF: state.internalEF.sublist(0, state.internalEF.length - 1),
        materialAllocationValues: state.materialAllocationValues.sublist(0, state.materialAllocationValues.length - 1),
      );
    }
  }

  void updateCell({
    required int row,
    required String column, // 'Material', 'Country', 'Mass', 'Notes'
    required String? value,
  }) {
    final materials = [...state.materials];
    final countries = [...state.countries];
    final masses = [...state.masses];
    final customEF = [...state.customEF];
    final internalEF = [...state.internalEF];
    final materialAllocationValues = [...state.materialAllocationValues];

    switch (column) {
      case 'Material':
        materials[row] = value;
        break;
      case 'Country':
        countries[row] = value;
        break;
      case 'Mass':
        masses[row] = value;
        break;
      case 'Custom Emission Factor':
        customEF[row] = value;
        break;
      case 'Internal Emission Factor':
        internalEF[row] = value;
        break;
      case 'Allocation Value':
        materialAllocationValues[row] = value;
        break;
    }

    state = state.copyWith(
      materials: materials,
      countries: countries,
      masses: masses,
      customEF: customEF,
      materialAllocationValues: materialAllocationValues,
    );
  }
}

// --------------- UPSTREAM TRANSPORT STATE -----------------
class UpstreamTransportTableState {
  final List<String?> vehicles;
  final List<String?> classes;
  final List<String?> distances;
  final List<String?> masses;
  final List<String?> transportAllocationValues; // NEW COLUMN

  UpstreamTransportTableState({
    required this.vehicles,
    required this.classes,
    required this.distances,
    required this.masses,
    required this.transportAllocationValues,
  });

  UpstreamTransportTableState copyWith({
    List<String?>? vehicles,
    List<String?>? classes,
    List<String?>? distances,
    List<String?>? masses,
    List<String?>? transportAllocationValues,
  }) {
    return UpstreamTransportTableState(
      vehicles: vehicles ?? this.vehicles,
      classes: classes ?? this.classes,
      distances: distances ?? this.distances,
      masses: masses ?? this.masses,
      transportAllocationValues: transportAllocationValues ?? this.transportAllocationValues,
    );
  }
}

class UpstreamTransportTableNotifier extends StateNotifier<UpstreamTransportTableState> {
  UpstreamTransportTableNotifier()
      : super(
          UpstreamTransportTableState(
            vehicles: [''],
            classes: [''],
            distances: [''],
            masses: [''], 
            transportAllocationValues: [''], // NEW
          ),
        );

  void addRow() {
    state = state.copyWith(
      vehicles: [...state.vehicles, ''],
      classes: [...state.classes, ''],
      distances: [...state.distances, ''],
      masses: [...state.masses, ''],
      transportAllocationValues: [...state.transportAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.vehicles.length > 1) {
      state = state.copyWith(
        vehicles: state.vehicles.sublist(0, state.vehicles.length - 1),
        classes: state.classes.sublist(0, state.classes.length - 1),
        distances: state.distances.sublist(0, state.distances.length - 1),
        masses: state.masses.sublist(0, state.masses.length - 1), 
        transportAllocationValues: state.transportAllocationValues.sublist(0, state.transportAllocationValues.length - 1),
      );
    }
  }

  void updateCell({
    required int row,
    required String column,
    required String? value,
  }) {
    final vehicles = [...state.vehicles];
    final classes = [...state.classes];
    final distances = [...state.distances];
    final masses = [...state.masses];
    final transportAllocationValues = [...state.transportAllocationValues];

    switch (column) {
      case 'Vehicle':
        vehicles[row] = value;
        break;
      case 'Class':
        classes[row] = value;
        break;
      case 'Distance (km)':
        distances[row] = value;
        break;
      case 'Mass (kg)':
        masses[row] = value;
        break;
      case 'Allocation Value':
        transportAllocationValues[row] = value;
        break;
    }

    state = state.copyWith(
      vehicles: vehicles,
      classes: classes,
      distances: distances,
      masses: masses,
      transportAllocationValues: transportAllocationValues,
    );
  }
}

// ---------------- MACHINING STATE ----------------

class MachiningTableState {
  final List<String?> machines;
  final List<String?> countries;
  final List<String?> times;
  final List<String?> machiningAllocationValues; 

  MachiningTableState({
    required this.machines,
    required this.countries,
    required this.times,
    required this.machiningAllocationValues,
  });

  MachiningTableState copyWith({
    List<String?>? machines,
    List<String?>? countries,
    List<String?>? times,
    List<String?>? machiningAllocationValues,
  }) {
    return MachiningTableState(
      machines: machines ?? this.machines,
      countries: countries ?? this.countries,
      times: times ?? this.times,
      machiningAllocationValues: machiningAllocationValues ?? this.machiningAllocationValues,
    );
  }
}

class MachiningTableNotifier extends StateNotifier<MachiningTableState> {
  MachiningTableNotifier()
      : super(
          MachiningTableState(
            machines: [''],
            countries: [''],
            times: [''],
            machiningAllocationValues: [''],
          ),
        );

  void addRow() {
    state = state.copyWith(
      machines: [...state.machines, ''],
      countries: [...state.countries, ''],
      times: [...state.times, ''],
      machiningAllocationValues: [...state.machiningAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.machines.length > 1) {
      state = state.copyWith(
        machines: state.machines.sublist(0, state.machines.length - 1),
        countries: state.countries.sublist(0, state.countries.length - 1),
        times: state.times.sublist(0, state.times.length - 1),
        machiningAllocationValues: state.machiningAllocationValues.sublist(0, state.machiningAllocationValues.length - 1),
      );
    }
  }

  void updateCell({
    required int row,
    required String column,
    required String? value,
  }) {
    final machines = [...state.machines];
    final countries = [...state.countries];
    final times = [...state.times];
    final machiningAllocationValues = [...state.machiningAllocationValues];

    switch (column) {
      case 'Machine':
        machines[row] = value;
        break;
      case 'Country':
        countries[row] = value;
        break;
      case 'Time':
      case 'Time of operation (hr)':
        times[row] = value;
        break;
      case 'Allocation Value':
        machiningAllocationValues[row] = value;
        break;
    }

    state = state.copyWith(
      machines: machines,
      countries: countries,
      times: times,
      machiningAllocationValues: machiningAllocationValues,
    );
  }
}

// ------------------ WASTE ----------------------------
class WastesTableState {
  final List<String?> wasteType;
  final List<String?> mass;
  final List<String?> wasteAllocationValues; 

  WastesTableState({
    required this.wasteType,
    required this.mass,
    required this.wasteAllocationValues,
  });

  WastesTableState copyWith({
    List<String?>? wasteType,
    List<String?>? mass,
    List<String?>? wasteAllocationValues,
  }) {
    return WastesTableState(
      wasteType: wasteType ?? this.wasteType,
      mass: mass ?? this.mass,
      wasteAllocationValues: wasteAllocationValues ?? this.wasteAllocationValues,
    );
  }
}

class WastesTableNotifier extends StateNotifier<WastesTableState> {
  WastesTableNotifier()
      : super(
          WastesTableState(
            wasteType: [''],
            mass: [''],
            wasteAllocationValues: [''],
          ),
        );

  void addRow() {
    state = state.copyWith(
      wasteType: [...state.wasteType, ''],
      mass: [...state.mass, ''],
      wasteAllocationValues: [...state.wasteAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.wasteType.length > 1) {
      state = state.copyWith(
        wasteType: state.wasteType.sublist(0, state.wasteType.length - 1),
        mass: state.mass.sublist(0, state.mass.length - 1),
        wasteAllocationValues: state.wasteAllocationValues.sublist(0, state.wasteAllocationValues.length - 1),
      );
    }
  }

  void updateCell({
    required int row,
    required String column,
    required String? value,
  }) {
    final wasteType = [...state.wasteType];
    final mass = [...state.mass];
    final wasteAllocationValues = [...state.wasteAllocationValues];

    switch (column) {
      case 'Waste Material':
        wasteType[row] = value;
        break;
      case 'Mass (kg)':
        mass[row] = value;
        break;
      case 'Allocation Value':
        wasteAllocationValues[row] = value;
        break;
    }

    state = state.copyWith(
      wasteType: wasteType,
      mass: mass,
      wasteAllocationValues: wasteAllocationValues,
    );
  }
}

// ---------------- FUGITIVE STATE ----------------

class FugitiveLeaksTableState {
  final List<String?> ghg;
  final List<String?> totalCharge;
  final List<String?> remainingCharge;
  final List<String?> fugitiveAllocationValues;

  FugitiveLeaksTableState({
    required this.ghg,
    required this.totalCharge,
    required this.remainingCharge,
    required this.fugitiveAllocationValues,
  });

  FugitiveLeaksTableState copyWith({
    List<String?>? ghg,
    List<String?>? totalCharge,
    List<String?>? remainingCharge,
    List<String?>? fugitiveAllocationValues,
  }) {
    return FugitiveLeaksTableState(
      ghg: ghg ?? this.ghg,
      totalCharge: totalCharge ?? this.totalCharge,
      remainingCharge: remainingCharge ?? this.remainingCharge,
      fugitiveAllocationValues: fugitiveAllocationValues ?? this.fugitiveAllocationValues,
    );
  }
}

class FugitiveLeaksTableNotifier
    extends StateNotifier<FugitiveLeaksTableState> {
  FugitiveLeaksTableNotifier()
      : super(
          FugitiveLeaksTableState(
            ghg: [''],
            totalCharge: [''],
            remainingCharge: [''],
            fugitiveAllocationValues: [''],
          ),
        );

  void addRow() {
    state = state.copyWith(
      ghg: [...state.ghg, ''],
      totalCharge: [...state.totalCharge, ''],
      remainingCharge: [...state.remainingCharge, ''],
      fugitiveAllocationValues: [...state.fugitiveAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.ghg.length > 1) {
      state = state.copyWith(
        ghg: state.ghg.sublist(0, state.ghg.length - 1),
        totalCharge: state.totalCharge.sublist(0, state.totalCharge.length - 1),
        remainingCharge: state.remainingCharge.sublist(0, state.remainingCharge.length - 1),
        fugitiveAllocationValues: state.fugitiveAllocationValues.sublist(0, state.fugitiveAllocationValues.length - 1),
      );
    }
  }

  void updateCell({
    required int row,
    required String column,
    required String? value,
  }) {
    final ghg = [...state.ghg];
    final total = [...state.totalCharge];
    final remaining = [...state.remainingCharge];
    final fugitiveAllocationValues = [...state.fugitiveAllocationValues];

    switch (column) {
      case 'GHG':
        ghg[row] = value;
        break;
      case 'Total':
      case 'Total Charge (kg)':
        total[row] = value;
        break;
      case 'Remaining':
      case 'Remaining Charge (kg)':
        remaining[row] = value;
        break;
      case 'Allocation Value':  
        fugitiveAllocationValues[row] = value;
        break;
    }

    state = state.copyWith(
      ghg: ghg,
      totalCharge: total,
      remainingCharge: remaining,
      fugitiveAllocationValues: fugitiveAllocationValues,
    );
  }
}

// -----------------PRODUCTION TRANSPORT--------
class ProductionTransportTableState {
  final List<String?> vehicles;
  final List<String?> classes;
  final List<String?> distances;
  final List<String?> masses;
  final List<String?> transportAllocationValues; // NEW COLUMN

  ProductionTransportTableState({
    required this.vehicles,
    required this.classes,
    required this.distances,
    required this.masses,
    required this.transportAllocationValues,
  });

  ProductionTransportTableState copyWith({
    List<String?>? vehicles,
    List<String?>? classes,
    List<String?>? distances,
    List<String?>? masses,
    List<String?>? transportAllocationValues,
  }) {
    return ProductionTransportTableState(
      vehicles: vehicles ?? this.vehicles,
      classes: classes ?? this.classes,
      distances: distances ?? this.distances,
      masses: masses ?? this.masses,
      transportAllocationValues: transportAllocationValues ?? this.transportAllocationValues,
    );
  }
}

class ProductionTransportTableNotifier extends StateNotifier<ProductionTransportTableState> {
  ProductionTransportTableNotifier()
      : super(
          ProductionTransportTableState(
            vehicles: [''],
            classes: [''],
            distances: [''],
            masses: [''], 
            transportAllocationValues: [''], // NEW
          ),
        );

  void addRow() {
    state = state.copyWith(
      vehicles: [...state.vehicles, ''],
      classes: [...state.classes, ''],
      distances: [...state.distances, ''],
      masses: [...state.masses, ''],
      transportAllocationValues: [...state.transportAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.vehicles.length > 1) {
      state = state.copyWith(
        vehicles: state.vehicles.sublist(0, state.vehicles.length - 1),
        classes: state.classes.sublist(0, state.classes.length - 1),
        distances: state.distances.sublist(0, state.distances.length - 1),
        masses: state.masses.sublist(0, state.masses.length - 1), 
        transportAllocationValues: state.transportAllocationValues.sublist(0, state.transportAllocationValues.length - 1),
      );
    }
  }

  void updateCell({
    required int row,
    required String column,
    required String? value,
  }) {
    final vehicles = [...state.vehicles];
    final classes = [...state.classes];
    final distances = [...state.distances];
    final masses = [...state.masses];
    final transportAllocationValues = [...state.transportAllocationValues];

    switch (column) {
      case 'Vehicle':
        vehicles[row] = value;
        break;
      case 'Class':
        classes[row] = value;
        break;
      case 'Distance (km)':
        distances[row] = value;
        break;
      case 'Mass (kg)':
        masses[row] = value;
        break;
      case 'Allocation Value':
        transportAllocationValues[row] = value;
        break;
    }

    state = state.copyWith(
      vehicles: vehicles,
      classes: classes,
      distances: distances,
      masses: masses,
      transportAllocationValues: transportAllocationValues,
    );
  }
}

// ---------------- USAGE CYCLE ----------------

class UsageCycleState {
  final List<String?> categories;
  final List<String?> productTypes;
  final List<String?> usageFrequencies;
  final List<String?> usageCycleAllocationValues;

  UsageCycleState({
    required this.categories,
    required this.productTypes,
    required this.usageFrequencies,
    required this.usageCycleAllocationValues,
  });

  UsageCycleState copyWith({
    List<String?>? categories,
    List<String?>? productTypes,
    List<String?>? usageFrequencies,
    List<String?>? usageCycleAllocationValues,
  }) {
    return UsageCycleState(
      categories: categories ?? this.categories,
      productTypes: productTypes ?? this.productTypes,
      usageFrequencies: usageFrequencies ?? this.usageFrequencies,
      usageCycleAllocationValues: usageCycleAllocationValues ?? this.usageCycleAllocationValues,
    );
  }
}

class UsageCycleNotifier extends StateNotifier<UsageCycleState> {
  UsageCycleNotifier()
      : super(
          UsageCycleState(
            categories: [''],
            productTypes: [''],
            usageFrequencies: [''],
            usageCycleAllocationValues: [''],
          ),
        );

  void addRow() {
    state = state.copyWith(
      categories: [...state.categories, ''],
      productTypes: [...state.productTypes, ''],
      usageFrequencies: [...state.usageFrequencies, ''],
      usageCycleAllocationValues: [...state.usageCycleAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.categories.length > 1) {
      state = state.copyWith(
        categories: state.categories.sublist(0, state.categories.length - 1),
        productTypes: state.productTypes.sublist(0, state.productTypes.length - 1),
        usageFrequencies: state.usageFrequencies.sublist(0, state.usageFrequencies.length - 1),
        usageCycleAllocationValues: state.usageCycleAllocationValues.sublist(0, state.usageCycleAllocationValues.length - 1),
      );
    }
  }
  void updateCell({
    required int row,
    required String column,
    required String? value,
  }) {
    final categories = [...state.categories];
    final productTypes = [...state.productTypes];
    final usageFrequencies = [...state.usageFrequencies];
    final usageCycleAllocationValues = [...state.usageCycleAllocationValues];
    switch (column) {
      case 'Category':
        categories[row] = value;
        break;
      case 'Product':
        productTypes[row] = value;
        break;
      case 'Usage Frequency':
        usageFrequencies[row] = value;
        break;
    }

    state = state.copyWith(
      categories: categories,
      productTypes: productTypes,
      usageFrequencies: usageFrequencies,
      usageCycleAllocationValues: usageCycleAllocationValues,
    );
  }
}

// ---------------- END OF LIFE STATE ----------------
class EndOfLifeTableState {
  final List<String?> endOfLifeOptions;
  final List<String?> endOfLifeTotalMass;
  final List<String?> endOfLifeAllocationValues;

  EndOfLifeTableState({
    required this.endOfLifeOptions,
    required this.endOfLifeTotalMass,
    required this.endOfLifeAllocationValues,
  });

  EndOfLifeTableState copyWith({
    List<String?>? endOfLifeOptions,
    List<String?>? endOfLifeTotalMass,
    List<String?>? endOfLifePercentage,
    List<String?>? endOfLifeAllocationValues,
  }) {
    return EndOfLifeTableState(
      endOfLifeOptions: endOfLifeOptions ?? this.endOfLifeOptions,
      endOfLifeTotalMass: endOfLifeTotalMass ?? this.endOfLifeTotalMass,
      endOfLifeAllocationValues: endOfLifeAllocationValues ?? this.endOfLifeAllocationValues,
    );
  }
}

class EndOfLifeTableNotifier extends StateNotifier<EndOfLifeTableState> {
  EndOfLifeTableNotifier()
      : super(
          EndOfLifeTableState(
            endOfLifeOptions: [''],
            endOfLifeTotalMass: [''],
            endOfLifeAllocationValues: [''],
          ),
        );

  void addRow() {
    state = state.copyWith(
      endOfLifeOptions: [...state.endOfLifeOptions, ''],
      endOfLifeTotalMass: [...state.endOfLifeTotalMass, ''],
      endOfLifeAllocationValues: [...state.endOfLifeAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.endOfLifeOptions.length > 1) {
      state = state.copyWith(
        endOfLifeOptions: state.endOfLifeOptions.sublist(0, state.endOfLifeOptions.length - 1),
        endOfLifeTotalMass: state.endOfLifeTotalMass.sublist(0, state.endOfLifeTotalMass.length - 1),
        endOfLifeAllocationValues: state.endOfLifeAllocationValues.sublist(0, state.endOfLifeAllocationValues.length - 1),
      );
    }
  }

  void updateCell({
    required int row,
    required String column,
    required String? value,
  }) {
    final endOfLifeOptions = [...state.endOfLifeOptions];
    final endOfLifeTotalMass = [...state.endOfLifeTotalMass];
    final endOfLifeAllocationValues = [...state.endOfLifeAllocationValues]; 

    switch (column) {
      case 'End of Life Option':
        endOfLifeOptions[row] = value;
        break;
      case 'Total Mass':
        endOfLifeTotalMass[row] = value;
        break;
      case 'Allocation Value':
        endOfLifeAllocationValues[row] = value;
        break;
    }

    state = state.copyWith(
      endOfLifeOptions: endOfLifeOptions,
      endOfLifeTotalMass: endOfLifeTotalMass,
      endOfLifeAllocationValues: endOfLifeAllocationValues,
    );
  }
}

// ----------------------PROVIDERS-----------------
typedef TableKey = ({String product, String part});

double _toDouble(String? value) => double.tryParse(value ?? '0') ?? 0.0;

/// ---------------- NORMAL MATERIAL ----------------
final normalMaterialTableProvider = StateNotifierProvider.family<
    NormalMaterialNotifier,
    NormalMaterialState,
    TableKey>((ref, key) {
  return NormalMaterialNotifier();
});

final normalMaterialAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(normalMaterialTableProvider(key));
  return table.materialAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});

/// ---------------- MATERIAL ----------------
final materialTableProvider = StateNotifierProvider.family<
    MaterialTableNotifier,
    MaterialTableState,
    TableKey>((ref, key) {
  return MaterialTableNotifier();
});

final materialAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(materialTableProvider(key));
  return table.materialAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});


/// ---------------- UPSTREAM TRANSPORT ----------------
final upstreamTransportTableProvider =
    StateNotifierProvider.family<UpstreamTransportTableNotifier, UpstreamTransportTableState, TableKey>(
        (ref, key) => UpstreamTransportTableNotifier());

final transportAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(upstreamTransportTableProvider(key));
  return table.transportAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});


/// ---------------- MACHINING ----------------
final machiningTableProvider =
    StateNotifierProvider.family<MachiningTableNotifier, MachiningTableState, TableKey>(
  (ref, key) => MachiningTableNotifier(),
);

final machiningAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(machiningTableProvider(key));
  return table.machiningAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});


/// ---------------- WASTE ----------------
final wastesProvider =
    StateNotifierProvider.family<WastesTableNotifier, WastesTableState, TableKey>(
  (ref, key) => WastesTableNotifier(),
);

final wastesAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(wastesProvider(key));
  return table.wasteAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});


/// ---------------- FUGITIVE LEAKS ----------------
final fugitiveLeaksTableProvider =
    StateNotifierProvider.family<FugitiveLeaksTableNotifier, FugitiveLeaksTableState, TableKey>(
  (ref, key) => FugitiveLeaksTableNotifier(),
);

final fugitiveAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(fugitiveLeaksTableProvider(key));
  return table.fugitiveAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});


/// ---------------- PRODUCTION TRANSPORT ----------------
final productionTransportTableProvider =
    StateNotifierProvider.family<ProductionTransportTableNotifier, ProductionTransportTableState, TableKey>(
        (ref, key) => ProductionTransportTableNotifier());

final productionTransportTableAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(productionTransportTableProvider(key));
  return table.transportAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});


/// ---------------- USAGE CYCLE ----------------
final usageCycleTableProvider =
    StateNotifierProvider.family<UsageCycleNotifier, UsageCycleState, TableKey>(
  (ref, key) => UsageCycleNotifier(),
);

final usageCycleAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(usageCycleTableProvider(key));
  return table.usageCycleAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b); 
});


/// ---------------- END OF LIFE ----------------
final endOfLifeTableProvider =
    StateNotifierProvider.family<EndOfLifeTableNotifier, EndOfLifeTableState, TableKey>(
  (ref, key) => EndOfLifeTableNotifier(),
);

final endOfLifeAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(endOfLifeTableProvider(key));
  return table.endOfLifeAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b); 
});

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


