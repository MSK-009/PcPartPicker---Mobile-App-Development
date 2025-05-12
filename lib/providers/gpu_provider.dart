import 'package:flutter/material.dart';
import 'package:pc_part_picker/models/gpu.dart';
import 'package:pc_part_picker/services/api_service.dart';

class GpuProvider extends ChangeNotifier {
  List<Gpu> _gpus = [];
  int _totalResults = 0;
  bool _isLoading = false;

  List<Gpu> get gpus => _gpus;
  int get totalResults => _totalResults;
  bool get isLoading => _isLoading;

  Future<void> getGpus({
    required int pageSize,
    required int page,
    required String searchTerm,
    String sortParameter = 'GPU_name',
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
        '/api/gpu/getgpus/$page', 
        requestBody
      );

      if (response != null) {
        _gpus = List<Gpu>.from(
          response['result'].map((x) => Gpu.fromJson(x)),
        );
        _totalResults = response['totalLength'];
      } else {
        // Handle error
        _gpus = [];
        _totalResults = 0;
      }
    } catch (e) {
      // Handle exceptions
      _gpus = [];
      _totalResults = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 