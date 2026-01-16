import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';

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
  final List<String?> waste;
  final List<String?> mass;
  final List<String?> wasteAllocationValues; 

  WastesTableState({
    required this.wasteType,
    required this.waste,
    required this.mass,
    required this.wasteAllocationValues,
  });

  WastesTableState copyWith({
    List<String?>? wasteType,
    List<String?>? waste,
    List<String?>? mass,
    List<String?>? wasteAllocationValues,
  }) {
    return WastesTableState(
      wasteType: wasteType ?? this.wasteType,
      waste: waste ?? this.waste,
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
            waste: [''],
            mass: [''],
            wasteAllocationValues: [''],
          ),
        );

  void addRow() {
    state = state.copyWith(
      wasteType: [...state.wasteType, ''],
      waste: [...state.waste, ''],
      mass: [...state.mass, ''],
      wasteAllocationValues: [...state.wasteAllocationValues, ''],
    );
  }

  void removeRow() {
    if (state.wasteType.length > 1) {
      state = state.copyWith(
        wasteType: state.wasteType.sublist(0, state.wasteType.length - 1),
        waste: state.waste.sublist(0, state.waste.length - 1),
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
    final waste = [...state.waste];
    final mass = [...state.mass];
    final wasteAllocationValues = [...state.wasteAllocationValues];

    switch (column) {
      case 'Waste Type':
        wasteType[row] = value;
        break;
      case 'Waste Material':
        waste[row] = value;
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
      waste: waste,
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


// -----------------DOWNSTREAM TRANSPORT--------
class DownstreamTransportTableState {
  final List<String?> vehicles;
  final List<String?> classes;
  final List<String?> distances;
  final List<String?> masses;
  final List<String?> transportAllocationValues; // NEW COLUMN

  DownstreamTransportTableState({
    required this.vehicles,
    required this.classes,
    required this.distances,
    required this.masses,
    required this.transportAllocationValues,
  });

  DownstreamTransportTableState copyWith({
    List<String?>? vehicles,
    List<String?>? classes,
    List<String?>? distances,
    List<String?>? masses,
    List<String?>? transportAllocationValues,
  }) {
    return DownstreamTransportTableState(
      vehicles: vehicles ?? this.vehicles,
      classes: classes ?? this.classes,
      distances: distances ?? this.distances,
      masses: masses ?? this.masses,
      transportAllocationValues: transportAllocationValues ?? this.transportAllocationValues,
    );
  }
}

class DownstreamTransportTableNotifier extends StateNotifier<DownstreamTransportTableState> {
  DownstreamTransportTableNotifier()
      : super(
          DownstreamTransportTableState(
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
