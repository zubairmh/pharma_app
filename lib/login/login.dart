import 'package:flutter/material.dart';
import 'package:pharma_app/components/home_state.dart';
import 'package:pharma_app/components/login_state.dart';
import 'package:provider/provider.dart';

import '../components/navbar.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginState>(context);
    final globalState = Provider.of<HomeState>(context);
    return ListView(
      padding: const EdgeInsets.all(60),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginState.username,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: loginState.password,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                if (await loginState.login()) {
                  globalState.setIndex(0);
                } else {
                  print('Login failed');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        )
      ],
    );
  }
}
