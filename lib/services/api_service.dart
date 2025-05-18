import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApiService {
  // Update baseUrl for both local development and production use
  static String get baseUrl {
    // If we're running in release mode, use the production URL
    if (kReleaseMode) {
      return 'https://api.yourprodserver.com'; // Replace with your production API URL
    }
    
    // For local development - if on Windows use localhost, on Android emulator use 10.0.2.2
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000'; // Android emulator special IP for localhost
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'http://localhost:5000'; // iOS simulator can use localhost
    } 
    
    // Default for Windows/Mac/Linux
    return 'http://localhost:5000';
  }

  // Generic HTTP GET request
  static Future<dynamic> get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('GET Request to $uri');
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          throw FormatException('Failed to parse response: ${e.toString()}');
        }
      } else {
        throw HttpException('Failed to load data: ${response.statusCode} - ${response.body}');
      }
    } on SocketException catch (e) {
      debugPrint('Socket error (possible connectivity issue): $e');
      throw ServerConnectionException('Cannot connect to server. Please check your internet connection.');
    } on TimeoutException {
      debugPrint('Request timed out');
      throw ServerConnectionException('Server took too long to respond. Please try again later.');
    } on HttpException catch (e) {
      debugPrint('HTTP error: $e');
      rethrow;
    } on FormatException catch (e) {
      debugPrint('Format error: $e');
      rethrow;
    } catch (e) {
      debugPrint('Error in GET request: $e');
      rethrow;
    }
  }

  // Generic HTTP POST request
    // Generic HTTP POST request
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final encodedBody = jsonEncode(body);
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('POST Request to $uri with body: $encodedBody');
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: encodedBody,
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          if (response.body.isEmpty) {
            return {}; // Return empty object for empty responses
          }
          return jsonDecode(response.body);
        } catch (e) {
          throw FormatException('Failed to parse response: ${e.toString()}');
        }
      } else {
        throw HttpException('Failed to post data: ${response.statusCode} - ${response.body}');
      }
    } on SocketException catch (e) {
      debugPrint('Socket error (possible connectivity issue): $e');
      throw ServerConnectionException('Cannot connect to server. Please check your internet connection.');
    } on TimeoutException {
      debugPrint('Request timed out');
      throw ServerConnectionException('Server took too long to respond. Please try again later.');
    } on HttpException catch (e) {
      debugPrint('HTTP error: $e');
      rethrow;
    } on FormatException catch (e) {
      debugPrint('Format error: $e');
      rethrow;
    } catch (e) {
      debugPrint('Error in POST request: $e');
      rethrow;
    }
  }

  // Generic HTTP DELETE request
  static Future<dynamic> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('DELETE Request to $uri');
      
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          throw FormatException('Failed to parse response: ${e.toString()}');
        }
      } else {
        throw HttpException('Failed to delete data: ${response.statusCode} - ${response.body}');
      }
    } on SocketException catch (e) {
      debugPrint('Socket error (possible connectivity issue): $e');
      throw ServerConnectionException('Cannot connect to server. Please check your internet connection.');
    } on TimeoutException {
      debugPrint('Request timed out');
      throw ServerConnectionException('Server took too long to respond. Please try again later.');
    } on HttpException catch (e) {
      debugPrint('HTTP error: $e');
      rethrow;
    } on FormatException catch (e) {
      debugPrint('Format error: $e');
      rethrow;
    } catch (e) {
      debugPrint('Error in DELETE request: $e');
      rethrow;
    }
  }

  // Save build
  static Future<dynamic> saveBuild(Map<String, dynamic> buildData) async {
    try {
      debugPrint('Saving build with data: $buildData');
      final result = await post('/api/build/savebuild', buildData);
      debugPrint('Build saved successfully: $result');
      return result;
    } catch (e) {
      debugPrint('Error saving build: $e');
      rethrow;
    }
  }

  // Get all builds
  static Future<List<dynamic>> getBuilds() async {
    try {
      final response = await get('/api/build/getbuilds');
      if (response is List) {
        return response;
      } else {
        debugPrint('Expected list but got: ${response.runtimeType}');
        // Return an empty list if the response is not a list
        return [];
      }
    } catch (e) {
      debugPrint('Error getting builds: $e');
      rethrow;
    }
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

// Custom exceptions
class ServerConnectionException implements Exception {
  final String message;
  ServerConnectionException(this.message);
  
  @override
  String toString() => message;
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
} 