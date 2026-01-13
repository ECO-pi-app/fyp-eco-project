import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';



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
      assemblyProcesses: List<String>.from(json['typ_here'] ?? [],)
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

// ------------------- CALCULATION AND RESULT  -------------------
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

class EmissionResults {
  final double material;
  final double transport;
  final double machining;
  final double fugitive;
  final double productionTransport;
  final double usageCycle;
  final double endofLife;

  const EmissionResults({
    this.material = 0,
    this.transport = 0,
    this.machining = 0,
    this.fugitive = 0,
    this.productionTransport = 0,
    this.usageCycle = 0,
    this.endofLife = 0,
  });

  // Returns a new instance with updated values
  EmissionResults copyWith({
    double? material,
    double? transport,
    double? machining,
    double? fugitive,
    double? production_transport,
    double? usageCycle,
    double? endofLife,
  }) {
    return EmissionResults(
      material: material ?? this.material,
      transport: transport ?? this.transport,
      machining: machining ?? this.machining,
      fugitive: fugitive ?? this.fugitive,
      productionTransport: production_transport ?? this.productionTransport,
      usageCycle: usageCycle ?? this.usageCycle,
      endofLife: endofLife ?? this.endofLife,
    );
  }

  // Total of all emissions
  double get total => material + transport + machining + fugitive + productionTransport + usageCycle + endofLife;
}

final emissionCalculatorProvider = StateNotifierProvider.family<
    EmissionCalculator, EmissionResults, String>(
  (ref, productId) => EmissionCalculator(),
);

final convertedEmissionsProvider =
    Provider.family<EmissionResults, String>((ref, productId) {
  final base = ref.watch(emissionCalculatorProvider(productId));
  final factor = ref.watch(unitConversionProvider);

  // per-product material allocation
  final materialAlloc = ref.watch(materialAllocationSumProvider(productId));
  final transportAlloc = ref.watch(transportAllocationSumProvider(productId));
  final machiningAlloc = ref.watch(machiningAllocationSumProvider(productId));
  final fugitiveAlloc = ref.watch(fugitiveAllocationSumProvider(productId));
  final productionTransportAlloc = ref.watch(productionTransportTableAllocationSumProvider(productId));
  final usageCycleAlloc = ref.watch(usageCycleAllocationSumProvider(productId));
  final endOfLifeAlloc = ref.watch(endOfLifeAllocationSumProvider(productId));

  


  return EmissionResults(
    material: base.material * (materialAlloc / 100) * factor,
    transport: base.transport * (transportAlloc / 100) * factor,
    machining: base.machining * (machiningAlloc / 100) * factor,
    fugitive: base.fugitive * (fugitiveAlloc / 100) * factor,
    productionTransport: base.productionTransport * (productionTransportAlloc/100) * factor,
    usageCycle: base.usageCycle * (usageCycleAlloc / 100) * factor,
    endofLife: base.endofLife * (endOfLifeAlloc / 100) * factor,
  );
});



// ------------------- CALCULATOR -------------------
class EmissionCalculator extends StateNotifier<EmissionResults> {
  EmissionCalculator() : super(const EmissionResults());

