import 'package:e_commerce_refactor/constants.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientColor1, AppColors.gradientColor2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )
        ),
      ),
    );
  }
}