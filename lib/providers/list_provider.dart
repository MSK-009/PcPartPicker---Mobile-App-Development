import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pc_part_picker/models/processor.dart';
import 'package:pc_part_picker/models/gpu.dart';
import 'package:pc_part_picker/models/motherboard.dart';
import 'package:pc_part_picker/models/ram.dart';
import 'package:pc_part_picker/models/ssd.dart';
import 'package:pc_part_picker/models/case.dart';
import 'package:pc_part_picker/models/psu.dart';

class ListProvider extends ChangeNotifier {
  Processor? _selectedProcessor;
  Gpu? _selectedGpu;
  Motherboard? _selectedMotherboard;
  Ram? _selectedRam;
  Ssd? _selectedSsd;
  Case? _selectedCase;
  Psu? _selectedPsu;

  ListProvider() {
    _loadSelectedItems();
  }

  Processor? get selectedProcessor => _selectedProcessor;
  Gpu? get selectedGpu => _selectedGpu;
  Motherboard? get selectedMotherboard => _selectedMotherboard;
  Ram? get selectedRam => _selectedRam;
  Ssd? get selectedSsd => _selectedSsd;
  Case? get selectedCase => _selectedCase;
  Psu? get selectedPsu => _selectedPsu;

  bool get hasSelectedItems => 
    _selectedProcessor != null || 
    _selectedGpu != null || 
    _selectedMotherboard != null || 
    _selectedRam != null || 
    _selectedSsd != null || 
    _selectedCase != null || 
    _selectedPsu != null;

  double get totalPrice {
    double total = 0;
    
    if (_selectedProcessor != null) {
      total += _extractPrice(_selectedProcessor!.price);
    }
    
    if (_selectedGpu != null) {
      total += _extractPrice(_selectedGpu!.price);
    }
    
    if (_selectedMotherboard != null) {
      total += _extractPrice(_selectedMotherboard!.price);
    }
    
    if (_selectedRam != null) {
      total += _extractPrice(_selectedRam!.price);
    }
    
    if (_selectedSsd != null) {
      total += _extractPrice(_selectedSsd!.price);
    }
    
    if (_selectedCase != null) {
      total += _extractPrice(_selectedCase!.price);
    }
    
    if (_selectedPsu != null) {
      total += _extractPrice(_selectedPsu!.price);
    }
    
    return total;
  }
  
  // Helper method to extract numeric price from various string formats
  double _extractPrice(String priceStr) {
    // Remove all currency symbols, spaces, and other non-numeric characters except dot
    String numericStr = priceStr
      .replaceAll(RegExp(r'[A-Za-z$£€¥]'), '') // Remove currency symbols and letters
      .replaceAll(RegExp(r'\s+'), '')          // Remove spaces
      .replaceAll(',', '.')                     // Replace comma with dot
      .trim();
    
    // In case there are multiple dots, keep only the last one (as decimal separator)
    final parts = numericStr.split('.');
    if (parts.length > 2) {
      numericStr = parts.sublist(0, parts.length - 1).join('') + '.' + parts.last;
    }
    
    // Convert to double
    return double.tryParse(numericStr) ?? 0.0;
  }

  void setProcessor(Processor processor) {
    _selectedProcessor = processor;
    _saveSelectedItems();
    notifyListeners();
  }

  void setGpu(Gpu gpu) {
    _selectedGpu = gpu;
    _saveSelectedItems();
    notifyListeners();
  }

  void setMotherboard(Motherboard motherboard) {
    _selectedMotherboard = motherboard;
    _saveSelectedItems();
    notifyListeners();
  }

  void setRam(Ram ram) {
    _selectedRam = ram;
    _saveSelectedItems();
    notifyListeners();
  }

  void setSsd(Ssd ssd) {
    _selectedSsd = ssd;
    _saveSelectedItems();
    notifyListeners();
  }

  void setCase(Case caseItem) {
    _selectedCase = caseItem;
    _saveSelectedItems();
    notifyListeners();
  }

