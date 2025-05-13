class Motherboard {
  final String id;
  final String price;
  final String socket;
  final String chipset;
  final String formFactor;
  final String memorySlots;
  final String memoryType;
  final String image;
  final String manufacturer;

  Motherboard({
    required this.id,
    required this.price,
    required this.socket,
    required this.chipset,
    required this.formFactor,
    required this.memorySlots,
    required this.memoryType,
    required this.image,
    required this.manufacturer,
  });

  factory Motherboard.fromJson(Map<String, dynamic> json) {
    return Motherboard(
      id: json['_id'] ?? '',
      price: json['Price'] ?? '',
      socket: json['Socket'] ?? '',
      chipset: json['Chipset'] ?? '',
      formFactor: json['FormFactor'] ?? '',
      memorySlots: json['Ramslots'] ?? '',
      memoryType: json['Memorytype'] ?? '',
      image: json['Image'] ?? '',
      manufacturer: json['Manufacturer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Price': price,
      'Socket': socket,
      'Chipset': chipset,
      'FormFactor': formFactor,
      'Ramslots': memorySlots,
      'Memorytype': memoryType,
      'Image': image,
      'Manufacturer': manufacturer,
    };
  }
}
