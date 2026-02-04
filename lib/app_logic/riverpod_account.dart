import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/app_logic/river_controls.dart';
import 'package:test_app/app_logic/riverpod_calculation.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
import 'dart:convert';
import 'package:test_app/app_logic/riverpod_states.dart';

// ------------------- PRODUCT MODEL -------------------
class Product {
  final String name;
  final String description;
  final Map<String, dynamic> data;

  Product({
    required this.name,
    required this.description,
    required this.data,
  });

  factory Product.fromJson(String name, Map<String, dynamic> value) {
    final desc = value["description"] ?? "";
    final dataMap = Map<String, dynamic>.from(value["data"] ?? {});

    debugPrint("[Product.fromJson] name: $name, description: $desc, data: $dataMap");

    return Product(
      name: name,
      description: desc,
      data: dataMap,
    );
  }
}

// ------------------- FETCH PRODUCTS -------------------
Future<List<Product>> fetchProducts(String username) async {
  final url = Uri.parse('http://127.0.0.1:8000/profiles?username=$username');
  debugPrint("[fetchProducts] Fetching products for username: $username");
  debugPrint("[fetchProducts] URL: $url"); // 👈 ADDED

  final response = await http.get(
    url,
    headers: {"Content-Type": "application/json"},
  );

  debugPrint("[fetchProducts] Status code: ${response.statusCode}");
  debugPrint("[fetchProducts] Response body: ${response.body}");

  if (response.statusCode != 200) {
    if (response.statusCode == 401) {
      debugPrint("[fetchProducts] Unauthorized — invalid username or expired token");
      throw Exception("Unauthorized – please log in again");
    }

    debugPrint("[fetchProducts] Failed with status: ${response.statusCode}");
    throw Exception('Failed to load products: ${response.statusCode}');
  }

  final decoded = jsonDecode(response.body);
  debugPrint("[fetchProducts] Decoded JSON: $decoded");

  final profiles = decoded["profiles"];

  // ---------------- FORMAT 1: New backend format (map) ----------------
  if (profiles is Map<String, dynamic>) {
    debugPrint("[fetchProducts] Detected MAP format for profiles");

    final products = profiles.entries.map((entry) {
      final name = entry.key;
      final value = Map<String, dynamic>.from(entry.value ?? {});

      debugPrint("[fetchProducts] Creating Product from MAP -> $name : $value");

      return Product.fromJson(name, value);
    }).toList();

    debugPrint(
      "[fetchProducts] Mapped products list (MAP): ${products.map((p) => "${p.name} -> ${p.description}").toList()}"
    );

    return products;
  }

  // ---------------- FORMAT 2: Old backend format (list) ----------------
  if (profiles is List) {
    debugPrint("[fetchProducts] Detected LIST format for profiles");

    final products = profiles.map((name) {
      debugPrint("[fetchProducts] Creating Product from LIST -> $name");

      return Product(
        name: name.toString(),
        description: "",
        data: <String, dynamic>{},
      );
    }).toList();

    debugPrint(
      "[fetchProducts] Mapped products list (LIST): ${products.map((p) => p.name).toList()}"
    );

    return products;
  }

  // ---------------- UNKNOWN FORMAT ----------------
  debugPrint("[fetchProducts] Unknown profiles format: ${profiles.runtimeType}");
  throw Exception("Unexpected profiles format from backend");
}


Future<Product> fetchProductDetail(String username, String productName) async {
  // Include username as a query parameter
  final url = Uri.parse(
    'http://127.0.0.1:8000/profiles/$productName?username=$username',
  );

  debugPrint("[fetchProductDetail] URL: $url");

  final response = await http.get(
    url,
    headers: {"Content-Type": "application/json"},
  );

  debugPrint("[fetchProductDetail] Status: ${response.statusCode}");
  debugPrint("[fetchProductDetail] Body: ${response.body}");

  if (response.statusCode != 200) {
    throw Exception(
        "Failed to load product detail: ${response.statusCode} ${response.reasonPhrase}");
  }

  final decoded = jsonDecode(response.body);

  debugPrint("[fetchProductDetail] Decoded JSON: $decoded");

  return Product.fromJson(productName, decoded);
}