    final Map<String, Map<String, dynamic>> _config = {
    'material': {
      'endpoint': 'http://127.0.0.1:8000/calculate/material_emission',
      'apiKeys': {
        "Country": "country",
        "Material": "material",
        "Mass (kg)": "mass_kg",
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
      'endpoint': 'http://127.0.0.1:8000/calculate/machine_power_emission',
      'apiKeys': {
        "Machine": "machine_model",
        "Country": "country",
        "Time of operation (hr)": "time_operated_hr",
      }
    },
    'fugitive': {
      'endpoint': 'http://127.0.0.1:8000/calculate/fugitive_emissions',
      'apiKeys': {
        "GHG": "ghg_name",
        "Total Charge (kg)": "total_charged_amount_kg",
        "Remaining Charge (kg)": "current_charge_amount_kg",
      }
    },
    'production_transport' : {
      'endpoint' : 'http://127.0.0.1:8000/calculate/type_here',
      'apiKeys': {
        "Vehicle": "vehicle_type",
        "Class": "transport_type",
        "Distance (km)": "distance_km",
        "Mass (kg)": "mass_kg", 
      }
    },
    'usage_cycle': {
      'endpoint': 'http://127.0.0.1:8000/calculate/usage_cycle',
      'apiKeys': {
        "Usage Frequency": "[]",
        "Product Type": "[]",
        "Category": "[]",
      }
    },
    'end_of_life': {
      'endpoint': 'http://127.0.0.1:8000/calculate/end_of_life',
      'apiKeys': {
        "End of Life": "[]",
        "Product Mass (kg)": "[]",
        "Percentage of Mass (%)": "[]",
      }
    }
  };

Future<void> calculate(String featureType, List<RowFormat> rows) async {
  double subtotal = 0;

  final config = _config[featureType];
  if (config == null) {
    throw Exception("Feature type not configured: $featureType");
  }
  
  final defaultEndpoint = config['endpoint'] as String;
  final apiKeyMap = config['apiKeys'] as Map<String, String>;

  final Map<String, String> transportEndpoints = {
    'Van': 'http://127.0.0.1:8000/calculate/van',
    'HGV (Diesel)': 'http://127.0.0.1:8000/calculate/hgv',
    'HGV Refrigerated (Diesel)': 'http://127.0.0.1:8000/calculate/hgv_r',
    'Freight Flights': 'http://127.0.0.1:8000/calculate/freight_flight',
    'Rail': 'http://127.0.0.1:8000/calculate/rail_sheet',
    'Sea Tanker': 'http://127.0.0.1:8000/calculate/sea_tanker',
    'Cargo Ship': 'http://127.0.0.1:8000/calculate/cargo_ship',
  };

  for (var row in rows) {
    final payload = <String, dynamic>{};

    for (int i = 0; i < row.columnTitles.length; i++) {
      final columnName = row.columnTitles[i];
      final apiKey = apiKeyMap[columnName];
      final rawValue = row.selections[i];

      if (apiKey != null) {
        payload[apiKey] = row.isTextFieldColumn[i]
            ? double.tryParse(rawValue ?? '0') ?? 0
            : rawValue ?? '';
      } else {
        print('Column "$columnName" has no mapping in apiKeyMap!');
      }
    }

    String endpoint = defaultEndpoint;

    if (featureType == 'upstream_transport') {
      final vehicle = row.selections[0]; 

      endpoint = transportEndpoints[vehicle] ??
          defaultEndpoint; 
    }

        if (featureType == 'production_transport') {
      final vehicle = row.selections[0]; 

      endpoint = transportEndpoints[vehicle] ??
          defaultEndpoint; 
    }

    print("POST to $endpoint");
    print("Payload: $payload");

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      subtotal += (json["materialacq_emission"] ?? 0).toDouble();
      subtotal += (json["total_transport_type_emission"] ?? 0).toDouble();
      subtotal += (json["emissions_kgco2e"] ?? 0).toDouble();
      subtotal += (json["emissions"] ?? 0).toDouble();
    } else {
      print("API error ${response.statusCode}: ${response.body}");
    }
  }

  switch (featureType) {
    case 'material':
      state = state.copyWith(material: subtotal);
      break;
    case 'upstream_transport':
      state = state.copyWith(transport: subtotal);
      break;
    case 'machining':
      state = state.copyWith(machining: subtotal);
      break;
    case 'fugitive':
      state = state.copyWith(fugitive: subtotal);
      break;
    case 'production_transport':
      state = state.copyWith(production_transport: subtotal);
      break;
    case 'usage_cycle':
      state = state.copyWith(usageCycle: subtotal);
      break;
    default:
      throw Exception("Invalid feature type: $featureType");
  }
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




// ------------------- PROJECT LIST FETCH -------------------
class Product {
  final String name;

  Product({required this.name});

  factory Product.fromJson(dynamic value) {
    return Product(name: value.toString());
  }
}

Future<List<Product>> fetchProducts(String username) async {
  print("Fetching products for username: $username");

  final url = Uri.parse('http://127.0.0.1:8000/profiles?username=$username');

  final response = await http.get(
    url,
    headers: {"Content-Type": "application/json"},
  );

  print("Fetch status code: ${response.statusCode}");
  print("Fetch response body: ${response.body}");

  if (response.statusCode == 200) {
    final Map<String, dynamic> map = jsonDecode(response.body);
    final List<dynamic> rawList = map["profiles"];
    final products = rawList.map((item) => Product.fromJson(item)).toList();
    print("Fetched products: ${products.map((p) => p.name).toList()}");
    return products;
  } else if (response.statusCode == 401) {
    print("Unauthorized — username may be invalid or token expired");
    throw Exception("Unauthorized – please log in again");
  } else {
    print("Failed to load products with status: ${response.statusCode}");
    throw Exception('Failed to load products: ${response.statusCode}');
  }
}

// ---------------- PRODUCTS PROVIDER ----------------
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final username = await ref.watch(usernameProvider.future);
  print("Username loaded from provider for products fetch: $username");

  if (username == null) {
    print("No username saved — cannot fetch products");
    throw Exception("No username saved — user is not logged in");
  }

  return fetchProducts(username);
});

