import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';

  // Generic HTTP GET request
  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in GET request: $e');
      rethrow;
    }
  }

  // Generic HTTP POST request
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in POST request: $e');
      rethrow;
    }
  }

  // Generic HTTP DELETE request
  static Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in DELETE request: $e');
      rethrow;
    }
  }

  // Save build
  static Future<dynamic> saveBuild(Map<String, dynamic> buildData) async {
    return await post('/api/build/savebuild', buildData);
  }

  // Get all builds
  static Future<List<dynamic>> getBuilds() async {
    final response = await get('/api/build/getbuilds');
    return response as List<dynamic>;
  }

  // Get build by ID
  static Future<dynamic> getBuildById(String id) async {
    return await get('/api/build/getbuild/$id');
  }

  // Delete build
  static Future<dynamic> deleteBuild(String id) async {
    return await delete('/api/build/deletebuild/$id');
  }
} 