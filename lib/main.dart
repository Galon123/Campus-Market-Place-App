import 'package:e_commerce_refactor/providers/ThemeProvider.dart';
import 'package:e_commerce_refactor/theme/AppTheme.dart';
import 'package:e_commerce_refactor/theme/constants.dart';
import 'package:e_commerce_refactor/providers/UserProvider.dart';
import 'package:e_commerce_refactor/screens/bidScreen.dart';
import 'package:e_commerce_refactor/screens/feedScreen.dart';
import 'package:e_commerce_refactor/screens/listingScreen.dart';
import 'package:e_commerce_refactor/screens/loginScreen.dart';
import 'package:e_commerce_refactor/screens/mainNavigationHub.dart';
import 'package:e_commerce_refactor/screens/registerScreen.dart';
import 'package:e_commerce_refactor/services/ApiClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Apiclient.setup();
  
  bool sessionExists = await Apiclient.hasValidSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(initialLoginState: sessionExists)),
        ChangeNotifierProvider(create: (_) => ThemeProvider())
      ],
      child: const MarketplaceApp(),
    )
  );
}

class MarketplaceApp extends StatelessWidget {
  const MarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return userProvider.isLoggedIn 
          ? const MainNavigationHub()
          : const LoginScreen();
        }
      )
      ,
      routes: {
        '/login' : (context) => const LoginScreen(),
        '/register' : (context) => const RegisterScreen(),
        '/feed' : (context) => const FeedScreen(),
        '/mybids' : (context) => const MyBids(),
        '/mylistings' : (context) => const MyListings()
      },
      theme: Apptheme.light,
      darkTheme: Apptheme.dark,
      themeMode: themeProvider.themeMode,
    );
  }
}