// ---------------- PROFILE SAVE ----------------
class ProfileSaveRequest {
  final String profileName;
  final String description;
  final Map<String, dynamic> data;
  final String username;

  ProfileSaveRequest({
    required this.profileName,
    required this.description,
    required this.data,
    required this.username,
  });
}

final saveProfileProvider =
    FutureProvider.family<String, ProfileSaveRequest>((ref, req) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/profiles/save'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "profile_name": req.profileName,
      "description": req.description,
      "data": req.data,
      "username": req.username,
    }),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    ref.invalidate(productsProvider);
    return json["saved_profile"]; // whatever your backend returns
  } else {
    throw Exception("Failed to save profile: ${response.body}");
  }

});

// ---------------- SIGN UP REQUEST ----------------
class SignUpParameters {
  final String profileName;
  final String password;

  SignUpParameters({
    required this.profileName,
    required this.password,
  });
}

final signUpProvider =
    FutureProvider.family<String, SignUpParameters>((ref, req) async {
  final payload = jsonEncode({
    "username": req.profileName,
    "password": req.password,
  });

  print("Sign up payload: $payload");

  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/auth/signup'),
    headers: {"Content-Type": "application/json"},
    body: payload,
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    // refresh products or profiles UI if needed
    ref.invalidate(productsProvider);
    return json["username"];
  } else {
    throw Exception("Failed to sign up: ${response.body}");
  }
});




// ------------------- POST (THE REQUEST) LOG IN AUTHENTICATION -------------------
class LoginParameters {
  final String profileName;
  final String password;

  LoginParameters({
    required this.profileName,
    required this.password,
  });
}

// ---------------- LOGIN PROVIDER ----------------
final logInProvider =
    FutureProvider.family<void, LoginParameters>((ref, req) async {
  final payload = jsonEncode({
    "username": req.profileName,
    "password": req.password,
  });

  print("Login payload: $payload");

  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/auth/login'),
    headers: {"Content-Type": "application/json"},
    body: payload,
  );

  print("Login status code: ${response.statusCode}");
  print("Login response body: ${response.body}");

  if (response.statusCode != 200) {
    throw Exception("Login failed: ${response.body}");
  }

  // Save username in secure storage
  await secureStorage.write(
    key: "username",
    value: req.profileName,
  );
  print("Saved username to secure storage: ${req.profileName}");

  // Read back immediately for debug
  final savedUsername = await secureStorage.read(key: "username");
  print("Verified username read from storage: $savedUsername");

  // Invalidate providers so UI can refresh
  ref.invalidate(usernameProvider);
  ref.invalidate(productsProvider);
});

// ---------------- USERNAME PROVIDER ----------------
final usernameProvider = FutureProvider<String?>((ref) async {
  final username = await secureStorage.read(key: "username");
  print("Loaded username from storage in provider: $username");
  return username;
});

// ------------------- DELETE PROJECTS -------------------
class ProfileService {
  final String baseUrl;

  ProfileService(this.baseUrl);

  /// Deletes a profile. Returns true if success, throws exception if failure.
Future<bool> deleteProfile(String username, String profileName) async {
  final url = Uri.parse('$baseUrl/profiles/delete/$username/$profileName');
  final response = await http.delete(url);

  if (response.statusCode == 200) return true;
  if (response.statusCode == 404) throw Exception("Profile not found");
  throw Exception("Failed: ${response.statusCode} ${response.body}");
}

}

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService("http://127.0.0.1:8000");
});

// ---------------- DELETE PROFILE NOTIFIER ----------------
final deleteProfileProvider =
    AsyncNotifierProvider<DeleteProfileNotifier, void>(
  () => DeleteProfileNotifier(),
);

class DeleteProfileNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // nothing to build initially
  }

  Future<void> delete(String profileName, WidgetRef ref) async {
    state = const AsyncLoading();

    try {
      final service = ref.read(profileServiceProvider);
      final username = await ref.watch(usernameProvider.future);
      await service.deleteProfile(username!, profileName);

      // invalidate products or profiles if you want UI to refresh
      ref.invalidate(productsProvider);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

double _toDouble(String? value) {
  if (value == null) return 0.0;
  return double.tryParse(value) ?? 0.0;
}





// --------------- MATERIAL STATE -----------------
class MaterialTableState {
  final List<String?> materials;
  final List<String?> countries;
  final List<String?> masses;
  final List<String?> materialAllocationValues; // NEW COLUMN

  MaterialTableState({
    required this.materials,
    required this.countries,
    required this.masses,
    required this.materialAllocationValues,
  });

  MaterialTableState copyWith({
    List<String?>? materials,
    List<String?>? countries,
    List<String?>? masses,
    List<String?>? materialAllocationValues,
  }) {
    return MaterialTableState(
      materials: materials ?? this.materials,
      countries: countries ?? this.countries,
      masses: masses ?? this.masses,
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
            materialAllocationValues: [''], // NEW
          ),
        );

  void addRow() {
    state = state.copyWith(
      materials: [...state.materials, ''],
      countries: [...state.countries, ''],
      masses: [...state.masses, ''],
      materialAllocationValues: [...state.materialAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.materials.length > 1) {
      state = state.copyWith(
        materials: state.materials.sublist(0, state.materials.length - 1),
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
    final materials = [...state.materials];
    final countries = [...state.countries];
    final masses = [...state.masses];
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
      case 'Allocation Value':
        materialAllocationValues[row] = value;
        break;
    }

    state = state.copyWith(
      materials: materials,
      countries: countries,
      masses: masses,
      materialAllocationValues: materialAllocationValues,
    );
  }
}

final materialTableProvider = StateNotifierProvider.family<
    MaterialTableNotifier,
    MaterialTableState,
    String>((ref, productID) {
  return MaterialTableNotifier();
});


final materialAllocationSumProvider = Provider.family<double, String>((ref, productID) {
  final table = ref.watch(materialTableProvider(productID));
  return table.materialAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});



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

final upstreamTransportTableProvider =
    StateNotifierProvider.family<UpstreamTransportTableNotifier, UpstreamTransportTableState, String>(
        (ref, productID) => UpstreamTransportTableNotifier());

final transportAllocationSumProvider = Provider.family<double, String>((ref, productID) {
  final table = ref.watch(upstreamTransportTableProvider(productID));
  return table.transportAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});

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

final machiningTableProvider =
    StateNotifierProvider.family<MachiningTableNotifier, MachiningTableState, String>(
  (ref, productID) => MachiningTableNotifier(),
);

final machiningAllocationSumProvider = Provider.family<double, String>((ref, productID) {
  final table = ref.watch(machiningTableProvider(productID));

  return table.machiningAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});

// ------------------ WASTE ----------------------------
class WastesState {
  final List<String?> wasteType;
  final List<String?> mass;
  final List<String?> wasteAllocationValues; 

  WastesState({
    required this.wasteType,
    required this.mass,
    required this.wasteAllocationValues,
  });

  WastesState copyWith({
    List<String?>? machines,
    List<String?>? mass,
    List<String?>? machiningAllocationValues,
  }) {
    return WastesState(
      wasteType: machines ?? this.wasteType,
      mass: mass ?? this.mass,
      wasteAllocationValues: machiningAllocationValues ?? this.wasteAllocationValues,
    );
  }
}

class WastesNotifier extends StateNotifier<WastesState> {
  WastesNotifier()
      : super(
          WastesState(
            wasteType: [''],
            mass: [''],
            wasteAllocationValues: [''],
          ),
        );

  void addRow() {
    state = state.copyWith(
      machines: [...state.wasteType, ''],
      mass: [...state.mass, ''],
      machiningAllocationValues: [...state.wasteAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.wasteType.length > 1) {
      state = state.copyWith(
        machines: state.wasteType.sublist(0, state.wasteType.length - 1),
        mass: state.mass.sublist(0, state.mass.length - 1),
        machiningAllocationValues: state.wasteAllocationValues.sublist(0, state.wasteAllocationValues.length - 1),
      );
    }
  }

  void updateCell({
    required int row,
    required String column,
    required String? value,
  }) {
    final machines = [...state.wasteType];
    final times = [...state.mass];
    final machiningAllocationValues = [...state.wasteAllocationValues];

    switch (column) {
      case 'Machine':
        machines[row] = value;
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
      mass: times,
      machiningAllocationValues: machiningAllocationValues,
    );
  }
}

final wastesProvider =
    StateNotifierProvider.family<WastesNotifier, WastesState, String>(
  (ref, productID) => WastesNotifier(),
);

final wastesAllocationSumProvider = Provider.family<double, String>((ref, productID) {
  final table = ref.watch(wastesProvider(productID));

  return table.wasteAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});
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

final fugitiveLeaksTableProvider =
    StateNotifierProvider.family<FugitiveLeaksTableNotifier, FugitiveLeaksTableState, String>(
  (ref, productID) => FugitiveLeaksTableNotifier(),
);

final fugitiveAllocationSumProvider = Provider.family<double, String>((ref, productID) {
  final table = ref.watch(fugitiveLeaksTableProvider(productID));

  return table.fugitiveAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});

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

final productionTransportTableProvider =
    StateNotifierProvider.family<ProductionTransportTableNotifier, ProductionTransportTableState, String>(
        (ref, productID) => ProductionTransportTableNotifier());

final productionTransportTableAllocationSumProvider = Provider.family<double, String>((ref, productID) {
  final table = ref.watch(productionTransportTableProvider(productID));
  return table.transportAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});


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
      case 'Product Type':
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

final usageCycleTableProvider =
    StateNotifierProvider.family<UsageCycleNotifier, UsageCycleState, String>(
  (ref, productID) => UsageCycleNotifier(),
);

final usageCycleAllocationSumProvider = Provider.family<double, String>((ref, productID) {
  final table = ref.watch(usageCycleTableProvider(productID));

  return table.usageCycleAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b); 
});

// ---------------- END OF LIFE STATE ----------------
class EndOfLifeTableState {
  final List<String?> endOfLifeOptions;
  final List<String?> endOfLifeTotalMass;
  final List<String?> endOfLifePercentage;
  final List<String?> endOfLifeAllocationValues;

  EndOfLifeTableState({
    required this.endOfLifeOptions,
    required this.endOfLifeTotalMass,
    required this.endOfLifePercentage,
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
      endOfLifePercentage: endOfLifePercentage ?? this.endOfLifePercentage,
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
            endOfLifePercentage: [''],
            endOfLifeAllocationValues: [''],
          ),
        );

  void addRow() {
    state = state.copyWith(
      endOfLifeOptions: [...state.endOfLifeOptions, ''],
      endOfLifeTotalMass: [...state.endOfLifeTotalMass, ''],
      endOfLifePercentage: [...state.endOfLifePercentage, ''],
      endOfLifeAllocationValues: [...state.endOfLifeAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.endOfLifeOptions.length > 1) {
      state = state.copyWith(
        endOfLifeOptions: state.endOfLifeOptions.sublist(0, state.endOfLifeOptions.length - 1),
        endOfLifeTotalMass: state.endOfLifeTotalMass.sublist(0, state.endOfLifeTotalMass.length - 1),
        endOfLifePercentage: state.endOfLifePercentage.sublist(0, state.endOfLifePercentage.length - 1),
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
    final endOfLifePercentage = [...state.endOfLifePercentage];
    final endOfLifeAllocationValues = [...state.endOfLifeAllocationValues]; 

    switch (column) {
      case 'End of Life Option':
        endOfLifeOptions[row] = value;
        break;
      case 'Total Mass':
        endOfLifeTotalMass[row] = value;
        break;
      case 'Percentage':
        endOfLifePercentage[row] = value;
        break;
      case 'Allocation Value':
        endOfLifeAllocationValues[row] = value;
        break;
    }

    state = state.copyWith(
      endOfLifeOptions: endOfLifeOptions,
      endOfLifeTotalMass: endOfLifeTotalMass,
      endOfLifePercentage: endOfLifePercentage,
      endOfLifeAllocationValues: endOfLifeAllocationValues,
    );
  }
}

final endOfLifeTableProvider =
    StateNotifierProvider.family<EndOfLifeTableNotifier, EndOfLifeTableState, String>(
  (ref, productID) => EndOfLifeTableNotifier(),
);

final endOfLifeAllocationSumProvider = Provider.family<double, String>((ref, productID) {
  final table = ref.watch(endOfLifeTableProvider(productID));

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


