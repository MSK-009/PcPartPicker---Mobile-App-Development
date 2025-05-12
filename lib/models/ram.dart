class Ram {
  final String id;
  final String image;
  final String ramName;
  final String speed;
  final String capacity;
  final String price;

  Ram({
    required this.id,
    required this.image,
    required this.ramName,
    required this.speed,
    required this.capacity,
    required this.price,
  });

  factory Ram.fromJson(Map<String, dynamic> json) {
    return Ram(
      id: json['_id'] ?? '',
      image: json['Image'] ?? '',
      ramName: json['RAM_name'] ?? '',
      speed: json['Speed'] ?? '',
      capacity: json['Capacity'] ?? '',
      price: json['Price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Image': image,
      'RAM_name': ramName,
      'Speed': speed,
      'Capacity': capacity,
      'Price': price,
    };
  }
} 