class Product{
   final int productId;
  final String name;
  final String? thumbnailImage;

  final double price;
  final double rating;
  final int reviews;

  Product({
    required this.productId,
    required this.name, 
    required this.thumbnailImage,  
    required this.price,
    required this.rating,
    required this.reviews,

  });


  factory Product.fromJson(Map<String,dynamic>json){
    return Product(
      productId: json['product_id'] ?? 0,

      name: json['name'] ?? 'Unknown Product',
      thumbnailImage: json['thumbnail_image'], 
      price: double.tryParse(json['price'].toString()) ?? 0.0,

      rating: double.tryParse(json['rating'].toString()) ?? 0.0, 
      reviews: json['product_id'] ?? 0
      );
  }

}




class HomeData {
  final List<Product> topSellingItems;
  final List<Product> bestOffers;

  HomeData({
    required this.topSellingItems,
    required this.bestOffers,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      
      topSellingItems: json['top_selling_items'] != null && json['top_selling_items']['items'] != null
          ? (json['top_selling_items']['items'] as List)
              .map((item) => Product.fromJson(item))
              .toList()
          : [],
      bestOffers: json['best_offers'] != null && json['best_offers']['items'] != null
          ? (json['best_offers']['items'] as List)
              .map((item) => Product.fromJson(item))
              .toList()
          : [],
    );
  }
}