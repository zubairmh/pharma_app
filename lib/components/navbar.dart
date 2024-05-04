import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage("https://thispersondoesnotexist.com/"),
        )
      ],
    );
  }
}
