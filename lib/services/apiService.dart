import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos_frontend/models/chartModel/chartEntity.dart';
import 'package:pos_frontend/models/loginModel/loginEntity.dart';
import 'package:pos_frontend/models/salesModel/salesModel.dart';
import 'package:pos_frontend/models/signupModel/signupEntity.dart';
import 'package:pos_frontend/models/dashboardModel/dashboardEntity.dart';
import 'package:pos_frontend/models/categoryModel/categoryEntity.dart';
import 'package:pos_frontend/models/inventoryModel/inventoryEntity.dart';
import 'package:pos_frontend/models/invoiceModel/invoiceEntity.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // local host server
  // static const String baseUrl = 'http://127.0.0.1:8000';

  // If using Android Emulator
  static const String baseUrl =
      'http://10.0.2.2:8000'; // This maps to 127.0.0.1 on your host machine

  // If using iOS Simulator
  // static const String baseUrl = 'http://127.0.0.1:8000';

  // If using physical device
  // static const String baseUrl = 'http://192.168.50.186:8000';

  String? _accessToken; // Add this to store the token
  String? _userName; // Add this

  // Method to set token after login
  void setAccessToken(String token) {
    _accessToken = token;
    print('-----Token set in ApiService: $_accessToken'); // Debug print
  }

  String? get accessToken => _accessToken; // Getter for token

  // Add getter
  String get userName => _userName ?? 'User';

  // SignUp API call
  Future<http.Response> signup(SignupEntity signupData) async {
    final url = Uri.parse('$baseUrl/auth/signup');
    final requestBody = jsonEncode(signupData.toJson());

    print('-----Attempting to connect to: $url----');
    print('-----Request body (detailed)----');
    print(JsonEncoder.withIndent('  ')
        .convert(signupData.toJson())); // Pretty print JSON

    // Add validation check
    if (signupData.name.isEmpty ||
        signupData.userName.isEmpty ||
        signupData.email.isEmpty ||
        signupData.password.isEmpty) {
      print('-----Validation Error: Required fields are empty----');
    }

    try {
      final response = await http.post(
        url,
        body: requestBody,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('-----Response status code----${response.statusCode}');
      print('-----Response body (detailed)----');
      print(response.body); // This will show the validation errors from backend
      return response;
    } catch (e) {
      print('-----Error during API call----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }

  // Login API call
  Future<http.Response> login(LoginEntity loginData) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final requestBody = jsonEncode(loginData.toJson());

    print('-----Attempting to connect to: $url----');
    print('-----Request body (detailed)----');
    print(JsonEncoder.withIndent('  ').convert(loginData.toJson()));

    try {
      final response = await http.post(
        url,
        body: requestBody,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        _userName = data['name']; // Add this line
        setAccessToken(data['access_token']); // Store the token
        print('-----Access Token----$_accessToken');
        print('-----Token stored successfully----');

        // Verify token is stored
        if (_accessToken == null) {
          throw Exception('Failed to store access token');
        }
      }

      return response;
    } catch (e) {
      print('-----Error during API call----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }

  Future<http.Response> getUserProfile() async {
    final url = Uri.parse('$baseUrl/auth/profile');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );
      print('-----Profile Response status code----${response.statusCode}');
      print('-----Profile Response body----${response.body}');
      return response;
    } catch (e) {
      print('-----Error fetching profile----');
      print('Error details: $e');
      rethrow;
    }
  }

  Future<http.Response> refreshToken(String refreshToken) async {
    final url = Uri.parse('$baseUrl/auth/refresh');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );
      return response;
    } catch (e) {
      print('-----Error refreshing token----');
      print('Error details: $e');
      rethrow;
    }
  }

  Future<http.Response> logout() async {
    final url = Uri.parse('$baseUrl/auth/logout');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );
      return response;
    } catch (e) {
      print('-----Error during logout----');
      print('Error details: $e');
      rethrow;
    }
  }

  // Protected route API call
  Future<http.Response> getProtectedData() async {
    final url = Uri.parse('$baseUrl/protected-route');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );
      print(
          '-----Protected Route Response status code----${response.statusCode}');
      print('-----Protected Route Response body----${response.body}');
      return response;
    } catch (e) {
      print('-----Error accessing protected route----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }

  Future<DashboardEntity> getDashboardData() async {
    final url = Uri.parse('$baseUrl/dashboard/summary');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      print('-----Making dashboard request to: $url----');
      print('-----Making dashboard request with token: $_accessToken----');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      print('-----Dashboard Response Status: ${response.statusCode}----');
      print('-----Dashboard Response Body: ${response.body}----');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DashboardEntity.fromJson(data);
      } else {
        throw Exception('Failed to load dashboard data: ${response.body}');
      }
    } catch (e) {
      print('-----Error fetching dashboard data----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }

  // Future<DashboardChartEntity> getDashboardChartData() async {
  //   final url = Uri.parse('$baseUrl/dashboard/chart-data');
  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $_accessToken',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       print('Chart Data Response: ${response.body}'); // Debug print
  //       final Map<String, dynamic> jsonData = json.decode(response.body);
  //       print(
  //           "dashboard chart entity: ${DashboardChartEntity.fromJson(jsonData)}");
  //       return DashboardChartEntity.fromJson(jsonData);
  //     } else {
  //       print('Error response: ${response.body}'); // Debug print
  //       throw Exception('Failed to load dashboard chart data');
  //     }
  //   } catch (e) {
  //     print('Error fetching chart data: $e'); // Debug print
  //     throw Exception('Error fetching dashboard chart data: $e');
  //   }
  // }

  Future<DashboardChartEntity> getDashboardChartData() async {
    try {
      print('Fetching chart data from: ${baseUrl}/dashboard/chart-data');
      print(
          'Using token: $accessToken'); // Be careful with logging tokens in production

      final response = await http.get(
        Uri.parse('${baseUrl}/dashboard/chart-data'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print('Parsed JSON data: $jsonData');

        return DashboardChartEntity.fromJson(jsonData);
      } else {
        print('Error status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception(
            'Server returned ${response.statusCode}: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Detailed error: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Error fetching dashboard chart data: $e');
    }
  }

  Future<List<CategoryEntity>> getCategories() async {
    final url = Uri.parse('$baseUrl/products/categories');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      print('Categories API Response Status: ${response.statusCode}');
      print('Categories API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Parsed JSON data: $data');

        final categories = data.map((json) {
          print('Processing category JSON: $json');
          final category = CategoryEntity.fromJson(json);
          print('Created CategoryEntity: ${category.toString()}');
          return category;
        }).toList();

        print('Final categories list: $categories');
        return categories;
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  Future<void> addCategory(String name) async {
    final url = Uri.parse('$baseUrl/products/categories');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      print('-----Making add category request to: $url----');
      print('-----Request body: {"name": "$name"}----');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode({'name': name}),
      );

      print('-----Add Category Response Status: ${response.statusCode}----');
      print('-----Add Category Response Body: ${response.body}----');

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to add category: ${response.body}');
      }
    } catch (e) {
      print('-----Error adding category----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }

  Future<void> updateCategory(int id, String name) async {
    final url = Uri.parse('$baseUrl/products/categories/$id');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      print('-----Making update category request to: $url----');
      print('-----Request body: {"name": "$name"}----');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode({'name': name}),
      );

      print('-----Update Category Response Status: ${response.statusCode}----');
      print('-----Update Category Response Body: ${response.body}----');

      if (response.statusCode != 200) {
        throw Exception('Failed to update category: ${response.body}');
      }
    } catch (e) {
      print('-----Error updating category----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }

  Future<void> deleteCategory(int id) async {
    final url = Uri.parse('$baseUrl/products/categories/$id');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      print('-----Making delete category request to: $url----');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      print('-----Delete Category Response Status: ${response.statusCode}----');
      print('-----Delete Category Response Body: ${response.body}----');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete category: ${response.body}');
      }
    } catch (e) {
      print('-----Error deleting category----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }

  // Inventory API Methods
  Future<List<InventoryEntity>> getInventory() async {
    final url = Uri.parse('$baseUrl/products/products');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      print('-----Making inventory request to: $url----');
      print('-----Making inventory request with token: $_accessToken----');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      print('-----Inventory Response Status: ${response.statusCode}----');
      print('-----Inventory Response Body: ${response.body}----');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final products =
            data.map((json) => InventoryEntity.fromJson(json)).toList();
        print('-----Parsed Products: $products----');
        return products;
      } else {
        throw Exception('Failed to load inventory: ${response.body}');
      }
    } catch (e) {
      print('-----Error fetching inventory----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }

  Future<void> addProduct(
    String name,
    double price,
    double costPrice,
    int quantity,
    int categoryId,
  ) async {
    final url = Uri.parse('$baseUrl/products/products');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      final body = {
        'name': name,
        'price': price,
        'cost_price': costPrice,
        'quantity': quantity,
        'category_id': categoryId,
      };

      print('-----Making add product request to: $url----');
      print('-----Request body: $body----');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode(body),
      );
      print('-----Add Product Response Status: ${response.statusCode}----');
      print('-----Add Product Response Body: ${response.body}----');

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to add product: ${response.body}');
      }
    } catch (e) {
      print('-----Error adding product----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(
    int id,
    String name,
    double price,
    double costPrice,
    int quantity,
    int categoryId,
  ) async {
    final url = Uri.parse('$baseUrl/products/products/$id');
    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }
      final body = {
        'name': name,
        'price': price,
        'cost_price': costPrice,
        'quantity': quantity,
        'category_id': categoryId,
      };
      print('-----Making update product request to: $url----');
      print('-----Request body: $body----');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode(body),
      );
      print('-----Update Product Response Status: ${response.statusCode}----');
      print('-----Update Product Response Body: ${response.body}----');
      if (response.statusCode != 200) {
        throw Exception('Failed to update product: ${response.body}');
      }
    } catch (e) {
      print('-----Error updating product----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    final url = Uri.parse('$baseUrl/products/products/$id');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      print('-----Making delete product request to: $url----');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      print('-----Delete Product Response Status: ${response.statusCode}----');
      print('-----Delete Product Response Body: ${response.body}----');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete product: ${response.body}');
      }
    } catch (e) {
      print('-----Error deleting product----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }

  Future<List<InventoryEntity>> getProducts() async {
    final url = Uri.parse('$baseUrl/products/products');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      print('Products API Response Status: ${response.statusCode}');
      print('Products API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => InventoryEntity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<void> addSales(SalesEntity sales) async {
    final url = Uri.parse('$baseUrl/sales/sales');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      print('-----Making add sales request to: $url----');
      print('-----Request body: ${sales.toJson()}----');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode(sales.toJson()),
      );

      print('-----Add Sales Response Status: ${response.statusCode}----');
      print('-----Add Sales Response Body: ${response.body}----');

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to add sales: ${response.body}');
      }
    } catch (e) {
      print('-----Error adding sales----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }

  Future<List<InventoryEntity>> getLowStockProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/low-stock'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => InventoryEntity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load low stock products');
      }
    } catch (e) {
      print('Error fetching low stock products: $e');
      throw Exception('Error fetching low stock products: $e');
    }
  }
}
