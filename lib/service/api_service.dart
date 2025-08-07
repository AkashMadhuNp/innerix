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


  static Future<HomeData>getHomeData()async{
    try{
      final response = await http.get(
        Uri.parse('$baseUrl/v1/home'),
        headers: {
          'Content-Type':'application/json',
          'Accept':'application/json',
        }
      );

      if(response.statusCode == 200){
        final Map<String,dynamic> data = json.decode(response.body);
        return HomeData.fromJson(data);
      }else{
        throw Exception("Failed to load home data.Status code:${response.statusCode}");
      }
    }catch(e){
      throw Exception("Network error:${e.toString()}");
    }
  }

  
}
