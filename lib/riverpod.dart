import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';


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
    );
  }
}


final metaOptionsProvider = FutureProvider<MetaOptions>((ref) async {
  final isLoggedIn = ref.watch(isLoggedInProvider);

  if (!isLoggedIn) {
    throw Exception("Not logged in");
  }

  final token = await ref.watch(tokenProvider.future);

  const url = 'http://127.0.0.1:8000/meta/options';
  final res = await http.get(
    Uri.parse(url),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  if (res.statusCode != 200) {
    throw Exception('Failed to load meta options');
  }

  final jsonMap = jsonDecode(res.body);
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
    'upstream_transport': {
      'endpoint': 'http://127.0.0.1:8000/calculate/sea_tanker',
      'apiKeys': {
        "Vehicle": "vehicle_type",
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

        subtotal += (json["materialacq_emission"] ?? 0).toDouble();
        subtotal += (json["total_emission_kgco2e"] ?? 0).toDouble();
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
      case 'upstream_transport':
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
  final response = await authedRequestWithRetry((token) {
    return http.get(
      Uri.parse('http://127.0.0.1:8000/profiles'),
      headers: {"Authorization": "Bearer <token>",
      "Content-Type": "application/json",

      },
    );
  });

  if (response.statusCode == 200) {
    final Map<String, dynamic> map = jsonDecode(response.body);
    final List<dynamic> rawList = map["profiles"];
    return rawList.map((item) => Product.fromJson(item)).toList();
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized – please log in again");
  } else {
    throw Exception('Failed to load products: ${response.statusCode}');
  }
}

final productsProvider = FutureProvider<List<Product>>((ref) async {
  return fetchProducts();
});


// ------------------- ADD/SAVE PROJECTS -------------------
final saveProfileProvider =
    FutureProvider.family<String, ProfileSaveRequest>((ref, req) async {
  final response = await authedRequestWithRetry((token) {
    return http.post(
      Uri.parse('http://127.0.0.1:8000/profiles/save'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "profile_name": req.profileName,
        "description": req.description,
        "data": req.data,
      }),
    );
  });

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    ref.invalidate(productsProvider);
    return json["saved_profile"];
  } else {
    throw Exception("Failed to save profile: ${response.body}");
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


// ------------------- POST (THE REQUEST) SIGN UP AUTHENTICATION -------------------
final signUpAuth = FutureProvider.family<String, SignUpParameters>((ref, req) async {
  print("Sign up fields: ${jsonEncode({
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
    return json["username"];
    
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


// ------------------- POST (THE REQUEST) LOG IN AUTHENTICATION -------------------
final logInAuth = FutureProvider.family<String, LoginParameters>((ref, req) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/auth/login'),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: {
      "username": req.profileName,
      "password": req.password,
    },
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);

    final access = json["access_token"] as String;
    final refresh = json["refresh_token"] as String;

    await secureStorage.write(key: "access_token", value: access);
    await secureStorage.write(key: "refresh_token", value: refresh);

    ref.invalidate(productsProvider);
    return access;

  } else {
    debugLog("Login failed with status: ${response.statusCode}");
    throw Exception("Failed to log in");
  }
});

class LoginParameters {
  final String profileName;
  final String password;
  LoginParameters({
    required this.profileName,
    required this.password,
  });
}

final tokenProvider = FutureProvider<String?>((ref) async {
  final token = await secureStorage.read(key: "access_token");
  return token;
});

final isLoggedInProvider = Provider<bool>((ref) {
  final token = ref.watch(tokenProvider).value; // value is nullable String
  return token != null && token.isNotEmpty;
});

bool enableDebug = true; // toggle this anywhere in your app

void debugLog(String message) {
  if (enableDebug) {
    debugPrint("[DEBUG] $message");
  }
}

Future<String> refreshAccessToken() async {
  final refresh = await secureStorage.read(key: "refresh_token");
  if (refresh == null) throw Exception("No refresh token (logged out)");

  final res = await http.post(
    Uri.parse('http://127.0.0.1:8000/auth/refresh'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"refresh_token": refresh}),
  );

  print("Refresh response status: ${res.statusCode}"); // <-- print status
  print("Refresh response body: ${res.body}");    

  if (res.statusCode != 200) {
    // refresh invalid/expired/revoked -> force logout
    await secureStorage.delete(key: "access_token");
    await secureStorage.delete(key: "refresh_token");
    throw Exception("Session expired. Please log in again.");
  }

  final json = jsonDecode(res.body);
  final newAccess = json["access_token"] as String;

  await secureStorage.write(key: "access_token", value: newAccess);
  return newAccess;
}

Future<http.Response> authedRequestWithRetry(
  Future<http.Response> Function(String accessToken) doRequest,
) async {
  String? access = await secureStorage.read(key: "access_token");
  if (access == null) throw Exception("Not logged in");

  http.Response res = await doRequest(access);
  debugPrint("First request status = ${res.statusCode}");

  if (res.statusCode == 401) {
    debugPrint("Access expired -> refreshing...");
    final newAccess = await refreshAccessToken();
    res = await doRequest(newAccess);
    debugPrint("Retry status = ${res.statusCode}");
  }

  return res;
}


// ------------------- DELETE PROJECTS -------------------
class ProfileService {
  final String baseUrl;

  ProfileService(this.baseUrl);

  Future<bool> deleteProfile(String profileName) async {
    final url = Uri.parse('$baseUrl/profiles/delete/$profileName');

    final response = await authedRequestWithRetry((token) {
      return http.delete(
        url,
        headers: {"Authorization": "Bearer $token"},
      );
    });

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

final materialTableProvider =
    StateNotifierProvider<MaterialTableNotifier, MaterialTableState>(
        (ref) => MaterialTableNotifier());


// --------------- UPSTREAM TRANSPORT STATE -----------------
class UpstreamTransportTableState {
  final List<String?> vehicles;
  final List<String?> classes;
  final List<String?> distances;
  final List<String?> transportAllocationValues; // NEW COLUMN

  UpstreamTransportTableState({
    required this.vehicles,
    required this.classes,
    required this.distances,
    required this.transportAllocationValues,
  });

  UpstreamTransportTableState copyWith({
    List<String?>? vehicles,
    List<String?>? classes,
    List<String?>? distances,
    List<String?>? transportAllocationValues,
  }) {
    return UpstreamTransportTableState(
      vehicles: vehicles ?? this.vehicles,
      classes: classes ?? this.classes,
      distances: distances ?? this.distances,
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
            transportAllocationValues: [''], // NEW
          ),
        );

  void addRow() {
    state = state.copyWith(
      vehicles: [...state.vehicles, ''],
      classes: [...state.classes, ''],
      distances: [...state.distances, ''],
      transportAllocationValues: [...state.transportAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.vehicles.length > 1) {
      state = state.copyWith(
        vehicles: state.vehicles.sublist(0, state.vehicles.length - 1),
        classes: state.classes.sublist(0, state.classes.length - 1),
        distances: state.distances.sublist(0, state.distances.length - 1),
        transportAllocationValues: state.transportAllocationValues.sublist(0, state.transportAllocationValues.length - 1),
      );
    }
  }

  void updateCell({
    required int row,
    required String column, // 'Material', 'Country', 'Mass', 'Notes'
    required String? value,
  }) {
    final vehicles = [...state.vehicles];
    final classes = [...state.classes];
    final distances = [...state.distances];
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
      case 'Allocation Value':
        transportAllocationValues[row] = value;
        break;
    }

    state = state.copyWith(
      vehicles: vehicles,
      classes: classes,
      distances: distances,
      transportAllocationValues: transportAllocationValues,
    );
  }
}

final upstreamTransportTableProvider =
    StateNotifierProvider<UpstreamTransportTableNotifier, UpstreamTransportTableState>(
        (ref) => UpstreamTransportTableNotifier());



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
    StateNotifierProvider<MachiningTableNotifier, MachiningTableState>(
  (ref) => MachiningTableNotifier(),
);


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
    StateNotifierProvider<FugitiveLeaksTableNotifier, FugitiveLeaksTableState>(
  (ref) => FugitiveLeaksTableNotifier(),
);
