class Product {

  final int id;
  final String title;
  final String sellerName;
  final String description;
  final double price;
  final String imgUrl;

  Product({required this.id, required this.title, required this.sellerName, required this.description, required this.price, required this.imgUrl});

  factory Product.fromJson(Map <String, dynamic> json){
    return Product(
      id: json['id'], 
      title: json['title'], 
      sellerName: json['username'], 
      description: json['description'], 
      price: json['price'], 
      imgUrl: json['primary_image']
    );
  }
}