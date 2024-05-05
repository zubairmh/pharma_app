import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:pharma_app/components/api_state.dart";
import "package:pharma_app/components/location_state.dart";
import "package:pharma_app/components/navbar.dart";
import "package:provider/provider.dart";
import 'package:flutter_hooks/flutter_hooks.dart';
import "package:url_launcher/url_launcher.dart";

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
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          CarouselItem(
              imageUrl: 'https://m.media-amazon.com/images/I/61pjwAktvwL.jpg',
              text: ''),
          CarouselItem(
              imageUrl:
                  'https://zoom.ocado.com/productImages/373/373798011_373798011_5_1710948267000_1280x1280.jpg',
              text: ''),
          CarouselItem(
              imageUrl:
                  'https://www.bigbasket.com/media/uploads/p/xxl/40077744-5_1-patanjali-hair-oil-kesh-kanti.jpg',
              text: ''),
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

class PharmacyList extends HookWidget {
  const PharmacyList({super.key});
  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<LocationModel>(context);
    final apiProvider = Provider.of<ApiModel>(context);
    useMemoized(() {
      if (globalState.latitude == 0 || globalState.longitude == 0) {
        globalState.getCurrentLocation(context);
        apiProvider.getNearbyPharmacies(globalState.latitude, globalState.longitude);
      } else {
        // Call the API to get the list of pharmacies
        apiProvider.getNearbyPharmacies(globalState.latitude, globalState.longitude);
      }
      return null;
    }, [globalState.latitude, globalState.longitude]);
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: apiProvider
          .pharmacies.length, // Replace with the actual number of pharmacies
      itemBuilder: (context, index) {
        List<Widget> children = [];
        for (int i = 0;
            i < (apiProvider.pharmacies[index]["rating"] ?? 5);
            i++) {
          children.add(
              const Icon(Icons.star, color: Color.fromARGB(255, 248, 114, 4)));
        }
        children.add(const SizedBox(width: 5));
        children.add(Text(
            '${(Geolocator.distanceBetween(globalState.latitude, globalState.longitude, apiProvider.pharmacies[index]["lat"] ?? 0, apiProvider.pharmacies[index]["long"] ?? 0) / 1000).toStringAsFixed(2)} km'));
        return InkWell(
          onTap: () async => {
            if (!await launchUrl(Uri.parse(
                'https://www.google.com/maps/place/${apiProvider.pharmacies[index]["lat"] ?? 0},${apiProvider.pharmacies[index]["long"] ?? 0}')))
              {throw Exception('Could not launch')}
          },
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      "https://picsum.photos/200/300/?blur=2?xyz=$index",
                      width: 400,
                      height: 200,
                      fit: BoxFit.cover)),
              ListTile(
                tileColor: const Color.fromARGB(255, 238, 239, 241),
                title: Text(
                  '${apiProvider.pharmacies[index]["fullname"]}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                subtitle: Row(children: children),
              ),
            ],
          ),
        );
      },
    );
  }
}
