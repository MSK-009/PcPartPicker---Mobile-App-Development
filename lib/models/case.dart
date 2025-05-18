class Case {
  final String id;
  final String image;
  final String caseName;
  final String size;
  final String isolation;
  final String price;

  Case({
    required this.id,
    required this.image,
    required this.caseName,
    required this.size,
    required this.isolation,
    required this.price,
  });

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      id: json['_id'] ?? '',
      image: json['Image'] ?? '',
      caseName: json['Case_name'] ?? '',
      size: json['Size'] ?? '',
      isolation: json['Isolation'] ?? '',
      price: json['Price'] ?? 'Not Available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Image': image,
      'Case_name': caseName,
      'Size': size,
      'Isolation': isolation,
      'Price': price,
    };
  }
} 