import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test_app/app_logic/river_controls.dart';
import 'package:test_app/app_logic/riverpod_account.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
import 'package:test_app/app_logic/riverpod_states.dart';

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
  final double downstreamTransport;
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
    this.downstreamTransport = 0,
    this.waste = 0,
    this.usageCycle = 0,
    this.endofLife = 0,
  });

    EmissionResults operator *(double factor) {
    return EmissionResults(
      materialNormal: materialNormal * factor,
      material: material * factor,
      transport: transport * factor,
      machining: machining * factor,
      fugitive: fugitive * factor,
      productionTransport: productionTransport * factor,
      downstreamTransport: downstreamTransport * factor,
      waste: waste * factor,
      usageCycle: usageCycle * factor,
      endofLife: endofLife * factor,
    );
  }


  factory EmissionResults.empty() => const EmissionResults();

  EmissionResults copyWith({
    double? materialNormal,
    double? material,
    double? transport,
    double? machining,
    double? fugitive,
    double? productionTransport,
    double? downstreamTransport,
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
        downstreamTransport: downstreamTransport ?? this.downstreamTransport,
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
      downstreamTransport: (downstreamTransport) + (other.downstreamTransport),
      waste: (waste) + (other.waste),
      usageCycle: (usageCycle) + (other.usageCycle),
      endofLife: (endofLife) + (other.endofLife),
    );
  }


  double get total =>
      (materialNormal ?? 0.0) +
      (material ?? 0.0) +
      (transport ?? 0.0) +
      (machining ?? 0.0) +
      (fugitive ?? 0.0) +
      (productionTransport ?? 0.0) +
      (waste ?? 0.0) +
      (usageCycle ?? 0.0) +
      (endofLife ?? 0.0);
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
    Provider.family<EmissionResults, (String, String)>((ref, args) {
  final (productId, partId) = args;
  final calc = ref.watch(emissionCalculatorProvider(productId));
  debugPrint("[emissionTotalsProvider] totalsByPart keys: ${calc.totalsByPart.keys}");
  return calc.totalsByPart[partId] ?? EmissionResults.empty();
});


final timelineTotalProvider = Provider.family<double, (Product product, String timeline)>(
  (ref, args) {
    final (product, timeline) = args;

    final parts = ref
        .watch(pieChartProvider((product: product, timeline: timeline)))
        .parts;

    double sum = 0;

    for (final part in parts) {
      final result = ref.watch(convertedEmissionsTotalProvider((product, part)));
      sum += result.total;
    }

    return sum;
  },
);


/// ---------------- CONVERTED EMISSIONS PER PART ----------------
enum EmissionCategory {
  materialNormal,
  material,
  transportUpstream,
  machining,
  fugitive,
  productionTransport,
  transportDownstream,
  waste,
  usageCycle,
  endOfLife,
}

