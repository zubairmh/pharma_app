import 'package:flutter/material.dart';
import 'package:pharma_app/components/location_state.dart';
import 'package:pharma_app/components/navbar.dart';
import 'package:pharma_app/components/navigator.dart';
import 'package:pharma_app/components/state.dart';
import 'package:pharma_app/home/home.dart';
import 'package:pharma_app/search/search.dart';
import 'package:pharma_app/shopping/shopping_cart.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Pharma());
}

class Pharma extends StatefulWidget {
  const Pharma({super.key});

  @override
  _PharmaState createState() => _PharmaState();
}

class _PharmaState extends State<Pharma> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const CartPage(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CartModel()),
          ChangeNotifierProvider(create: (context) => LocationModel()),
        ],
        child: MaterialApp(
          title: "Pharmalama",
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            extendBody: true,
            body: _pages[_selectedIndex],
            bottomNavigationBar: CustomBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ));
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: const [
        Navbar(),
        // Add account page content here
      ],
    );
  }
}
