class Product {

  final int id;
  final String title;
  final String sellerName;
  final String description;
  final double price;
  final String? imgUrl;

  Product({required this.id, required this.title, required this.sellerName, required this.description, required this.price, required this.imgUrl});

  factory Product.fromJson(Map <String, dynamic> json){
    return Product(
      id: json['id'] ?? 0, 
      title: json['title'] ?? '', 
      sellerName: json['seller']['username'] ?? '', 
      description: json['description'] ?? 'lorem ipsum', 
      price: json['price'] ?? 0, 
      imgUrl: json['primary_image'] ?? ''
    );
  }
}