import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pharma_app/components/api_state.dart';
import 'package:pharma_app/components/navbar.dart';
import 'package:pharma_app/components/cart_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<CartModel>(context);
    final apiState = Provider.of<ApiModel>(context);

    var child = <Widget>[
      const Navbar(),
    ];

    if (!globalState.quantities.isNotEmpty) {
      child.add(Container(
          padding: const EdgeInsets.all(50),
          child: const Center(
              child: Text('No items in cart',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)))));
    }
    return ListView(padding: const EdgeInsets.all(10), children: [
      ...child,
      FutureBuilder(
          future: apiState.findStores(globalState.quantities),
          initialData: const [],
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container(
                    padding: const EdgeInsets.all(50),
                    child: const Center(
                        child: Text('Loading...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold))));
              default:
                if (snapshot.hasError) {
                  return Container(
                      padding: const EdgeInsets.all(50),
                      child: Center(
                          child: Text('Error: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold))));
                } else {
                  List data = snapshot.data ?? [];
                  if (data.isEmpty && globalState.quantities.isNotEmpty) {
                    return Container(
                        padding: const EdgeInsets.all(50),
                        child: const Center(
                            child: Text('No stores found',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold))));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final element = data[index];
                      return StoreCard(
                          storeName: element['fullname'],
                          items: element['items'],
                          phone: element['phone'] ?? "",
                          selectedItems: globalState.quantities);
                    },
                  );
                }
            }
          })
    ]
        // ListView.builder(
        //     padding: const EdgeInsets.all(10),
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemCount: apiState.medicine_stores
        //         .length, // Replace with the actual number of pharmacies
        //     itemBuilder: (context, index) {
        //       return StoreCard(
        //         storeName: apiState.medicine_stores[index]['fullname'],
        //         items: apiState.medicine_stores[index]['items'],
        //       );
        //     })
        );
  }
}

class MedicationItem extends StatelessWidget {
  final String name;
  final int quantity;
  const MedicationItem({required this.name, required this.quantity, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text('Quantity: $quantity'),
    );
  }
}

class StoreCard extends StatelessWidget {
  final String storeName;
  final List<dynamic> items;
  final String phone;
  final Map<String, int> selectedItems;

  const StoreCard({
    required this.storeName,
    required this.items,
    required this.selectedItems,
    required this.phone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){launchUrl(Uri.parse('tel:$phone'));},
        child: Card(
      child: Column(
        children: [
          ListTile(
            title: Text(storeName),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedItems.length,
            itemBuilder: (context, index) {
              final itemName = selectedItems.keys.elementAt(index);
              int? itemQuantity = selectedItems[itemName];
              int? itemPrice = items.firstWhere((element) =>
                  element['name'] == itemName.toLowerCase())['price'];

              return ListTile(
                leading: Text(itemName),
                title: Text('Quantity: $itemQuantity'),
                subtitle: Text('Price: ${itemQuantity! * itemPrice!}'),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Total Price'),
            subtitle: Text(calculateTotalPrice(selectedItems, items)),
          ),
        ],
      ),
    ));
  }

  String calculateTotalPrice(
      Map<String, int> selectedItems, List<dynamic> items) {
    int totalPrice = 0;
    selectedItems.forEach((itemName, itemQuantity) {
      int itemPrice = items.firstWhere(
          (element) => element['name'] == itemName.toLowerCase())['price'];
      totalPrice += itemQuantity * itemPrice;
    });
    return totalPrice.toString();
  }
}
      // child.add(IconButton.filled(
      //     onPressed: () {}, icon: const Icon(Icons.shopping_cart)));

      // List<Map<String, Object>> medicines = [];
      // globalState.quantities.forEach((key, value) {
      //   medicines.add({'name': key.toLowerCase(), 'quantity': value});
      // });



      // apiState.findStores(medicines).then((list) => {});
      // for (var element in apiState.medicine_stores) {
      //   print("AAAAAAAAAAAAA");
      //   print(element['items']);
      //   child.add(
      //       StoreCard(storeName: element['fullname'], items: element['items']));

      // print(element);
      // child.add(Text(element['fullname']));
      // child.add(Text(element['id']));
      // }