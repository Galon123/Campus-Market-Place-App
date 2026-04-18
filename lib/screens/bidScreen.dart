import 'package:flutter/material.dart';

class MyBids extends StatefulWidget {
  const MyBids({super.key});

  @override
  State<MyBids> createState() => _MyBidsState();
}

class _MyBidsState extends State<MyBids> {
  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: Icon(Icons.arrow_back)
        ),
        title: Text("My Bids", style: text.titleMedium,),
      ),
    );
  }
}