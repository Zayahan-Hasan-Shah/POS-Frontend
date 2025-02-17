import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pos_frontend/models/SupplierModel/supplierModel.dart';
import 'package:pos_frontend/models/chartModel/chartEntity.dart';
import 'package:pos_frontend/models/customerModel/customerEntity.dart';
import 'package:pos_frontend/models/invoiceModel/invoiceEntity.dart';
import 'package:pos_frontend/models/loginModel/loginEntity.dart';
import 'package:pos_frontend/models/salesModel/salesModel.dart';
import 'package:pos_frontend/models/salesModel/salesSummary.dart';
import 'package:pos_frontend/models/signupModel/signupEntity.dart';
import 'package:pos_frontend/models/dashboardModel/dashboardEntity.dart';
import 'package:pos_frontend/models/categoryModel/categoryEntity.dart';
import 'package:pos_frontend/models/inventoryModel/inventoryEntity.dart';
import 'package:pos_frontend/models/userModel/userModel.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // local host server
  // static const String baseUrl = 'http://127.0.0.1:8000';

  // If using Android Emulator
  // static const String baseUrl =
  //     'http://10.0.2.2:8000'; // This maps to 127.0.0.1 on your host machine

  // If using iOS Simulator
  // static const String baseUrl = 'http://127.0.0.1:8000';

  // If using physical device
  static const String baseUrl = 'http://192.168.50.216:8080';

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

  // Future<http.Response> getUserProfile() async {
  //   final url = Uri.parse('$baseUrl/auth/profile');

  //   try {
  //     if (_accessToken == null) {
  //       throw Exception('No access token available');
  //     }

  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $_accessToken',
  //       },
  //     );
  //     print('-----Profile Response status code----${response.statusCode}');
  //     print('-----Profile Response body----${response.body}');
  //     return response;
  //   } catch (e) {
  //     print('-----Error fetching profile----');
  //     print('Error details: $e');
  //     rethrow;
  //   }
  // }

  // Future<http.Response> getUserProfile() async {
  //   final url = Uri.parse('$baseUrl/auth/user');
  //   try {
  //     if (_accessToken == null) {
  //       throw Exception('No access available');
  //     }

  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $_accessToken',
  //       },
  //     );
  //     print('-----Profile Response status code----${response.statusCode}');
  //     print('-----Profile Response body----${response.body}');
  //     return response;
  //   } catch (e) {
  //     print('-----Error fetching profile----');
  //     print('Error details: $e');
  //     rethrow;
  //   }
  // }

  Future<UserEntity> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      print('Get profile response status: ${response.statusCode}');
      print('Get profile response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserEntity.fromJson(data);
      } else {
        throw Exception('Failed to get profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting profile: $e');
      rethrow;
    }
  }

  Future<UserEntity> updateProfile(UserEntity userUpdate) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: jsonEncode(userUpdate.toJson()),
      );

      print('Update profile response status: ${response.statusCode}');
      print('Update profile response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedUser = UserEntity.fromJson(data);
        // Update local user data
        _userName = updatedUser.name ?? _userName;
        return updatedUser;
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating profile: $e');
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

  // Future<http.Response> logout() async {
  //   final url = Uri.parse('$baseUrl/auth/logout');

  //   try {
  //     if (_accessToken == null) {
  //       throw Exception('No access token available');
  //     }

  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $_accessToken',
  //       },
  //     );
  //     return response;
  //   } catch (e) {
  //     print('-----Error during logout----');
  //     print('Error details: $e');
  //     rethrow;
  //   }
  // }

  void logout() {
    _accessToken = null; // Clear token
    _userName = null; // Clear username
    print('-----User Logged Out Successfully----');
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

  // Customer related methods
  Future<List<Customer>> getCustomers() async {
    final url = Uri.parse('$baseUrl/customers');

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

      print('Customers API Response Status: ${response.statusCode}');
      print('Customers API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Customer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load customers: ${response.body}');
      }
    } catch (e) {
      print('Error fetching customers: $e');
      rethrow;
    }
  }

  Future<Customer> getCustomer(int id) async {
    final url = Uri.parse('$baseUrl/customers/$id');

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

      if (response.statusCode == 200) {
        return Customer.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load customer: ${response.body}');
      }
    } catch (e) {
      print('Error fetching customer: $e');
      rethrow;
    }
  }

  Future<Customer> createCustomer(Customer customer) async {
    final url = Uri.parse('$baseUrl/customers/create-customer');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      print('-----Making create customer request to: $url----');
      print('-----Request body: ${customer.toJson()}----');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode(customer.toJson()),
      );

      print('-----Create Customer Response Status: ${response.statusCode}----');
      print('-----Create Customer Response Body: ${response.body}----');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Customer.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create customer: ${response.body}');
      }
    } catch (e) {
      print('Error creating customer: $e');
      rethrow;
    }
  }

  Future<Customer> updateCustomer(int id, Customer customer) async {
    final url = Uri.parse('$baseUrl/customers/single-customer/$id');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      print('-----Making update customer request to: $url----');
      print('-----Request body: ${customer.toJson()}----');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode(customer.toJson()),
      );

      print('-----Update Customer Response Status: ${response.statusCode}----');
      print('-----Update Customer Response Body: ${response.body}----');

      if (response.statusCode == 200) {
        return Customer.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update customer: ${response.body}');
      }
    } catch (e) {
      print('Error updating customer: $e');
      rethrow;
    }
  }

  Future<void> deleteCustomer(int id) async {
    final url = Uri.parse('$baseUrl/customers/delete-customer/$id');

    try {
      if (_accessToken == null) {
        throw Exception('No access token available');
      }

      print('-----Making delete customer request to: $url----');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      print('-----Delete Customer Response Status: ${response.statusCode}----');
      print('-----Delete Customer Response Body: ${response.body}----');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete customer: ${response.body}');
      }
    } catch (e) {
      print('Error deleting customer: $e');
      rethrow;
    }
  }

  Future<List<Supplier>> getSuppliers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/supplier/suppliers'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Supplier> suppliers =
            data.map((json) => Supplier.fromJson(json)).toList();
        return suppliers;
      } else {
        throw Exception('Failed to load suppliers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching suppliers: $e');
      rethrow;
    }
  }

  Future<Supplier> createSupplier(Supplier supplier) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/supplier/create-supplier'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode(supplier.toJson()),
      );

      if (response.statusCode == 200) {
        return Supplier.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create supplier');
      }
    } catch (e) {
      print('Error creating supplier: $e');
      rethrow;
    }
  }

  Future<Supplier> updateSupplier(int id, Supplier supplier) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/supplier/update-supplier/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode(supplier.toJson()),
      );

      if (response.statusCode == 200) {
        return Supplier.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update supplier');
      }
    } catch (e) {
      print('Error updating supplier: $e');
      rethrow;
    }
  }

  Future<void> deleteSupplier(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/supplier/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete supplier');
      }
    } catch (e) {
      print('Error deleting supplier: $e');
      rethrow;
    }
  }

  // Future<List<SalesSummary>> getDailySalesSummary({DateTime? date}) async {
  //   try {
  //     final targetDate = date ?? DateTime.now();
  //     final formattedDate = DateFormat('yyyy-MM-dd').format(targetDate);

  //     final response = await http.get(
  //       Uri.parse('$baseUrl/sales/daily-summary'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $_accessToken',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> data = json.decode(response.body);
  //       List<dynamic> salesData = data['sales_summary'];
  //       List<SalesSummary> salesSummary =
  //           salesData.map((json) => SalesSummary.fromJson(json)).toList();
  //       return salesSummary;
  //     } else {
  //       throw Exception('Failed to load daily sales: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching daily sales: $e');
  //     rethrow;
  //   }
  // }

  Future<List<SalesSummary>> getDailySalesSummary() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sales/daily-summary'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      print('Daily sales response status: ${response.statusCode}');
      print('Daily sales response body: ${response.body}');
      print('Request URL: ${Uri.parse('$baseUrl/sales/daily-summary')}');
      print('Headers: ${{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken'
      }}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> salesData = data['sales_summary'];
        return salesData.map((json) => SalesSummary.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load daily sales: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getDailySalesSummary: $e');
      rethrow;
    }
  }

  // Future<List<SalesSummary>> getMonthlySalesSummary({
  //   int? year,
  //   int? month,
  // }) async {
  //   try {
  //     final now = DateTime.now();
  //     final targetYear = year ?? now.year;
  //     final targetMonth = month ?? now.month;

  //     final response = await http.get(
  //       Uri.parse('$baseUrl/sales/monthly-summary'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $_accessToken',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> data = json.decode(response.body);
  //       List<dynamic> salesData = data['sales_summary'];
  //       List<SalesSummary> salesSummary =
  //           salesData.map((json) => SalesSummary.fromJson(json)).toList();
  //       return salesSummary;
  //     } else {
  //       throw Exception('Failed to load monthly sales: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching monthly sales: $e');
  //     rethrow;
  //   }
  // }

  Future<List<SalesSummary>> getMonthlySalesSummary() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sales/monthly-summary'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      print('Monthly sales response status: ${response.statusCode}');
      print('Monthly sales response body: ${response.body}');
      print('Request URL: ${Uri.parse('$baseUrl/sales/monthly-summary')}');
      print('Headers: ${{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken'
      }}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> salesData = data['sales_summary'];
        return salesData.map((json) => SalesSummary.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load monthly sales: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getMonthlySalesSummary: $e');
      rethrow;
    }
  }

  // Get all invoices
  Future<List<InvoiceEntity>> getInvoices() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/invoices'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      print('Get invoices response status: ${response.statusCode}');
      print('Get invoices response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => InvoiceEntity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load invoices: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting invoices: $e');
      rethrow;
    }
  }

  Future<InvoiceEntity> getInvoiceById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/invoices/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return InvoiceEntity.fromJson(data);
      } else {
        throw Exception('Failed to load invoice: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting invoice: $e');
      rethrow;
    }
  }

  // Create new invoice
  // Future<InvoiceEntity> createInvoice(InvoiceEntity invoice) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/invoices/create'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $_accessToken',
  //       },
  //       body: jsonEncode(invoice.toJson()),
  //     );

  //     if (response.statusCode == 201) {
  //       final data = jsonDecode(response.body);
  //       return InvoiceEntity.fromJson(data);
  //     } else {
  //       throw Exception('Failed to create invoice: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error creating invoice: $e');
  //     rethrow;
  //   }
  // }

  // Future<InvoiceEntity> createInvoice(InvoiceEntity invoice) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/invoice/create'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $_accessToken',
  //       },
  //       body: jsonEncode(invoice.toJson()),
  //     );

  //     print('Create invoice response status: ${response.statusCode}');
  //     print('Create invoice response body: ${response.body}');

  //     if (response.statusCode == 201) {
  //       return InvoiceEntity.fromJson(jsonDecode(response.body));
  //     } else {
  //       throw Exception('Failed to create invoice: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error creating invoice: $e');
  //     rethrow;
  //   }
  // }

  // Future<InvoiceEntity> createInvoice(InvoiceEntity invoice) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/invoice/create'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $_accessToken',
  //       },
  //       body: jsonEncode({
  //         'customer_name': invoice.customer.name,
  //         'customer_phone': invoice.customer.phone,
  //         'total_amount': invoice.totalAmount,
  //         'payment_method': invoice.paymentMethod,
  //         'items': invoice.items
  //             .map((item) => {
  //                   'product_name': item.productName,
  //                   'quantity': item.quantity,
  //                   'unit_price': item.unitPrice,
  //                   'total_price': item.totalPrice,
  //                 })
  //             .toList(),
  //       }),
  //     );

  //     print('Create invoice response status: ${response.statusCode}');
  //     print('Create invoice response body: ${response.body}');

  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       return InvoiceEntity.fromJson(jsonDecode(response.body));
  //     } else {
  //       throw Exception('Failed to create invoice: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error creating invoice: $e');
  //     rethrow;
  //   }
  // }

  Future<InvoiceEntity> createInvoice(InvoiceEntity invoice) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/invoice/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: jsonEncode({
          'customer_name': invoice.customerName,
          'customer_phone': invoice.customerPhone,
          'total_amount': invoice.totalAmount,
          'items': invoice.items
              .map((item) => {
                    'product_name': item.productName,
                    'quantity': item.quantity,
                    'unit_price': item.unitPrice,
                    'total_price': item.totalPrice,
                  })
              .toList(),
        }),
      );

      print('Create invoice response status: ${response.statusCode}');
      print('Create invoice response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return InvoiceEntity.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create invoice: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating invoice: $e');
      rethrow;
    }
  }

  // Update invoice
  Future<InvoiceEntity> updateInvoice(int id, InvoiceEntity invoice) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/invoices/update/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: jsonEncode(invoice.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return InvoiceEntity.fromJson(data);
      } else {
        throw Exception('Failed to update invoice: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating invoice: $e');
      rethrow;
    }
  }

  // Delete invoice
  Future<void> deleteInvoice(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/invoices/delete/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete invoice: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting invoice: $e');
      rethrow;
    }
  }

  // Generate invoice PDF
  Future<String> generateInvoicePDF(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/invoices/generate-pdf/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['pdf_url']; // Assuming the API returns a PDF URL
      } else {
        throw Exception('Failed to generate PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating PDF: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getInvoiceStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/invoices/stats'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load invoice stats: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting invoice stats: $e');
      rethrow;
    }
  }
}
