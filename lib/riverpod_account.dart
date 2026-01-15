import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/river_controls.dart';
import 'dart:convert';
import 'package:test_app/riverpod.dart';

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
