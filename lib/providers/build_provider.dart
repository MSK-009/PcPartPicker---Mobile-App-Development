import 'package:flutter/material.dart';
import 'package:pc_part_picker/models/build.dart';
import 'package:pc_part_picker/services/api_service.dart';

class BuildProvider extends ChangeNotifier {
  List<Build> _builds = [];
  Build? _selectedBuild;
  bool _isLoading = false;
  String? _error;

  List<Build> get builds => _builds;
  Build? get selectedBuild => _selectedBuild;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get all builds
  Future<void> fetchBuilds() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getBuilds();
      
      // Make sure we're getting a valid list
      if (response is List) {
        _builds = [];
        
        // Process each build individually to avoid issues with bad data
        for (var buildJson in response) {
          try {
            if (buildJson is Map<String, dynamic>) {
              final build = Build.fromJson(buildJson);
              _builds.add(build);
            }
          } catch (itemError) {
            debugPrint('Error processing a build item: $itemError');
            // Continue with the next item
          }
        }
      } else {
        throw Exception('Invalid response format: expected a list');
      }
    } catch (e) {
      _error = 'Failed to load builds: $e';
      _builds = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save a build
  Future<bool> saveBuild(Build build) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('Converting build to JSON...');
      final buildJson = build.toJson();
      debugPrint('Build JSON: $buildJson');
      
      // Add a timeout to the save operation
      final response = await ApiService.saveBuild(buildJson).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Saving build timed out after 15 seconds');
        },
      );
      
      debugPrint('Save build response: $response');
      
      if (response != null) {
        final savedBuildId = response['_id'] as String;
        
        // First add the build with placeholder data
        final savedBuild = Build(
          id: savedBuildId,
          name: build.name,
          processor: build.processor,
          gpu: build.gpu,
          motherboard: build.motherboard,
          ram: build.ram,
          ssd: build.ssd,
          pcCase: build.pcCase,
          psu: build.psu,
          totalPrice: build.totalPrice,
        );
        
        _builds.insert(0, savedBuild);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Failed to save build: Empty response');
      }
    } catch (e) {
      _error = 'Failed to save build: $e';
      debugPrint(_error!);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Helper to determine if we need to fetch full build data
  bool _shouldFetchFullBuildData(Map<String, dynamic> buildData) {
    // Check if processor is a string ID or an object
    if (buildData['processor'] != null && buildData['processor'] is! Map<String, dynamic>) {
      return true;
    }
    // Check if gpu is a string ID or an object
    if (buildData['gpu'] != null && buildData['gpu'] is! Map<String, dynamic>) {
      return true;
    }
    // Could add more checks for other components
    
    return false;
  }

  // Delete a build
  Future<bool> deleteBuild(String buildId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService.deleteBuild(buildId);
      
      // Remove the build from the list
      _builds.removeWhere((build) => build.id == buildId);
      
      // If the selected build was deleted, clear it
      if (_selectedBuild?.id == buildId) {
        _selectedBuild = null;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete build: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get build by ID
  Future<void> fetchBuildById(String buildId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getBuildById(buildId);
      if (response != null) {
        _selectedBuild = Build.fromJson(response);
      } else {
        throw Exception('Build not found or invalid response');
      }
    } catch (e) {
      _error = 'Failed to load build: $e';
      _selectedBuild = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
Future<bool> updateBuildWithFullData(String buildId) async {
  try {
    final response = await ApiService.getBuildById(buildId);
    if (response != null) {
      final updatedBuild = Build.fromJson(response);
      
      // Find and replace the build in our list
      final index = _builds.indexWhere((build) => build.id == buildId);
      if (index != -1) {
        _builds[index] = updatedBuild;
        notifyListeners();
      }
      
      return true;
    }
    return false;
  } catch (e) {
    debugPrint('Error updating build with full data: $e');
    return false;
  }
}
  // Set selected build
  void setSelectedBuild(Build? build) {
    _selectedBuild = build;
    notifyListeners();
  }

  // Clear selected build
  void clearSelectedBuild() {
    _selectedBuild = null;
    notifyListeners();
  }
} 