final convertedEmissionRowProvider = Provider.family<
    EmissionResults,
    (String productId, String partId, EmissionCategory cat, int rowIndex)>(
  (ref, args) {
    final (productId, partId, cat, i) = args;
    final factor = ref.watch(unitConversionProvider);
    final key = (product: productId, part: partId);

    double getAlloc(List<String?> list) {
      if (i >= list.length) return 0;
      return (double.tryParse(list[i] ?? '0') ?? 0) / 100;
    }

    EmissionResults base;

    switch (cat) {
      case EmissionCategory.materialNormal:
        final rows =
            ref.watch(normalMaterialEmissionRowsProvider(key));
        final allocs = ref
            .watch(normalMaterialTableProvider(key))
            .materialAllocationValues;
        if (i >= rows.length) return EmissionResults.empty();

        base = EmissionResults(
          materialNormal:
              rows[i].materialNormal * getAlloc(allocs),
        );
        break;

      case EmissionCategory.material:
        final rows =
            ref.watch(materialEmissionRowsProvider(key));
        final allocs = ref
            .watch(materialTableProvider(key))
            .materialAllocationValues;
        if (i >= rows.length) return EmissionResults.empty();

        base = EmissionResults(
          material: rows[i].material * getAlloc(allocs),
        );
        break;

      case EmissionCategory.transportUpstream:
        final rows =
            ref.watch(transportEmissionRowsProvider(key));
        final allocs = ref
            .watch(upstreamTransportTableProvider(key))
            .transportAllocationValues;
        if (i >= rows.length) return EmissionResults.empty();

        base = EmissionResults(
          transport: rows[i].transport * getAlloc(allocs),
        );
        break;

      case EmissionCategory.machining:
        final rows =
            ref.watch(machiningEmissionRowsProvider(key));
        final allocs = ref
            .watch(machiningTableProvider(key))
            .machiningAllocationValues;
        if (i >= rows.length) return EmissionResults.empty();

        base = EmissionResults(
          machining: rows[i].machining * getAlloc(allocs),
        );
        break;

      case EmissionCategory.fugitive:
        final rows =
            ref.watch(fugitiveEmissionRowsProvider(key));
        final allocs = ref
            .watch(fugitiveLeaksTableProvider(key))
            .fugitiveAllocationValues;
        if (i >= rows.length) return EmissionResults.empty();

        base = EmissionResults(
          fugitive: rows[i].fugitive * getAlloc(allocs),
        );
        break;

      case EmissionCategory.productionTransport:
        final rows =
            ref.watch(productionTransportEmissionRowsProvider(key));
        final allocs = ref
            .watch(productionTransportTableProvider(key))
            .transportAllocationValues;
        if (i >= rows.length) return EmissionResults.empty();

        base = EmissionResults(
          productionTransport:
              rows[i].productionTransport * getAlloc(allocs),
        );
        break;

      case EmissionCategory.transportDownstream:
        final rows =
            ref.watch(downstreamTransportEmissionRowsProvider(key));
        final allocs = ref
            .watch(downstreamTransportTableProvider(key))
            .transportAllocationValues;
        if (i >= rows.length) return EmissionResults.empty();

        base = EmissionResults(
          downstreamTransport:
              rows[i].downstreamTransport *
                  getAlloc(allocs),
        );
        break;

      case EmissionCategory.waste:
        final rows =
            ref.watch(wasteEmissionRowsProvider(key));
        final allocs = ref
            .watch(wastesProvider(key))
            .wasteAllocationValues;
        if (i >= rows.length) return EmissionResults.empty();

        base = EmissionResults(
          waste: rows[i].waste * getAlloc(allocs),
        );
        break;

      case EmissionCategory.usageCycle:
        final rows =
            ref.watch(usageCycleEmissionRowsProvider(key));
        final allocs = ref
            .watch(usageCycleTableProvider(key))
            .usageCycleAllocationValues;
        if (i >= rows.length) return EmissionResults.empty();

        base = EmissionResults(
          usageCycle:
              rows[i].usageCycle * getAlloc(allocs),
        );
        break;

      case EmissionCategory.endOfLife:
        final rows =
            ref.watch(endOfLifeEmissionRowsProvider(key));
        final allocs = ref
            .watch(endOfLifeTableProvider(key))
            .endOfLifeAllocationValues;
        if (i >= rows.length) return EmissionResults.empty();

        base = EmissionResults(
          endofLife:
              rows[i].endofLife * getAlloc(allocs),
        );
        break;
    }

    return base * factor;
  },
);


final convertedEmissionsTotalProvider =
    Provider.family<EmissionResults, (Product, String)>(
  (ref, args) {
    final (productId, partId) = args;

    EmissionResults total = EmissionResults.empty();

    for (final cat in EmissionCategory.values) {
      int i = 0;
      while (true) {
        final row = ref.watch(
          convertedEmissionRowProvider(
            (productId.name, partId, cat, i),
          ),
        );

        if (row == EmissionResults.empty()) break;

        total += row;
        i++;
      }
    }

    return total;
  },
);


