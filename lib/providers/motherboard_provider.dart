import 'package:flutter/material.dart';
import 'package:pc_part_picker/models/motherboard.dart';
import 'package:pc_part_picker/services/api_service.dart';

class MotherboardProvider extends ChangeNotifier {
  List<Motherboard> _motherboards = [];
  int _totalResults = 0;
  bool _isLoading = false;

  List<Motherboard> get motherboards => _motherboards;
  int get totalResults => _totalResults;
  bool get isLoading => _isLoading;

  final String _baseUrl = 'http://localhost:5000';

  Future<void> getMotherboards({
    required int pageSize,
    required int page,
    required String searchTerm,
    String sortParameter = 'Manufacturer',
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

      final response =
          await ApiService.post('/api/mobo/getmotherboards/$page', requestBody);

      if (response != null) {
        _motherboards = List<Motherboard>.from(
          response['result'].map((x) => Motherboard.fromJson(x)),
        );
        _totalResults = response['totalLength'];
      } else {
        // Handle error
        _motherboards = [];
        _totalResults = 0;
      }
    } catch (e) {
      // Handle exceptions
      _motherboards = [];
      _totalResults = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
