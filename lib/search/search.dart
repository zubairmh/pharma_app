import "package:flutter/material.dart";
import "package:pharma_app/components/navbar.dart";
import "package:pharma_app/components/cart_state.dart";
import "package:provider/provider.dart";

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> medications = [
    "Dolo",
    "Vicks",
    "Aspirin",
    "Paracetamol",
    "Ibuprofen",
    "Amoxicillin",
    "Ciprofloxacin",
    "Omeprazole",
    "Metformin",
    "Simvastatin",
    "Lisinopril",
    "Levothyroxine",
    "Atorvastatin",
    "Azithromycin",
    "Prednisone",
    "Albuterol",
    "Doxycycline",
    "Fluoxetine",
    "Losartan",
    "Warfarin",
    "Ranitidine",
    "Pantoprazole"
  ];

  List<String> filteredMedications = [];

  @override
  void initState() {
    super.initState();
    filteredMedications.addAll(medications);
  }

  void filterMedications(String query) {
    setState(() {
      filteredMedications = medications
          .where((medication) =>
              medication.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<CartModel>(context);
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        const Navbar(),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.grey[200],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: filterMedications,
            decoration: const InputDecoration(
              hintText: "Search",
              border: InputBorder.none,
              icon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredMedications.length,
          itemBuilder: (context, index) {
            String medication = filteredMedications[index];
            return ListTile(
              title: Row(
                children: [
                  Expanded(child: Text(medication)),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => globalState.remove(medication),
                  ),
                  Text(globalState.quantities.containsKey(medication)
                      ? globalState.quantities[medication].toString()
                      : "0"),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => globalState.add(medication),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