/// ---------------- EMISSION CALCULATOR ----------------
class EmissionCalculator
    extends StateNotifier<EmissionCalculatorState> {
  EmissionCalculator() : super(const EmissionCalculatorState());

  final Map<String, Map<String, dynamic>> _config = {
    'material': {
      'endpoint':
          'http://127.0.0.1:8000/calculate/material_emission',
      'apiKeys': {
        "Country": "country",
        "Material": "material",
        "Mass (kg)": "mass_kg",
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
          'http://127.0.0.1:8000/calculate/machine_power_emission_Amada',
      'apiKeys': {
        "Brand": "machine_brand",
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
        "Waste Material": "waste_type",
        "Mass (kg)": "mass_kg",
      }
    },
    'downstream_transport': {
      'endpoint': 'http://127.0.0.1:8000/calculate/type_here',
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
        "Product" : "usage_type",
        "Usage Frequency": "amount",
      }
    },
    'end_of_life': {
      'endpoint': 'http://127.0.0.1:8000/calculate/end_of_life',
      'apiKeys': {
        "End of Life Option": "activity",
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

    final Map<String, String> _usageEndpoints = {
    'Electronics': 'http://127.0.0.1:8000/calculate/usage/electronics',
    'Energy': 'http://127.0.0.1:8000/calculate/usage/energy',
    'Consumables': 'http://127.0.0.1:8000/calculate/usage/consumables',
    'Services': 'http://127.0.0.1:8000/calculate/usage/services',
  };

  final Map<String, String> _wasteEndpoints = {
  'Municipal Solid Waste (MSW)': 'http://127.0.0.1:8000/calculate/waste/msw',
  'Industrial & Process Waste': 'http://127.0.0.1:8000/calculate/waste/industrial',
  'Construction & Demolition Waste': 'http://127.0.0.1:8000/calculate/waste/construction',
  'Hazardous Waste': 'http://127.0.0.1:8000/calculate/waste/hazardous',
  'Organic Waste': 'http://127.0.0.1:8000/calculate/waste/organic',
  'Material-specific Waste': 'http://127.0.0.1:8000/calculate/waste/material',
  'Energy-related Waste': 'http://127.0.0.1:8000/calculate/waste/energy',
  };

  final Map<String, String> _machinesBrandEndpoints = {
    'Amada': 'http://127.0.0.1:8000/calculate/machine_power_emission_Amada',
    'YCM': 'http://127.0.0.1:8000/calculate/machine_power_emission_ycm',
    'Mazak': 'http://127.0.0.1:8000/calculate/machine_power_emission_mazak',
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
    if (featureType.contains('usage_cycle')) {
      endpoint = _usageEndpoints[row.selections.first] ?? endpointDefault;
    }
    if (featureType.contains('waste')) {
      endpoint = _wasteEndpoints[row.selections.first] ?? endpointDefault;
    }
    if (featureType.contains('machining')) {
      endpoint = _machinesBrandEndpoints[row.selections.first] ?? endpointDefault;
    }

    double value = 0;
    try {
      debugPrint('API REQUEST [$featureType]');
      debugPrint('Row: $i');
      debugPrint('Endpoint: $endpoint');
      debugPrint('Payload: ${jsonEncode(payload)}');
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      debugPrint('API RESPONSE STATUS: ${response.statusCode}');
      debugPrint('API RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        value = (json["total_material_emissions"] ??
                json["total_transport_type_emission"] ??
                json["emissions_kgco2e"] ??
                json["materialacq_emission"] ??
                json["emissions"] ??
                json["usage_emissions"] ??
                json["end_of_life_emissions"] ??
                json["emission_kgco2e"] ??
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
      downstreamTransport: featureType == 'downstream_transport' ? value : existing.downstreamTransport,
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


// ----------------------PROVIDERS-----------------
typedef TableKey = ({String product, String part});

double _toDouble(String? value) => double.tryParse(value ?? '0') ?? 0.0;

/// ---------------- NORMAL MATERIAL ----------------
final normalMaterialTableProvider = StateNotifierProvider.family<
    NormalMaterialNotifier, NormalMaterialState, TableKey>((ref, key) {
  final notifier = NormalMaterialNotifier();

  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  if (product == null || timeline == null) return notifier;

  final timelineData = product.data["timelines"]?[timeline] as Map<String, dynamic>?;
  final partsMap = timelineData?["parts"] as Map<String, dynamic>?;

  if (partsMap != null) {
    final partData = partsMap[key.part] as Map<String, dynamic>?;

    final normalMaterials = partData?["normal_materials"]?["materials"] as List<dynamic>? ?? [];
    final countries = partData?["normal_materials"]?["countries"] as List<dynamic>? ?? [];
    final masses = partData?["normal_materials"]?["masses"] as List<dynamic>? ?? [];
    final allocationValues = partData?["normal_materials"]?["allocation_values"] as List<dynamic>? ?? [];

    notifier.state = NormalMaterialState(
      normalMaterials: normalMaterials.cast<String?>(),
      countries: countries.cast<String?>(),
      masses: masses.cast<String?>(),
      materialAllocationValues: allocationValues.cast<String?>(),
    );
  }

  return notifier;
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
    MaterialTableNotifier, MaterialTableState, TableKey>((ref, key) {
  final notifier = MaterialTableNotifier();

  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  if (product == null || timeline == null) return notifier;

  final timelineData = product.data["timelines"]?[timeline] as Map<String, dynamic>?;
  final partsMap = timelineData?["parts"] as Map<String, dynamic>?;

  if (partsMap != null) {
    final partData = partsMap[key.part] as Map<String, dynamic>?;
    final materials = partData?["materials"]?["materials"] as List<dynamic>? ?? [];
    final countries = partData?["materials"]?["countries"] as List<dynamic>? ?? [];
    final masses = partData?["materials"]?["masses"] as List<dynamic>? ?? [];
    final customEF = partData?["materials"]?["customEF"] as List<dynamic>? ?? [];
    final internalEF = partData?["materials"]?["internalEF"] as List<dynamic>? ?? [];
    final allocationValues = partData?["materials"]?["allocation_values"] as List<dynamic>? ?? [];

    notifier.state = MaterialTableState(
      materials: materials.cast<String?>(),
      countries: countries.cast<String?>(),
      masses: masses.cast<String?>(),
      customEF: customEF.cast<String?>(),
      internalEF: internalEF.cast<String?>(),
      materialAllocationValues: allocationValues.cast<String?>(),
    );
  }

  return notifier;
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
    StateNotifierProvider.family<UpstreamTransportTableNotifier, UpstreamTransportTableState, TableKey>((ref, key) {
  final notifier = UpstreamTransportTableNotifier();

  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  if (product == null || timeline == null) return notifier;

  final timelineData = product.data["timelines"]?[timeline] as Map<String, dynamic>?;
  final partsMap = timelineData?["parts"] as Map<String, dynamic>?;

  if (partsMap != null) {
    final partData = partsMap[key.part] as Map<String, dynamic>?;
    final vehicles = partData?["upstream_transport"]?["vehicles"] as List<dynamic>? ?? [];
    final classes = partData?["upstream_transport"]?["classes"] as List<dynamic>? ?? [];
    final distances = partData?["upstream_transport"]?["distances"] as List<dynamic>? ?? [];
    final masses = partData?["upstream_transport"]?["masses"] as List<dynamic>? ?? [];
    final allocationValues = partData?["upstream_transport"]?["allocation_values"] as List<dynamic>? ?? [];

    notifier.state = UpstreamTransportTableState(
      vehicles: vehicles.cast<String?>(),
      classes: classes.cast<String?>(),
      distances: distances.cast<String?>(),
      masses: masses.cast<String?>(),
      transportAllocationValues: allocationValues.cast<String?>(),
    );
  }

  return notifier;
});

final upstreamTransportAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(upstreamTransportTableProvider(key));
  return table.transportAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});

/// ---------------- MACHINING ----------------
final machiningTableProvider =
    StateNotifierProvider.family<MachiningTableNotifier, MachiningTableState, TableKey>((ref, key) {
  final notifier = MachiningTableNotifier();

  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  if (product == null || timeline == null) return notifier;

  final timelineData = product.data["timelines"]?[timeline] as Map<String, dynamic>?;
  final partsMap = timelineData?["parts"] as Map<String, dynamic>?;

  if (partsMap != null) {
    final partData = partsMap[key.part] as Map<String, dynamic>?;
    final brands = partData?["machining"]?["brands"] as List<dynamic>? ?? [];
    final machines = partData?["machining"]?["machines"] as List<dynamic>? ?? [];
    final countries = partData?["machining"]?["countries"] as List<dynamic>? ?? [];
    final times = partData?["machining"]?["times"] as List<dynamic>? ?? [];
    final allocationValues = partData?["machining"]?["allocation_values"] as List<dynamic>? ?? [];

    notifier.state = MachiningTableState(
      brands: brands.cast<String?>(),
      machines: machines.cast<String?>(),
      countries: countries.cast<String?>(),
      times: times.cast<String?>(),
      machiningAllocationValues: allocationValues.cast<String?>(),
    );
  }

  return notifier;
});

final machiningAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(machiningTableProvider(key));
  return table.machiningAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});

/// ---------------- WASTE ----------------
final wastesProvider =
    StateNotifierProvider.family<WastesTableNotifier, WastesTableState, TableKey>((ref, key) {
  final notifier = WastesTableNotifier();

  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  if (product == null || timeline == null) return notifier;

  final timelineData = product.data["timelines"]?[timeline] as Map<String, dynamic>?;
  final partsMap = timelineData?["parts"] as Map<String, dynamic>?;

  if (partsMap != null) {
    final partData = partsMap[key.part] as Map<String, dynamic>?;
    final wasteType = partData?["waste"]?["wasteType"] as List<dynamic>? ?? [];
    final waste = partData?["waste"]?["waste"] as List<dynamic>? ?? [];
    final mass = partData?["waste"]?["mass"] as List<dynamic>? ?? [];
    final allocationValues = partData?["waste"]?["allocation_values"] as List<dynamic>? ?? [];

    notifier.state = WastesTableState(
      wasteType: wasteType.cast<String?>(),
      waste: waste.cast<String?>(),
      mass: mass.cast<String?>(),
      wasteAllocationValues: allocationValues.cast<String?>(),
    );
  }

  return notifier;
});

final wasteAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(wastesProvider(key));
  return table.wasteAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});

/// ---------------- FUGITIVE ----------------
final fugitiveLeaksTableProvider =
    StateNotifierProvider.family<FugitiveLeaksTableNotifier, FugitiveLeaksTableState, TableKey>((ref, key) {
  final notifier = FugitiveLeaksTableNotifier();

  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  if (product == null || timeline == null) return notifier;

  final timelineData = product.data["timelines"]?[timeline] as Map<String, dynamic>?;
  final partsMap = timelineData?["parts"] as Map<String, dynamic>?;

  if (partsMap != null) {
    final partData = partsMap[key.part] as Map<String, dynamic>?;
    final ghg = partData?["fugitive"]?["ghg"] as List<dynamic>? ?? [];
    final totalCharge = partData?["fugitive"]?["totalCharge"] as List<dynamic>? ?? [];
    final remainingCharge = partData?["fugitive"]?["remainingCharge"] as List<dynamic>? ?? [];
    final allocationValues = partData?["fugitive"]?["allocation_values"] as List<dynamic>? ?? [];

    notifier.state = FugitiveLeaksTableState(
      ghg: ghg.cast<String?>(),
      totalCharge: totalCharge.cast<String?>(),
      remainingCharge: remainingCharge.cast<String?>(),
      fugitiveAllocationValues: allocationValues.cast<String?>(),
    );
  }

  return notifier;
});

final fugitiveAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(fugitiveLeaksTableProvider(key));
  return table.fugitiveAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});

/// ---------------- PRODUCTION TRANSPORT ----------------
final productionTransportTableProvider =
    StateNotifierProvider.family<ProductionTransportTableNotifier, ProductionTransportTableState, TableKey>((ref, key) {
  final notifier = ProductionTransportTableNotifier();

  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  if (product == null || timeline == null) return notifier;

  final timelineData = product.data["timelines"]?[timeline] as Map<String, dynamic>?;
  final partsMap = timelineData?["parts"] as Map<String, dynamic>?;

  if (partsMap != null) {
    final partData = partsMap[key.part] as Map<String, dynamic>?;
    final vehicles = partData?["production_transport"]?["vehicles"] as List<dynamic>? ?? [];
    final classes = partData?["production_transport"]?["classes"] as List<dynamic>? ?? [];
    final distances = partData?["production_transport"]?["distances"] as List<dynamic>? ?? [];
    final masses = partData?["production_transport"]?["masses"] as List<dynamic>? ?? [];
    final allocationValues = partData?["production_transport"]?["allocation_values"] as List<dynamic>? ?? [];

    notifier.state = ProductionTransportTableState(
      vehicles: vehicles.cast<String?>(),
      classes: classes.cast<String?>(),
      distances: distances.cast<String?>(),
      masses: masses.cast<String?>(),
      transportAllocationValues: allocationValues.cast<String?>(),
    );
  }

  return notifier;
});

final productionTransportAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(productionTransportTableProvider(key));
  return table.transportAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});

/// ---------------- DOWNSTREAM TRANSPORT ----------------
final downstreamTransportTableProvider =
    StateNotifierProvider.family<DownstreamTransportTableNotifier, DownstreamTransportTableState, TableKey>((ref, key) {
  final notifier = DownstreamTransportTableNotifier();

  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  if (product == null || timeline == null) return notifier;

  final timelineData = product.data["timelines"]?[timeline] as Map<String, dynamic>?;
  final partsMap = timelineData?["parts"] as Map<String, dynamic>?;

  if (partsMap != null) {
    final partData = partsMap[key.part] as Map<String, dynamic>?;
    final vehicles = partData?["downstream_transport"]?["vehicles"] as List<dynamic>? ?? [];
    final classes = partData?["downstream_transport"]?["classes"] as List<dynamic>? ?? [];
    final distances = partData?["downstream_transport"]?["distances"] as List<dynamic>? ?? [];
    final masses = partData?["downstream_transport"]?["masses"] as List<dynamic>? ?? [];
    final allocationValues = partData?["downstream_transport"]?["allocation_values"] as List<dynamic>? ?? [];

    notifier.state = DownstreamTransportTableState(
      vehicles: vehicles.cast<String?>(),
      classes: classes.cast<String?>(),
      distances: distances.cast<String?>(),
      masses: masses.cast<String?>(),
      transportAllocationValues: allocationValues.cast<String?>(),
    );
  }

  return notifier;
});

final downstreamTransportAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(downstreamTransportTableProvider(key));
  return table.transportAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});

