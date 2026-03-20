import 'package:e_commerce_refactor/constants.dart';
import 'package:e_commerce_refactor/providers/UserProvider.dart';
import 'package:e_commerce_refactor/screens/bidScreen.dart';
import 'package:e_commerce_refactor/screens/feedScreen.dart';
import 'package:e_commerce_refactor/screens/listingScreen.dart';
import 'package:e_commerce_refactor/screens/loginScreen.dart';
import 'package:e_commerce_refactor/screens/mainNavigationHub.dart';
import 'package:e_commerce_refactor/screens/registerScreen.dart';
import 'package:e_commerce_refactor/services/ApiClient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Apiclient.setup();
  
  bool sessionExists = await Apiclient.hasValidSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(initialLoginState: sessionExists) 
        )
      ],
      child: const MarketplaceApp(),
    )
  );
}

class MarketplaceApp extends StatelessWidget {
  const MarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {

    final userProvider = context.watch<UserProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userProvider.username == "Guest"
      ? const LoginScreen()
      : MainNavigationHub()
      ,
      routes: {
        '/login' : (context) => const LoginScreen(),
        '/register' : (context) => const RegisterScreen(),
        '/feed' : (context) => const FeedScreen(),
        '/mybids' : (context) => const MyBids(),
        '/mylistings' : (context) => const MyListings()
      },
      theme: ThemeData(
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((state) {
            if(state.contains(WidgetState.selected)){
              return TextStyle(
                fontSize: AppTextSizes.mediumText,
                fontWeight: FontWeight.bold,
                color: AppColors.textComplemtaryColor
              );
            }
          })
        )
      ),
    );
  }
}