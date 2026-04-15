import 'package:e_commerce_refactor/models/Product.dart';
import 'package:e_commerce_refactor/providers/ThemeProvider.dart';
import 'package:e_commerce_refactor/providers/UserProvider.dart';
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

    String imageURL;
    if(product.imgUrl!.contains('127.0.0.1') || product.imgUrl!.contains('localhost')){
      imageURL = product.imgUrl!.replaceAll('https://127.0.0.1:8000', BASE_URL);
    }

    return Card(
      color: colors.secondary,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
    );

  }
}