/// ---------------- USAGE CYCLE ----------------
final usageCycleTableProvider =
    StateNotifierProvider.family<UsageCycleNotifier, UsageCycleState, TableKey>((ref, key) {
  final notifier = UsageCycleNotifier();

  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  if (product == null || timeline == null) return notifier;

  final timelineData = product.data["timelines"]?[timeline] as Map<String, dynamic>?;
  final partsMap = timelineData?["parts"] as Map<String, dynamic>?;

  if (partsMap != null) {
    final partData = partsMap[key.part] as Map<String, dynamic>?;
    final categories = partData?["usage_cycle"]?["categories"] as List<dynamic>? ?? [];
    final productTypes = partData?["usage_cycle"]?["productTypes"] as List<dynamic>? ?? [];
    final usageFrequencies = partData?["usage_cycle"]?["usageFrequencies"] as List<dynamic>? ?? [];
    final allocationValues = partData?["usage_cycle"]?["allocation_values"] as List<dynamic>? ?? [];

    notifier.state = UsageCycleState(
      categories: categories.cast<String?>(),
      productTypes: productTypes.cast<String?>(),
      usageFrequencies: usageFrequencies.cast<String?>(),
      usageCycleAllocationValues: allocationValues.cast<String?>(),
    );
  }

  return notifier;
});

final usageCycleAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(usageCycleTableProvider(key));
  return table.usageCycleAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});

/// ---------------- END OF LIFE ----------------
final endOfLifeTableProvider =
    StateNotifierProvider.family<EndOfLifeTableNotifier, EndOfLifeTableState, TableKey>((ref, key) {
  final notifier = EndOfLifeTableNotifier();

  final product = ref.watch(activeProductProvider);
  final timeline = ref.watch(activeTimelineProvider);
  if (product == null || timeline == null) return notifier;

  final timelineData = product.data["timelines"]?[timeline] as Map<String, dynamic>?;
  final partsMap = timelineData?["parts"] as Map<String, dynamic>?;

  if (partsMap != null) {
    final partData = partsMap[key.part] as Map<String, dynamic>?;
    final endOfLifeOptions = partData?["end_of_life"]?["endOfLifeOptions"] as List<dynamic>? ?? [];
    final totalMass = partData?["end_of_life"]?["totalMass"] as List<dynamic>? ?? [];
    final allocationValues = partData?["end_of_life"]?["allocation_values"] as List<dynamic>? ?? [];

    notifier.state = EndOfLifeTableState(
      endOfLifeOptions: endOfLifeOptions.cast<String?>(),
      endOfLifeTotalMass: totalMass.cast<String?>(),
      endOfLifeAllocationValues: allocationValues.cast<String?>(),
    );
  }

  return notifier;
});

