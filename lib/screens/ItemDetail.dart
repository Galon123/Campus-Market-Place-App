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

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).refreshUsername();
  }

  @override
  Widget build(BuildContext context) {

    final username = Provider.of<UserProvider>(context).username;
    final product = widget.product;
    final bool isOwner = product.seller.username == username;

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
    );
  }
}