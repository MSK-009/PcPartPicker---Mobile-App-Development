class Ssd {
  final String id;
  final String image;
  final String ssdName;
  final String capacity;
  final String interface;
  final String price;

  Ssd({
    required this.id,
    required this.image,
    required this.ssdName,
    required this.capacity,
    required this.interface,
    required this.price,
  });

  factory Ssd.fromJson(Map<String, dynamic> json) {
    return Ssd(
      id: json['_id'] ?? '',
      image: json['Image'] ?? '',
      ssdName: json['SSD_name'] ?? '',
      capacity: json['Capacity'] ?? '',
      interface: json['Interface'] ?? '',
      price: json['Price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Image': image,
      'SSD_name': ssdName,
      'Capacity': capacity,
      'Interface': interface,
      'Price': price,
    };
  }
} 