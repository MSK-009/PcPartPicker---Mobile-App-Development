import 'package:flutter/material.dart';
import 'package:pc_part_picker/models/processor.dart';
import 'package:pc_part_picker/services/api_service.dart';

class ProcessorProvider extends ChangeNotifier {
  List<Processor> _processors = [];
  int _totalResults = 0;
  bool _isLoading = false;

  List<Processor> get processors => _processors;
  int get totalResults => _totalResults;
  bool get isLoading => _isLoading;

  Future<void> getProcessors({
    required int pageSize,
    required int page,
    required String searchTerm,
    String sortParameter = 'CPU_name',
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
        '/api/processor/getprocessors/$page', 
        requestBody
      );

      if (response != null) {
        _processors = List<Processor>.from(
          response['result'].map((x) => Processor.fromJson(x)),
        );
        _totalResults = response['totalLength'];
      } else {
        // Handle error
        _processors = [];
        _totalResults = 0;
      }
    } catch (e) {
      // Handle exceptions
      _processors = [];
      _totalResults = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 