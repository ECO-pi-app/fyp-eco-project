import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/app_logic/river_controls.dart';
import 'dart:convert';
import 'package:test_app/app_logic/riverpod_calculation.dart';
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

  // <-- factory accepts two parameters: name (key) and value (map)
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



// ------------------- PRODUCTS PROVIDER -------------------
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
