import 'package:blitz/pages/AboutUs.dart';
import 'package:blitz/pages/checkoutPage.dart';
import 'package:blitz/pages/favoritePage.dart';
import 'package:blitz/pages/homePage.dart';
import 'package:blitz/pages/itemPage.dart';
import 'package:blitz/pages/paymentPage.dart';
import 'package:blitz/pages/profilePage.dart';
import 'package:blitz/pages/signinPage.dart';
import 'package:blitz/widgets/BottomCartSheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_utils/intl_utils.dart' as IntlUtils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF121212),
      ),
      initialRoute: currentUser != null ? "homePage" : "/",
      routes: {
        "/": (context) => SigninPage(),
        "homePage": (context) => HomePage(),
        "itemPage": (context) => ItemPage(),
        "cartPage": (context) => BottomCartSheet(),
        "aboutUs": (context) => AboutUsScreen(),
        "favoritePage": (context) => FavoritePage(),
        "profilePage": (context) => ProfilePage(),
        'checkoutPage': (context) => CheckoutPage(),
      },
    );
  }
}
