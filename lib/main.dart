import 'package:flutter/material.dart';
import 'package:pharma_app/components/api_state.dart';
import 'package:pharma_app/components/home_state.dart';
import 'package:pharma_app/components/location_state.dart';
import 'package:pharma_app/components/login_state.dart';
import 'package:pharma_app/components/navbar.dart';
import 'package:pharma_app/components/navigator.dart';
import 'package:pharma_app/components/cart_state.dart';
import 'package:pharma_app/home/home.dart';
import 'package:pharma_app/login/login.dart';
import 'package:pharma_app/search/search.dart';
import 'package:pharma_app/shopping/shopping_cart.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CartModel()),
    ChangeNotifierProvider(create: (context) => LocationModel()),
    ChangeNotifierProvider(create: (context) => LoginState()),
    ChangeNotifierProvider(create: (context) => ApiModel()),
    ChangeNotifierProxyProvider<LoginState, HomeState>(
      update: (_, auth, homeState) => homeState!..update(auth),
      create: (_) => HomeState(),
    ),
  ], child: Pharma()));
}

class Pharma extends StatelessWidget {
  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const CartPage(),
    const AccountPage(),
  ];

  Pharma({super.key});

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<HomeState>(context);
    return MaterialApp(
      title: "Pharmalama",
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        extendBody: true,
        body: _pages[globalState.index],
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: globalState.index,
          onItemTapped: (index) {
            globalState.setIndex(index);
          },
        ),
      ),
    );
  }
}
