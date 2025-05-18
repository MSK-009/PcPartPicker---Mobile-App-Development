class Ram {
  final String id;
  final String image;
  final String ramName;
  final String price;
  final String released;
  final String latency;
  final String multicore;
  final String singlecore;

  Ram({
    required this.id,
    required this.image,
    required this.ramName,
    required this.price,
    required this.released,
    required this.latency,
    required this.multicore,
    required this.singlecore,
  });

  factory Ram.fromJson(Map<String, dynamic> json) {
    return Ram(
      id: json['_id'] ?? '',
      image: json['Image'] ?? '',
      ramName: json['RAM_name'] ?? '',
      price: json['Price'] ?? 'Not Available',
      released: json['Released'] ?? '',
      latency: json['Latency'] ?? '',
      multicore: json['Multicore_RW'] ?? '',
      singlecore: json['Singlecore_RW'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Image': image,
      'RAM_name': ramName,
      'Price': price,
      'Released': released,
      'Latency': latency,
      'Multicore_RW': multicore,
      'Singlecore_RW': singlecore,
    };
  }
}