  void setPsu(Psu psu) {
    _selectedPsu = psu;
    _saveSelectedItems();
    notifyListeners();
  }

  void removeProcessor() {
    _selectedProcessor = null;
    _saveSelectedItems();
    notifyListeners();
  }

  void removeGpu() {
    _selectedGpu = null;
    _saveSelectedItems();
    notifyListeners();
  }

  void removeMotherboard() {
    _selectedMotherboard = null;
    _saveSelectedItems();
    notifyListeners();
  }

  void removeRam() {
    _selectedRam = null;
    _saveSelectedItems();
    notifyListeners();
  }

  void removeSsd() {
    _selectedSsd = null;
    _saveSelectedItems();
    notifyListeners();
  }

  void removeCase() {
    _selectedCase = null;
    _saveSelectedItems();
    notifyListeners();
  }

  void removePsu() {
    _selectedPsu = null;
    _saveSelectedItems();
    notifyListeners();
  }

  Future<void> _loadSelectedItems() async {
    final prefs = await SharedPreferences.getInstance();
    
    final processorJson = prefs.getString('selectedProcessor');
    if (processorJson != null) {
      _selectedProcessor = Processor.fromJson(jsonDecode(processorJson));
    }
    
    final gpuJson = prefs.getString('selectedGpu');
    if (gpuJson != null) {
      _selectedGpu = Gpu.fromJson(jsonDecode(gpuJson));
    }
    
    final motherboardJson = prefs.getString('selectedMotherboard');
    if (motherboardJson != null) {
      _selectedMotherboard = Motherboard.fromJson(jsonDecode(motherboardJson));
    }
    
    final ramJson = prefs.getString('selectedRam');
    if (ramJson != null) {
      _selectedRam = Ram.fromJson(jsonDecode(ramJson));
    }
    
    final ssdJson = prefs.getString('selectedSsd');
    if (ssdJson != null) {
      _selectedSsd = Ssd.fromJson(jsonDecode(ssdJson));
    }
    
    final caseJson = prefs.getString('selectedCase');
    if (caseJson != null) {
      _selectedCase = Case.fromJson(jsonDecode(caseJson));
    }
    
    final psuJson = prefs.getString('selectedPsu');
    if (psuJson != null) {
      _selectedPsu = Psu.fromJson(jsonDecode(psuJson));
    }
    
    notifyListeners();
  }

  Future<void> _saveSelectedItems() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_selectedProcessor != null) {
      prefs.setString('selectedProcessor', jsonEncode(_selectedProcessor!.toJson()));
    } else {
      prefs.remove('selectedProcessor');
    }
    
    if (_selectedGpu != null) {
      prefs.setString('selectedGpu', jsonEncode(_selectedGpu!.toJson()));
    } else {
      prefs.remove('selectedGpu');
    }
    
    if (_selectedMotherboard != null) {
      prefs.setString('selectedMotherboard', jsonEncode(_selectedMotherboard!.toJson()));
    } else {
      prefs.remove('selectedMotherboard');
    }
    
    if (_selectedRam != null) {
      prefs.setString('selectedRam', jsonEncode(_selectedRam!.toJson()));
    } else {
      prefs.remove('selectedRam');
    }
    
    if (_selectedSsd != null) {
      prefs.setString('selectedSsd', jsonEncode(_selectedSsd!.toJson()));
    } else {
      prefs.remove('selectedSsd');
    }
    
    if (_selectedCase != null) {
      prefs.setString('selectedCase', jsonEncode(_selectedCase!.toJson()));
    } else {
      prefs.remove('selectedCase');
    }
    
    if (_selectedPsu != null) {
      prefs.setString('selectedPsu', jsonEncode(_selectedPsu!.toJson()));
    } else {
      prefs.remove('selectedPsu');
    }
  }

  void clearAllItems() {
    _selectedProcessor = null;
    _selectedGpu = null;
    _selectedMotherboard = null;
    _selectedRam = null;
    _selectedSsd = null;
    _selectedCase = null;
    _selectedPsu = null;
    _saveSelectedItems();
    notifyListeners();
  }
} 