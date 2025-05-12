class Processor {
  final String id;
  final String image;
  final String cpuName;
  final String cores;
  final String threads;
  final String baseClock;
  final String turboClock;
  final String tdp;
  final String released;
  final String price;

  Processor({
    required this.id,
    required this.image,
    required this.cpuName,
    required this.cores,
    required this.threads,
    required this.baseClock,
    required this.turboClock,
    required this.tdp,
    required this.released,
    required this.price,
  });

  factory Processor.fromJson(Map<String, dynamic> json) {
    return Processor(
      id: json['_id'] ?? '',
      image: json['Image'] ?? '',
      cpuName: json['CPU_name'] ?? '',
      cores: json['Cores'] ?? '',
      threads: json['Threads'] ?? '',
      baseClock: json['Base_clock'] ?? '',
      turboClock: json['Turbo_clock'] ?? '',
      tdp: json['TDP'] ?? '',
      released: json['Released'] ?? '',
      price: json['Price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Image': image,
      'CPU_name': cpuName,
      'Cores': cores,
      'Threads': threads,
      'Base_clock': baseClock,
      'Turbo_clock': turboClock,
      'TDP': tdp,
      'Released': released,
      'Price': price,
    };
  }
} 