final endOfLifeAllocationSumProvider =
    Provider.family<double, TableKey>((ref, key) {
  final table = ref.watch(endOfLifeTableProvider(key));
  return table.endOfLifeAllocationValues
      .map(_toDouble)
      .fold(0.0, (a, b) => a + b);
});


/// ---------------- NORMAL MATERIAL ----------------
final normalMaterialEmissionRowsProvider =
    Provider.family<List<EmissionResults>, TableKey>((ref, key) {
  final rows = ref.watch(emissionCalculatorProvider(key.product))
          .rowsByPart[key.part] ??
      [];
  return rows.map((r) => EmissionResults(materialNormal: r.materialNormal)).toList();
});

/// ---------------- MATERIAL ----------------
final materialEmissionRowsProvider =
    Provider.family<List<EmissionResults>, TableKey>((ref, key) {
  final rows = ref.watch(emissionCalculatorProvider(key.product))
          .rowsByPart[key.part] ??
      [];
  return rows.map((r) => EmissionResults(material: r.material)).toList();
});

/// ---------------- UPSTREAM TRANSPORT ----------------
final transportEmissionRowsProvider =
    Provider.family<List<EmissionResults>, TableKey>((ref, key) {
  final rows = ref.watch(emissionCalculatorProvider(key.product))
          .rowsByPart[key.part] ??
      [];
  return rows.map((r) => EmissionResults(transport: r.transport)).toList();
});

