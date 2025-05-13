class Gpu {
  final String id;
  final String image;
  final String gpuName;
  final String series;
  final String tdp;
  final String memory;
  final String released;
  final String price;
  final String manufacturer;

  Gpu({
    required this.id,
    required this.image,
    required this.gpuName,
    required this.series,
    required this.tdp,
    required this.memory,
    required this.released,
    required this.price,
    required this.manufacturer,
  });

  factory Gpu.fromJson(Map<String, dynamic> json) {
    return Gpu(
      id: json['_id'] ?? '',
      image: json['Image'] ?? '',
      gpuName: json['GPU_name'] ?? '',
      series: json['Series'] ?? '',
      tdp: json['TDP'] ?? '',
      memory: json['VRAM'] ?? '',
      released: json['Released'] ?? '',
      price: json['Price'] ?? '',
      manufacturer: json['Manufacturer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Image': image,
      'GPU_name': gpuName,
      'Series': series,
      'TDP': tdp,
      'VRAM': memory,
      'Released': released,
      'Price': price,
      'Manufacturer': manufacturer,
    };
  }
}
