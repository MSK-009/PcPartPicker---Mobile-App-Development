class Case {
  final String id;
  final String image;
  final String caseName;
  final String type;
  final String color;
  final String price;

  Case({
    required this.id,
    required this.image,
    required this.caseName,
    required this.type,
    required this.color,
    required this.price,
  });

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      id: json['_id'] ?? '',
      image: json['Image'] ?? '',
      caseName: json['CASE_name'] ?? '',
      type: json['Type'] ?? '',
      color: json['Color'] ?? '',
      price: json['Price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Image': image,
      'CASE_name': caseName,
      'Type': type,
      'Color': color,
      'Price': price,
    };
  }
} 