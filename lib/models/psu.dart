class Psu {
  final String id;
  final String image;
  final String size;
  final String psuName;
  final String wattage;
  final String price;

  Psu({
    required this.id,
    required this.image,
    required this.size,
    required this.psuName,
    required this.wattage,
    required this.price,
  });

  factory Psu.fromJson(Map<String, dynamic> json) {
    return Psu(
      id: json['_id'] ?? '',
      image: json['Image'] ?? '',
      size: json['Size'] ?? '',
      psuName: json['PSU_name'] ?? '',
      wattage: json['Wattage'] ?? '',
      price: json['Price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Image': image,
      'Size': size,
      'PSU_name': psuName,
      'Wattage': wattage,
      'Price': price,
    };
  }
}
