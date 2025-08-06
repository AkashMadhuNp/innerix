import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:innerix/model/login_response.dart';
import 'package:innerix/model/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://app.ecominnerix.com/api';
  
  
  
  static Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      final Map<String, dynamic> data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(data);
      } else {
        // Handle message or messages (which might be String or List)
      final error = data['messages'] ?? data['message'] ?? 'Login failed';
      String errorMessage;

      if (error is String) {
        errorMessage = error;
      } else if (error is List && error.isNotEmpty) {
        errorMessage = error.first.toString();
      } else {
        errorMessage = 'Login failed';
      }

      return LoginResponse(
        success: false,
        message: errorMessage,
      );
    }

        

      
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  static Future<Map<String, dynamic>> requestOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/request-otp'),
        body: {
          'email': email,
        },
      );

      final Map<String, dynamic> data = json.decode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? 'OTP request failed',
        'data': data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  static Future<LoginResponse> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-email-otp'),
        body: {
          'email': email,
          'otp': otp,
        },
      );

      final Map<String, dynamic> data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(data);
      } else {
        return LoginResponse(
          success: false,
          message: data['message'] ?? 'OTP verification failed',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  static Future<Map<String, dynamic>> getHomeData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/v1/home'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to load home data',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  static Future<List<Product>> getProducts({
    int shopId = 1,
    int pageSize = 100,
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products?shop_id=$shopId&page_size=$pageSize&page=$page'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['data'] ?? data['products'] ?? [];
        
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<Product?> getProduct(int productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$productId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Product.fromJson(data['data'] ?? data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
