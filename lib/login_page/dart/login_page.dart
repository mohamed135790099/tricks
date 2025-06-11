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
        centerTitle:true,
        title: const Column(
          children: [
            Text('Login Page - Test2 User Login'),
            Text('Login Page - Test2 User Login'),
            Text('Login Page - Test2 User Login'),
            Text('Login Page - Test2 User Login'),
            Text('Login Page - Test2 User Login'),

          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous page
          },
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.login,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const Text(
              'Please log in Test2 User Login',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle login logic here
              },
              child: const Text('Login Test2 User Login'),
            ),
          ],
        ),
      ),
    );
  }
}
