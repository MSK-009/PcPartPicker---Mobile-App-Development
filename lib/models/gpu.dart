class Gpu {
  final String id;
  final String image;
  final String gpuName;
  final String baseClock;
  final String boostClock;
  final String memory;
  final String tdp;
  final String price;

  Gpu({
    required this.id,
    required this.image,
    required this.gpuName,
    required this.baseClock,
    required this.boostClock,
    required this.memory,
    required this.tdp,
    required this.price,
  });

  factory Gpu.fromJson(Map<String, dynamic> json) {
    return Gpu(
      id: json['_id'] ?? '',
      image: json['Image'] ?? '',
      gpuName: json['GPU_name'] ?? '',
      baseClock: json['Base_clock'] ?? '',
      boostClock: json['Boost_clock'] ?? '',
      memory: json['Memory'] ?? '',
      tdp: json['TDP'] ?? '',
      price: json['Price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Image': image,
      'GPU_name': gpuName,
      'Base_clock': baseClock,
      'Boost_clock': boostClock,
      'Memory': memory,
      'TDP': tdp,
      'Price': price,
    };
  }
} 