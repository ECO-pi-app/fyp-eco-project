import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// -------------------  PAGE TRACKING  -------------------
final currentPageProvider = StateProvider<int>((ref) => 0);

// ------------------- UNIT CONVERSION -------------------

// Dropdown options you will show in UI
const Map<String, double> conversionFactors = {
  "Metric (kg CO₂)" : 1.0,     // default
  "Imperial (lb CO₂)" : 2.20462,
  "Grams (g CO₂)" : 1000.0,
};
Map<double, String> unitLabels = {
  1.0: 'kg',
  2.20462: 'lb',
  1000.0: 'g',
};
Map<double, String> unitNames = {
  1.0: 'Metric',
  2.20462: 'Imperial',
  1000.0: 'Metric x10^-3',
};

// Stores the selected unit
final unitConversionProvider =
    StateProvider<double>((ref) => 1.0); // default 

final unitLabelProvider = Provider<String>((ref) {
  final factor = ref.watch(unitConversionProvider);
  return unitLabels[factor] ?? 'kg'; // default 
});

final unitNameProvider = Provider<String>((ref) {
  final factor = ref.watch(unitConversionProvider);
  return unitNames[factor] ?? 'Metric'; // default 
});


final myCheckboxProvider = StateProvider<bool>((ref) => false);



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


// ------------------- CALCULATION AND RESULT  -------------------

// ------------------- DATA FORMAT -------------------
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

// ------------------- RESULT MODEL -------------------
class EmissionResults {
  final double material;
  final double transport;
  final double machining;
  final double fugitive;

  const EmissionResults({
    this.material = 0,
    this.transport = 0,
    this.machining = 0,
    this.fugitive = 0,
  });

  // Returns a new instance with updated values
  EmissionResults copyWith({
    double? material,
    double? transport,
    double? machining,
    double? fugitive,
  }) {
    return EmissionResults(
      material: material ?? this.material,
      transport: transport ?? this.transport,
      machining: machining ?? this.machining,
      fugitive: fugitive ?? this.fugitive,
    );
  }

  // Total of all emissions
  double get total => material + transport + machining + fugitive;
}

final emissionCalculatorProvider = StateNotifierProvider<
    EmissionCalculator, EmissionResults>(
  (ref) => EmissionCalculator(),
);

final convertedEmissionsProvider = Provider<EmissionResults>((ref) {
  final base = ref.watch(emissionCalculatorProvider);
  final factor = ref.watch(unitConversionProvider);

  return EmissionResults(
    material: base.material * factor,
    transport: base.transport * factor,
    machining: base.machining * factor,
    fugitive: base.fugitive * factor,
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
    'transport': {
      'endpoint': 'http://127.0.0.1:8000/calculate/van',
      'apiKeys': {
        "Class": "transport_type",
        "Distance (km)": "distance_km",
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
  };

   Future<void> calculate(String featureType, List<RowFormat> rows) async {
    double subtotal = 0;

    final config = _config[featureType];
    if (config == null) {
      throw Exception("Feature type not configured: $featureType");
    }

    final endpoint = config['endpoint'] as String;
    final apiKeyMap = config['apiKeys'] as Map<String, String>;

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
        print('Column "$columnName" has no mapping in apiKeyMap!'); // <- this will catch mismatches
      }
    }

      

      print("Payload for $featureType: $payload");
 
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // Collect all possible emission keys safely
        subtotal += (json["materialacq_emission"] ?? 0).toDouble();
        subtotal += (json["total_emission"] ?? 0).toDouble();
        subtotal += (json["emissions_kgco2e"] ?? 0).toDouble();
        subtotal += (json["emissions"] ?? 0).toDouble();
      } else {
        print("API error ${response.statusCode}: ${response.body}");
      }
    }

    // Update only the specific part of the result
    switch (featureType) {
      case 'material':
        state = state.copyWith(material: subtotal);
        break;
      case 'transport':
        state = state.copyWith(transport: subtotal);
        break;
      case 'machining':
        state = state.copyWith(machining: subtotal);
        break;
      case 'fugitive':
        state = state.copyWith(fugitive: subtotal);
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
    // value is just a string
    return Product(name: value.toString());
  }
}



Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/profiles'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> map = jsonDecode(response.body);

    final List<dynamic> rawList = map["profiles"]; // <-- list of strings

    return rawList.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}


// Riverpod provider
final productsProvider = FutureProvider<List<Product>>((ref) async {
  return fetchProducts();
});


// ------------------- ADD/SAVE PROJECTS -------------------

final saveProfileProvider = FutureProvider.family<String, ProfileSaveRequest>((ref, req) async {
  print("POST /profiles/save payload: ${jsonEncode({
  "profile_name": req.profileName,
  "description": req.description,
  "data": req.data,
  "username": req.username,
})}");
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
    return json["saved_profile"];
    
  } else {
    throw Exception("Failed to save profile");
  }
  
});

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

// ------------------- POST (THE REQUEST) LOG IN AUTHENTICATION -------------------
final signUpAuth = FutureProvider.family<String, SignUpParameters>((ref, req) async {
  print("Log in fields: ${jsonEncode({
  "username": req.profileName,
  "password": req.password,

})}");
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/auth/signup'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "username": req.profileName,
      "password": req.password,
    }),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    ref.invalidate(productsProvider);
    return json["sign_up"];
    
  } else {
    throw Exception("Failed to sign up");
  }
  
});

class SignUpParameters {
  final String profileName;
  final String password;
  SignUpParameters({
    required this.profileName,
    required this.password,
  });
}


// ------------------- DELETE PROJECTS -------------------
class ProfileService {
  final String baseUrl;

  ProfileService(this.baseUrl);

  Future<bool> deleteProfile(String profileName) async {
    final url = Uri.parse('http://127.0.0.1:8000/profiles/delete/$profileName');

    final response = await http.delete(url);

    if (response.statusCode == 200) return true;
    if (response.statusCode == 404) throw Exception("Profile not found");

    throw Exception("Failed: ${response.statusCode}");
  }
}

final profileServiceProvider = Provider((ref) {
  
  return ProfileService("http://127.0.0.1:8000");
});

final deleteProfileProvider = AsyncNotifierProvider<DeleteProfileNotifier, void>(() {
  return DeleteProfileNotifier();
});

class DeleteProfileNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> delete(String name) async {
    state = const AsyncLoading();

    try {
      final service = ref.read(profileServiceProvider);
      await service.deleteProfile(name);

      ref.invalidate(productsProvider);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}







