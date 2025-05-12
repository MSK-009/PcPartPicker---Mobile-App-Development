import 'package:flutter/material.dart';
import 'package:pc_part_picker/models/psu.dart';
import 'package:pc_part_picker/services/api_service.dart';

class PsuProvider extends ChangeNotifier {
  List<Psu> _psus = [];
  int _totalResults = 0;
  bool _isLoading = false;

  List<Psu> get psus => _psus;
  int get totalResults => _totalResults;
  bool get isLoading => _isLoading;
  
  final String _baseUrl = 'http://localhost:5000';

  Future<void> getPsus({
    required int pageSize,
    required int page,
    required String searchTerm,
    String sortParameter = 'PSU_name',
    String sortOrder = 'asc',
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final requestBody = {
        'pageSize': pageSize,
        'search': searchTerm,
        'sort': sortParameter,
        'order': sortOrder,
      };

      final response = await ApiService.post(
        '/api/psu/getpsus/$page', 
        requestBody
      );

      if (response != null) {
        _psus = List<Psu>.from(
          response['result'].map((x) => Psu.fromJson(x)),
        );
        _totalResults = response['totalLength'];
      } else {
        // Handle error
        _psus = [];
        _totalResults = 0;
      }
    } catch (e) {
      // Handle exceptions
      _psus = [];
      _totalResults = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 