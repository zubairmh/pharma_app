import 'package:flutter/material.dart';
import 'package:pharma_app/components/login_state.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginState>(context);
    return Row(
      children: [
        const CircleAvatar(
          backgroundImage: NetworkImage("https://thispersondoesnotexist.com/"),
        ),
        TextButton(
            onPressed: () {
              loginState.logout();
            },
            child: const Text("Logout"))
      ],
    );
  }
}
