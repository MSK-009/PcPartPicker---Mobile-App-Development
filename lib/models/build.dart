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
    return Build(
      id: json['_id'],
      name: json['name'] ?? 'Unnamed Build',
      processor: json['processor'] != null ? Processor.fromJson(json['processor']) : null,
      gpu: json['gpu'] != null ? Gpu.fromJson(json['gpu']) : null,
      motherboard: json['motherboard'] != null ? Motherboard.fromJson(json['motherboard']) : null,
      ram: json['ram'] != null ? Ram.fromJson(json['ram']) : null,
      ssd: json['ssd'] != null ? Ssd.fromJson(json['ssd']) : null,
      pcCase: json['case'] != null ? Case.fromJson(json['case']) : null,
      psu: json['psu'] != null ? Psu.fromJson(json['psu']) : null,
      totalPrice: json['totalPrice']?.toDouble() ?? 0.0,
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
  }
} 