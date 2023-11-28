class Cart {
  final String id;
  final String sku;
  final double price;
  final String size;
  final int quantity;
  final String name;
  final String description;

  Cart({
    required this.id,
    required this.sku,
    required this.price,
    required this.size,
    required this.quantity,
    required this.name,
    required this.description,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as String,
      sku: json['sku'] as String,
      price: json['price'] as double,
      size: json['size'] as String,
      quantity: json['quantity'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'price': price,
      'size': size,
      'quantity': quantity,
      'name': name,
      'description': description,
    };
  }
}
