
import 'package:flutter/material.dart';
class RestablePage extends StatefulWidget {
  const RestablePage({super.key});

  @override
  State<RestablePage> createState() => _RestablePageState();
}

class _RestablePageState extends State<RestablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restable Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Restable Page',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next page or perform an action
              },
              child: const Text('Go to Restable'),
            ),
          ],
        ),
      ),
    );
  }
}
