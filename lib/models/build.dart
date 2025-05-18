import 'package:flutter/foundation.dart';
import 'package:pc_part_picker/models/processor.dart';
import 'package:pc_part_picker/models/gpu.dart';
import 'package:pc_part_picker/models/motherboard.dart';
import 'package:pc_part_picker/models/ram.dart';
import 'package:pc_part_picker/models/ssd.dart';
import 'package:pc_part_picker/models/case.dart';
import 'package:pc_part_picker/models/psu.dart';

class Build {
  final String? id;
  final String name;
  final Processor? processor;
  final Gpu? gpu;
  final Motherboard? motherboard;
  final Ram? ram;
  final Ssd? ssd;
  final Case? pcCase;
  final Psu? psu;
  final double totalPrice;
  final String? date;

  Build({
    this.id,
    required this.name,
    this.processor,
    this.gpu,
    this.motherboard,
    this.ram,
    this.ssd,
    this.pcCase,
    this.psu,
    required this.totalPrice,
    this.date,
  });

  factory Build.fromJson(Map<String, dynamic> json) {
    // Handle processor field - could be a Map or just an ID string
    Processor? processorObj;
    if (json['processor'] != null) {
      if (json['processor'] is Map<String, dynamic>) {
        processorObj = Processor.fromJson(json['processor']);
      } else {
        // If it's just an ID string, create a minimal Processor with just the ID
        processorObj = Processor(
          id: json['processor'].toString(),
          image: '',
          cpuName: 'Loading...',
          cores: '',
          threads: '',
          baseClock: '',
          turboClock: '',
          tdp: '',
          released: '',
          price: '',
        );
      }
    }

    // Handle GPU field
    Gpu? gpuObj;
    if (json['gpu'] != null) {
      if (json['gpu'] is Map<String, dynamic>) {
        gpuObj = Gpu.fromJson(json['gpu']);
      } else {
        gpuObj = Gpu(
          id: json['gpu'].toString(),
          image: '',
          gpuName: 'Loading...',
          series: '',
          tdp: '',
          memory: '',
          released: '',
          manufacturer: '',
          price: '',
        );
      }
    }

    // Handle motherboard field
    Motherboard? motherboardObj;
    if (json['motherboard'] != null) {
      if (json['motherboard'] is Map<String, dynamic>) {
        motherboardObj = Motherboard.fromJson(json['motherboard']);
      } else {
        motherboardObj = Motherboard(
          id: json['motherboard'].toString(),
          image: '',
          chipset: 'Loading...',
          socket: '',
          formFactor: '',
          memorySlots: '',
          memoryType: '',
          manufacturer: '',
          price: '',
        );
      }
    }

    // Handle RAM field
    Ram? ramObj;
    if (json['ram'] != null) {
      if (json['ram'] is Map<String, dynamic>) {
        ramObj = Ram.fromJson(json['ram']);
      } else {
        ramObj = Ram(
          id: json['ram'].toString(),
          image: '',
          ramName: 'Loading...',
          latency: '',
          multicore: '',
          singlecore: '',
          released: '',
          price: '',
        );
      }
    }

    // Handle SSD field
    Ssd? ssdObj;
    if (json['ssd'] != null) {
      if (json['ssd'] is Map<String, dynamic>) {
        ssdObj = Ssd.fromJson(json['ssd']);
      } else {
        ssdObj = Ssd(
          id: json['ssd'].toString(),
          image: '',
          ssdName: 'Loading...',
          capacity: '',
          format: '',
          protocol: '',
          released: '',
          price: '',
        );
      }
    }

    // Handle Case field
    Case? caseObj;
    if (json['case'] != null) {
      if (json['case'] is Map<String, dynamic>) {
        caseObj = Case.fromJson(json['case']);
      } else {
        caseObj = Case(
          id: json['case'].toString(),
          image: '',
          caseName: 'Loading...',
          size: '',
          isolation: '',
          price: '',
        );
      }
    }

    // Handle PSU field
    Psu? psuObj;
    if (json['psu'] != null) {
      if (json['psu'] is Map<String, dynamic>) {
        psuObj = Psu.fromJson(json['psu']);
      } else {
        psuObj = Psu(
          id: json['psu'].toString(),
          image: '',
          psuName: 'Loading...',
          wattage: '',
          size: '',
          price: '',
        );
      }
    }

    return Build(
      id: json['_id'],
      name: json['name'] ?? 'Unnamed Build',
      processor: processorObj,
      gpu: gpuObj,
      motherboard: motherboardObj,
      ram: ramObj,
      ssd: ssdObj,
      pcCase: caseObj,
      psu: psuObj,
      totalPrice: json['totalPrice']?.toDouble() ?? 0.0,
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    // Debug information
    debugPrint('Processor ID: ${processor?.id}');
    debugPrint('GPU ID: ${gpu?.id}');
    debugPrint('Motherboard ID: ${motherboard?.id}');
    debugPrint('RAM ID: ${ram?.id}');
    debugPrint('SSD ID: ${ssd?.id}');
    debugPrint('Case ID: ${pcCase?.id}');
    debugPrint('PSU ID: ${psu?.id}');
    
    final json = {
      'name': name,
      'processor': processor?.id,
      'gpu': gpu?.id,
      'motherboard': motherboard?.id,
      'ram': ram?.id,
      'ssd': ssd?.id,
      'case': pcCase?.id,
      'psu': psu?.id,
      'totalPrice': totalPrice,
    };
    
    // Remove null values that could cause issues with the backend
    json.removeWhere((key, value) => value == null);
    
    return json;
  }
} 