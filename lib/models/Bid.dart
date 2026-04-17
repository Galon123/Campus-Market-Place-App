class Bid {

  final double price;
  final int quantity;

  Bid({required this.price, required this.quantity});

  factory Bid.fromJson(Map<String, dynamic> json){
    return Bid(
      price: json['price'], 
      quantity: json['quantity']
    );
  }

}