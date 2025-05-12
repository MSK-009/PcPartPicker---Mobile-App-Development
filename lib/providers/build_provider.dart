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
      _builds = response.map((build) => Build.fromJson(build)).toList();
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
      final response = await ApiService.saveBuild(build.toJson());
      
      // Add the new build to the list with the ID from the response
      final savedBuild = Build.fromJson(response);
      _builds.insert(0, savedBuild);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to save build: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
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
      _selectedBuild = Build.fromJson(response);
    } catch (e) {
      _error = 'Failed to load build: $e';
      _selectedBuild = null;
    } finally {
      _isLoading = false;
      notifyListeners();
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