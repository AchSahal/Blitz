class Product {
  final String id;
  final String sku;
  final double price;
  final List<String> size;
  final String name;
  final String description;
  final double rating;
  final bool is_new;
  final String image;
  final String brand;

  Product(
      {required this.id,
      required this.sku,
      required this.price,
      required this.size,
      required this.name,
      required this.description,
      required this.rating,
      required this.is_new,
      required this.image,
      required this.brand});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      sku: json['sku'] as String,
      price: json['price'] as double,
      size: List<String>.from(json['size'] as List),
      name: json['name'] as String,
      description: json['description'] as String,
      rating: json['rating'] as double,
      is_new: json['is_new'] as bool,
      image: json['image'] as String,
      brand: json['brand'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'price': price,
      'size': size,
      'name': name,
      'description': description,
      'rating': rating,
      'is_new': is_new,
      'image': image,
      'brand': brand
    };
  }
}
