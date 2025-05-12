class Psu {
  final String id;
  final String image;
  final String psuName;
  final String wattage;
  final String efficiency;
  final String price;

  Psu({
    required this.id,
    required this.image,
    required this.psuName,
    required this.wattage,
    required this.efficiency,
    required this.price,
  });

  factory Psu.fromJson(Map<String, dynamic> json) {
    return Psu(
      id: json['_id'] ?? '',
      image: json['Image'] ?? '',
      psuName: json['PSU_name'] ?? '',
      wattage: json['Wattage'] ?? '',
      efficiency: json['Efficiency'] ?? '',
      price: json['Price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Image': image,
      'PSU_name': psuName,
      'Wattage': wattage,
      'Efficiency': efficiency,
      'Price': price,
    };
  }
} 