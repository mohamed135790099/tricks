import 'package:flutter/material.dart';

class InheritedWidget extends StatefulWidget {
  const InheritedWidget({super.key});

  @override
  State<InheritedWidget> createState() => _InheritedWidgetState();
}

class _InheritedWidgetState extends State<InheritedWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Inherited Widget Example'),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Go to Second Page'),
            ),
          ],
        ),
      ),
    ));
  }
}