// ------------------- PRODUCTS PROVIDER -------------------
final activeProductLoaderProvider = Provider<void>((ref) {
  ref.listen<String?>(
    activeProductProvider,
    (prev, next) async {
      if (next == null) return;

      final username = ref.read(usernameProvider).value;
      if (username == null) return;

      debugPrint("[activeProductLoader] Loading full product: $next");

      try {
        final product =
            await fetchProductDetail(username, next);

        debugPrint("[activeProductLoader] Loaded product data: ${product.data.keys}");

        // TODO: hydrate your timeline + parts providers here
      } catch (e) {
        debugPrint("[activeProductLoader] Failed: $e");
      }
    },
  );
});

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final username = await ref.watch(usernameProvider.future);
  debugPrint("[productsProvider] Username loaded from provider: $username");

  if (username == null || username.isEmpty) {
    debugPrint("[productsProvider] No username saved — cannot fetch products");
    throw Exception("No username saved — user is not logged in");
  }

  final products = await fetchProducts(username);
  debugPrint("[productsProvider] Fetched products: ${products.map((p) => p.name).toList()}");
  return products;
});

// ------------------- HYDRATE DESCRIPTIONS -------------------
final hydrateDescriptionsProvider = Provider<void>((ref) {
  final productsAsync = ref.watch(productsProvider);

  productsAsync.whenData((products) {
    final notifier = ref.read(productDescriptionProvider.notifier);

    for (final product in products) {
      final existingDesc = notifier.getDescription(product.name);
      if (existingDesc == null) {
        notifier.setDescription(product.name, product.description);
        debugPrint(
          "[hydrateDescriptions] Loaded description for '${product.name}': '${product.description}'"
        );
      } else {
        debugPrint(
          "[hydrateDescriptions] Description already exists for '${product.name}': '$existingDesc'"
        );
      }
    }
  });
});



