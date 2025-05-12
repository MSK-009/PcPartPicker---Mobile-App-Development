import 'package:flutter/material.dart';
import 'package:pc_part_picker/models/ssd.dart';
import 'package:pc_part_picker/services/api_service.dart';

class SsdProvider extends ChangeNotifier {
  List<Ssd> _ssds = [];
  int _totalResults = 0;
  bool _isLoading = false;

  List<Ssd> get ssds => _ssds;
  int get totalResults => _totalResults;
  bool get isLoading => _isLoading;

  Future<void> getSsds({
    required int pageSize,
    required int page,
    required String searchTerm,
    String sortParameter = 'SSD_name',
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
        '/api/ssd/getssds/$page', 
        requestBody
      );

      if (response != null) {
        _ssds = List<Ssd>.from(
          response['result'].map((x) => Ssd.fromJson(x)),
        );
        _totalResults = response['totalLength'];
      } else {
        // Handle error
        _ssds = [];
        _totalResults = 0;
      }
    } catch (e) {
      // Handle exceptions
      _ssds = [];
      _totalResults = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 