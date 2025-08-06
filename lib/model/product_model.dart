class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? image;
  final int? categoryId;
  final String? category;
  final double? discountPrice;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image,
    this.categoryId,
    this.category,
    this.discountPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Product',
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      image: json['image'],
      categoryId: json['category_id'],
      category: json['category'],
      discountPrice: json['discount_price'] != null 
          ? double.tryParse(json['discount_price'].toString()) 
          : null,
    );
  }
}