// ---------------- PROFILE SAVE ----------------
Map<String, dynamic> collectProfileData(WidgetRef ref, TableKey key) {
  final product = ref.read(activeProductProvider);
  if (product == null) return {};

  // timelines and durations
  final timelineNames = ref.read(timelineProvider(product)).timelines;
  final allDurations = ref.read(timelineDurationProvider(product));

  final Map<String, dynamic> timelineData = {};

  for (var timeline in timelineNames) {
    // Get all parts for this timeline
    final partsList = ref.read(partsProvider); // reads parts based on active product & timeline
    // Temporarily set active timeline so partsProvider works
    ref.read(activeTimelineProvider.notifier).state = timeline;

    final Map<String, dynamic> partsData = {};

    for (var partName in partsList) {
      final partKey = (product: product, part: partName); // record literal

      partsData[partName] = {
        "normal_materials": {
          "materials": ref.read(normalMaterialTableProvider(partKey)).normalMaterials,
          "countries": ref.read(normalMaterialTableProvider(partKey)).countries,
          "masses": ref.read(normalMaterialTableProvider(partKey)).masses,
          "allocation_values": ref.read(normalMaterialTableProvider(partKey)).materialAllocationValues,
        },
        "materials": {
          "materials": ref.read(materialTableProvider(partKey)).materials,
          "countries": ref.read(materialTableProvider(partKey)).countries,
          "masses": ref.read(materialTableProvider(partKey)).masses,
          "custom_ef": ref.read(materialTableProvider(partKey)).customEF,
          "internal_ef": ref.read(materialTableProvider(partKey)).internalEF,
          "allocation_values": ref.read(materialTableProvider(partKey)).materialAllocationValues,
        },
        "upstream_transport": {
          "vehicles": ref.read(upstreamTransportTableProvider(partKey)).vehicles,
          "classes": ref.read(upstreamTransportTableProvider(partKey)).classes,
          "distances": ref.read(upstreamTransportTableProvider(partKey)).distances,
          "masses": ref.read(upstreamTransportTableProvider(partKey)).masses,
          "allocation_values": ref.read(upstreamTransportTableProvider(partKey)).transportAllocationValues,
        },
        "production_transport": {
          "vehicles": ref.read(productionTransportTableProvider(partKey)).vehicles,
          "classes": ref.read(productionTransportTableProvider(partKey)).classes,
          "distances": ref.read(productionTransportTableProvider(partKey)).distances,
          "masses": ref.read(productionTransportTableProvider(partKey)).masses,
          "allocation_values": ref.read(productionTransportTableProvider(partKey)).transportAllocationValues,
        },
        "downstream_transport": {
          "vehicles": ref.read(downstreamTransportTableProvider(partKey)).vehicles,
          "classes": ref.read(downstreamTransportTableProvider(partKey)).classes,
          "distances": ref.read(downstreamTransportTableProvider(partKey)).distances,
          "masses": ref.read(downstreamTransportTableProvider(partKey)).masses,
          "allocation_values": ref.read(downstreamTransportTableProvider(partKey)).transportAllocationValues,
        },
        "machining": {
          "brands": ref.read(machiningTableProvider(partKey)).brands,
          "machines": ref.read(machiningTableProvider(partKey)).machines,
          "countries": ref.read(machiningTableProvider(partKey)).countries,
          "times": ref.read(machiningTableProvider(partKey)).times,
          "allocation_values": ref.read(machiningTableProvider(partKey)).machiningAllocationValues,
        },
        "wastes": {
          "types": ref.read(wastesProvider(partKey)).wasteType,
          "wastes": ref.read(wastesProvider(partKey)).waste,
          "masses": ref.read(wastesProvider(partKey)).mass,
          "allocation_values": ref.read(wastesProvider(partKey)).wasteAllocationValues,
        },
        "fugitive_leaks": {
          "ghg": ref.read(fugitiveLeaksTableProvider(partKey)).ghg,
          "total_charge": ref.read(fugitiveLeaksTableProvider(partKey)).totalCharge,
          "remaining_charge": ref.read(fugitiveLeaksTableProvider(partKey)).remainingCharge,
          "allocation_values": ref.read(fugitiveLeaksTableProvider(partKey)).fugitiveAllocationValues,
        },
        "usage_cycle": {
          "categories": ref.read(usageCycleTableProvider(partKey)).categories,
          "product_types": ref.read(usageCycleTableProvider(partKey)).productTypes,
          "frequencies": ref.read(usageCycleTableProvider(partKey)).usageFrequencies,
          "allocation_values": ref.read(usageCycleTableProvider(partKey)).usageCycleAllocationValues,
        },
        "end_of_life": {
          "options": ref.read(endOfLifeTableProvider(partKey)).endOfLifeOptions,
          "total_mass": ref.read(endOfLifeTableProvider(partKey)).endOfLifeTotalMass,
          "allocation_values": ref.read(endOfLifeTableProvider(partKey)).endOfLifeAllocationValues,
        },
      };
    }

    // Save timeline info + all its parts
    timelineData[timeline] = {
      "start_month": allDurations[timeline]?["start"] ?? "",
      "end_month": allDurations[timeline]?["end"] ?? "",
      "parts": partsData,
    };
  }

  return {
    "product": product,
    "timelines": timelineData,
  };
}



// ------------------ SAVE REQUEST MODEL ------------------
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

  Map<String, dynamic> toJson() {
    return {
      "profile_name": profileName,
      "description": description,
      "data": data,
      "username": username,
    };
  }
}

// ------------------ SAVE PROVIDER ------------------
final saveProfileProvider =
    FutureProvider.family<String, ProfileSaveRequest>((ref, req) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/profiles/save'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(req.toJson()),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    ref.invalidate(productsProvider);
    return json["saved_profile"];
  } else {
    throw Exception("Failed to save profile: ${response.body}");
  }
});

Future<void> saveProfile(
  WidgetRef ref,
  String profileName,
  String description,
  String username,
  TableKey key,
) async {
  final data = collectProfileData(ref, key);
  final req = ProfileSaveRequest(
    profileName: profileName,
    description: description,
    data: data,
    username: username,
  );

  try {
    final savedProfile = await ref.read(saveProfileProvider(req).future);
    print("Saved profile: $savedProfile");
  } catch (e) {
    print("Error saving profile: $e");
  }
}


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

  debugPrint("Sign up payload: $payload");

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
