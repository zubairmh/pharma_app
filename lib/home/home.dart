import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import "package:pharma_app/components/location_state.dart";
import "package:pharma_app/components/navbar.dart";
import "package:provider/provider.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: const [
        Navbar(),
        SizedBox(height: 10),
        Carousel(),
        SizedBox(height: 10),
        Text(
          'Nearby Pharmacies',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        PharmacyList(),
      ],
    );
  }
}

class Carousel extends StatelessWidget {
  const Carousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          CarouselItem(
              imageUrl: 'https://random.imagecdn.app/300/200',
              text: 'Advertisement 1'),
          CarouselItem(
              imageUrl: 'https://random.imagecdn.app/300/200',
              text: 'Advertisement 2'),
          CarouselItem(
              imageUrl: 'https://random.imagecdn.app/300/200',
              text: 'Advertisement 3'),
          // Add more CarouselItems as needed
        ],
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  final String imageUrl;
  final String text;

  const CarouselItem({
    required this.imageUrl,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 250,
      margin: const EdgeInsets.all(10),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                width: 300,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )),
    );
  }
}

class PharmacyList extends StatelessWidget {
  const PharmacyList({super.key});
  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<LocationModel>(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10, // Replace with the actual number of pharmacies
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 400,
                    height: 200,
                    color: const Color.fromARGB(255, 0, 74, 173),
                  )),
              ListTile(
                tileColor: const Color.fromARGB(255, 238, 239, 241),
                title: Text(
                  'Pharmacy $index',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.star,
                        color: Color.fromARGB(255, 248, 114, 4)),
                    const Icon(Icons.star,
                        color: Color.fromARGB(255, 248, 114, 4)),
                    const Icon(Icons.star,
                        color: Color.fromARGB(255, 248, 114, 4)),
                    const Icon(Icons.star,
                        color: Color.fromARGB(255, 248, 114, 4)),
                    const Icon(Icons.star,
                        color: Color.fromARGB(255, 248, 114, 4)),
                    const SizedBox(width: 5),
                    TextButton(
                        onPressed: () {
                          globalState.getCurrentLocation(context);
                        },
                        child: Text("View ${globalState.latitude}")),
                    Text('${index + 1} km'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
