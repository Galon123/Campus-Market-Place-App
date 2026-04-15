class ProductImage {
  final int id;
  final String imagePath;

  ProductImage({required this.id, required this.imagePath});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      imagePath: json['image_path'] ?? '',
    );
  }
}