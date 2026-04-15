import 'package:e_commerce_refactor/models/ProductImage.dart';
import 'package:e_commerce_refactor/models/Seller.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final double minPrice;
  final int quantity;
  final String status;
  final String condition;
  final List<String> categories;
  final Seller seller;
  final List<ProductImage> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.minPrice,
    required this.quantity,
    required this.status,
    required this.condition,
    required this.categories,
    required this.seller,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      // Handling both int and double from JSON safely
      minPrice: (json['min_price'] as num).toDouble(),
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? '',
      condition: json['condition'] ?? '',
      // Cast the list of dynamic categories to List<String>
      categories: List<String>.from(json['categories'] ?? []),
      // Nested Parsing
      seller: Seller.fromJson(json['seller']),
      images: (json['images'] as List)
          .map((i) => ProductImage.fromJson(i))
          .toList(),
    );
  }
}