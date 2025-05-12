class Motherboard {
  final String id;
  final String image;
  final String moboName;
  final String chipset;
  final String formFactor;
  final String memorySlots;
  final String price;

  Motherboard({
    required this.id,
    required this.image,
    required this.moboName,
    required this.chipset,
    required this.formFactor,
    required this.memorySlots,
    required this.price,
  });

  factory Motherboard.fromJson(Map<String, dynamic> json) {
    return Motherboard(
      id: json['_id'] ?? '',
      image: json['Image'] ?? '',
      moboName: json['MOBO_name'] ?? '',
      chipset: json['Chipset'] ?? '',
      formFactor: json['Form_factor'] ?? '',
      memorySlots: json['Memory_slots'] ?? '',
      price: json['Price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Image': image,
      'MOBO_name': moboName,
      'Chipset': chipset,
      'Form_factor': formFactor,
      'Memory_slots': memorySlots,
      'Price': price,
    };
  }
} 