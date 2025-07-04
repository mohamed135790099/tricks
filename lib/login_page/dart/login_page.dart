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
        title: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              children: [
                const Text('Login Page'),
                const Text('Login Page - Test2 User Login'),
                Container(
                  height: 2,
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            )
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
                // Call the login function with test user credentials
                login('test2user', 'test2user@gmail.com','12345678');
              },
              child: const Text('Login Test2 User Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login(String userName, String email ,String password) async {
    // Simulate a login process
    await Future.delayed(const Duration(seconds: 2));
    // After login, navigate to the home page or another page
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
