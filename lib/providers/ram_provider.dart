import 'package:flutter/material.dart';
import 'package:pc_part_picker/models/ram.dart';
import 'package:pc_part_picker/services/api_service.dart';

class RamProvider extends ChangeNotifier {
  List<Ram> _rams = [];
  int _totalResults = 0;
  bool _isLoading = false;

  List<Ram> get rams => _rams;
  int get totalResults => _totalResults;
  bool get isLoading => _isLoading;

  Future<void> getRams({
    required int pageSize,
    required int page,
    required String searchTerm,
    String sortParameter = 'RAM_name',
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
        '/api/ram/getrams/$page', 
        requestBody
      );

      if (response != null) {
        _rams = List<Ram>.from(
          response['result'].map((x) => Ram.fromJson(x)),
        );
        _totalResults = response['totalLength'];
      } else {
        // Handle error
        _rams = [];
        _totalResults = 0;
      }
    } catch (e) {
      // Handle exceptions
      _rams = [];
      _totalResults = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 