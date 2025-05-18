class Ssd {
  final String id;
  final String image;
  final String ssdName;
  final String capacity;
  final String format;
  final String protocol;
  final String released;
  final String price;

  Ssd({
    required this.id,
    required this.image,
    required this.ssdName,
    required this.capacity,
    required this.format,
    required this.protocol,
    required this.released,
    required this.price,
  });

  factory Ssd.fromJson(Map<String, dynamic> json) {
    return Ssd(
      id: json['_id'] ?? '',
      image: json['Image'] ?? '',
      ssdName: json['SSD_name'] ?? '',
      capacity: json['Capacity'] ?? '',
      format: json['Format'] ?? '',
      protocol: json['Protocol'] ?? '',
      released: json['Released'] ?? '',
      price: json['Price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Image': image,
      'SSD_name': ssdName,
      'Capacity': capacity,
      'Format': format,
      'Protocol': protocol,
      'Released': released,
      'Price': price,
    };
  }
} 