import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:e_commerce_refactor/models/Product.dart';
import 'package:e_commerce_refactor/providers/ThemeProvider.dart';
import 'package:e_commerce_refactor/providers/UserProvider.dart';
import 'package:e_commerce_refactor/screens/ItemDetail.dart';
import 'package:e_commerce_refactor/services/ApiClient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState(){
    super.initState();

    final provider = Provider.of<UserProvider>(context, listen: false);

    if(provider.products.isEmpty){
      provider.fetchProducts();
    }

    //Fetch next set of items on reaching bottom
    _scrollController.addListener((){
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200){
        provider.fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final provider =Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.filter_alt)
          ),
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.search)
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(

        ),
        child: RefreshIndicator(
          onRefresh: () async{ await provider.refreshFeed(); },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(8.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildProductCard(provider.products[index], colors),
                    childCount: provider.products.length,
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, ColorScheme colors){

    String imageUrl = product.images.isNotEmpty
    ? '${Apiclient.baseUrl}/${product.images[0].imagePath}'
    : 'https://img.freepik.com/free-vector/illustration-gallery-icon_53876-27002.jpg'
    ;
    

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(12),
      dashPattern: [24,4],
      color: colors.primary,
      strokeWidth: 1.5,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItemDetail(product: product))
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Image Section
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
              
              // 2. Info Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colors.onPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "₹${product.minPrice}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text("Quantity : ${product.quantity}"),
                    SizedBox(height: 8,),
                    Wrap(
                      spacing: 8,
                      children: product.categories.map((category) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(category, style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.w700),),
                        );
                      }
                      ).toList()
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}