/// ---------------- MACHINING ----------------
final machiningEmissionRowsProvider =
    Provider.family<List<EmissionResults>, TableKey>((ref, key) {
  final rows = ref.watch(emissionCalculatorProvider(key.product))
          .rowsByPart[key.part] ??
      [];
  return rows.map((r) => EmissionResults(machining: r.machining)).toList();
});

/// ---------------- FUGITIVE ----------------
final fugitiveEmissionRowsProvider =
    Provider.family<List<EmissionResults>, TableKey>((ref, key) {
  final rows = ref.watch(emissionCalculatorProvider(key.product))
          .rowsByPart[key.part] ??
      [];
  return rows.map((r) => EmissionResults(fugitive: r.fugitive)).toList();
});

/// ---------------- PRODUCTION TRANSPORT ----------------
final productionTransportEmissionRowsProvider =
    Provider.family<List<EmissionResults>, TableKey>((ref, key) {
  final rows = ref.watch(emissionCalculatorProvider(key.product))
          .rowsByPart[key.part] ??
      [];
  return rows
      .map((r) => EmissionResults(productionTransport: r.productionTransport))
      .toList();
});

/// ---------------- DOWNSTREAM TRANSPORT ----------------
final downstreamTransportEmissionRowsProvider =
    Provider.family<List<EmissionResults>, TableKey>((ref, key) {
  final rows = ref.watch(emissionCalculatorProvider(key.product))
          .rowsByPart[key.part] ??
      [];
  return rows
      .map((r) => EmissionResults(downstreamTransport: r.downstreamTransport))
      .toList();
});

/// ---------------- WASTE ----------------
final wasteEmissionRowsProvider =
    Provider.family<List<EmissionResults>, TableKey>((ref, key) {
  final rows = ref.watch(emissionCalculatorProvider(key.product))
          .rowsByPart[key.part] ??
      [];
  return rows.map((r) => EmissionResults(waste: r.waste)).toList();
});

/// ---------------- USAGE CYCLE ----------------
final usageCycleEmissionRowsProvider =
    Provider.family<List<EmissionResults>, TableKey>((ref, key) {
  final rows = ref.watch(emissionCalculatorProvider(key.product))
          .rowsByPart[key.part] ??
      [];
  return rows.map((r) => EmissionResults(usageCycle: r.usageCycle)).toList();
});

/// ---------------- END OF LIFE ----------------
final endOfLifeEmissionRowsProvider =
    Provider.family<List<EmissionResults>, TableKey>((ref, key) {
  final rows = ref.watch(emissionCalculatorProvider(key.product))
          .rowsByPart[key.part] ??
      [];
  return rows.map((r) => EmissionResults(endofLife: r.endofLife)).toList();
});

