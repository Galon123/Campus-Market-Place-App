class Seller {
  final String username;
  final double rating;
  final String? imagePath;

  Seller({required this.username, required this.rating, this.imagePath});

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      username: json['username'] ?? 'Unknown',
      rating: (json['rating'] as num).toDouble(),
      imagePath: json['image_path'],
    );
  }
}