import 'package:e_commerce_refactor/models/Product.dart';
import 'package:e_commerce_refactor/providers/UserProvider.dart';
import 'package:e_commerce_refactor/services/ApiClient.dart';
import 'package:e_commerce_refactor/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemDetail extends StatefulWidget {
  
  final Product product;
  const ItemDetail({super.key, required this.product});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {

  List _bids = [];

  List get bids => _bids;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).refreshUsername();
    fetchBids();
  }

  void fetchBids() async{

    try{

      final response = await Apiclient.dio.get('/items/${widget.product.id}');

      setState(() {
        _bids = response.data['bids'];
      });

    }catch(e){
      debugPrint("Error in fetching bids of particular Item");
    }
  }

  void _showBidSheet(BuildContext context, int itemId, double minPrice) {
    final TextEditingController bidController = TextEditingController();
    final TextEditingController quantController = TextEditingController();

    String? errorMessageBid;
    String? errorMessageQuant; 
  
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder( // Allows the sheet to update itself
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Place Your Bid (Min: ₹$minPrice)",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: bidController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  prefixText: "₹ ",
                  labelText: "Your Bid Amount",
                  errorText: errorMessageBid, // Displays the error red text
                  border: const OutlineInputBorder(),
                ),
                onChanged: (val) {
                  // Clear error as user types
                  if (errorMessageBid != null) {
                    setSheetState(() => errorMessageBid = null);
                  }
                },
              ),
              SizedBox(height: 10,),
              TextField(
                controller: quantController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  errorText: errorMessageQuant, // Displays the error red text
                  border: const OutlineInputBorder(),
                ),
                onChanged: (val) {
                  // Clear error as user types
                  if (errorMessageQuant != null) {
                    setSheetState(() => errorMessageQuant = null);
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  onPressed: () {
                    bool bidSuccess = false, quantSuccess = false;
                    final double? enteredAmount = double.tryParse(bidController.text);
                    final int? enteredQuant = int.tryParse(quantController.text);
                    
                    // Validation Logic
                    if (enteredAmount == null) {
                      setSheetState(() => errorMessageBid = "Please enter a valid number");
                    } else if (enteredAmount < minPrice) {
                      setSheetState(() => errorMessageBid = "Bid must be at least ₹$minPrice");
                    } else {
                      bidSuccess = true;
                    }

                    if(enteredQuant == null || enteredQuant <= 0){
                      setSheetState(() => errorMessageQuant = "Please Enter a Valid Quantity");
                    } else if(enteredQuant > widget.product.quantity){
                      setSheetState(() => errorMessageQuant = "Quantity cannot be greater than available amount");
                    } else {
                      quantSuccess = true;
                    }

                    if(bidSuccess && quantSuccess){
                      _placeBid(context, itemId, enteredAmount!, enteredQuant!);
                    }

                  },
                  child: const Text("Confirm Bid", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _placeBid(BuildContext context, int itemId, double amount, int quantity) async {
    try {
      final response = await Apiclient.dio.post("/bids/$itemId", data: {
        "price": amount,
        "quantity": quantity
      });

      if (response.statusCode == 200) {
        final response = await Apiclient.dio.get('/items/${widget.product.id}');

        setState(() {
          _bids = response.data['bids'];

        });



        Navigator.pop(context); // Close sheet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Bid of ₹$amount placed successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // If backend returns a 400 (e.g., bid too low compared to others)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not place bid. Try a higher amount.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final username = Provider.of<UserProvider>(context).username;
    final product = widget.product;
    final bool isOwner = product.seller.username == username;
    final bool alreadyBid = bids.any((bid) => bid['bider']['username'] == username);

    String imageUrl = product.images.isNotEmpty
    ? '${Apiclient.baseUrl}/${product.images[0].imagePath}'
    : 'https://img.freepik.com/free-vector/illustration-gallery-icon_53876-27002.jpg'
    ;

    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Item Detail"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.report_problem)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [  
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    product.title,
                    style: text.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${product.minPrice}',
                    style: TextStyle(
                      color: colors.success,
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Divider(height: 30, color: colors.surfaceDim,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(child: Icon(Icons.person),),
                      const SizedBox(width: 8,),
                      Text(
                        'Listed by ${product.seller.username} '
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.star),
                      Text('${product.seller.rating}')
                    ],
                  ),

                  const SizedBox(height: 20,),

                  Text(
                    "Description",
                    style: text.titleMedium,
                  ),
                  const SizedBox(height: 8,),

                  Text(
                    product.description,
                    style: text.bodyMedium,
                  )
                ],
              ),
            )


          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.secondary,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)],
        ),
          child:isOwner || alreadyBid? 
          ElevatedButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsetsGeometry.all(20)),
              backgroundColor: WidgetStateProperty.all(Colors.grey.shade300),
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))
            ),
            onPressed: () => {},
            child: const Text("Cannot Bid"),
          ):
          ElevatedButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsetsGeometry.all(20)),
              backgroundColor: WidgetStateProperty.all(Colors.greenAccent.shade400),
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))
            ),
            onPressed: () => _showBidSheet(context, widget.product.id, widget.product.minPrice),
            child:Text("Place Bid"),
          ),
        ),
    );
  }
}
