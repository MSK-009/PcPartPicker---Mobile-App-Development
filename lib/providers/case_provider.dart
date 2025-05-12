import 'package:flutter/material.dart';
import 'package:pc_part_picker/models/case.dart';
import 'package:pc_part_picker/services/api_service.dart';

class CaseProvider extends ChangeNotifier {
  List<Case> _cases = [];
  int _totalResults = 0;
  bool _isLoading = false;

  List<Case> get cases => _cases;
  int get totalResults => _totalResults;
  bool get isLoading => _isLoading;

  Future<void> getCases({
    required int pageSize,
    required int page,
    required String searchTerm,
    String sortParameter = 'CASE_name',
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
        '/api/case/getcases/$page', 
        requestBody
      );

      if (response != null) {
        _cases = List<Case>.from(
          response['result'].map((x) => Case.fromJson(x)),
        );
        _totalResults = response['totalLength'];
      } else {
        // Handle error
        _cases = [];
        _totalResults = 0;
      }
    } catch (e) {
      // Handle exceptions
      _cases = [];
      _totalResults = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 