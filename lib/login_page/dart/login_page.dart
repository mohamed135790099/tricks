import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Please Register in',
              style: TextStyle(fontSize: 90, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 89),
            ElevatedButton(
              onPressed: () {
                // Handle login logic here
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
