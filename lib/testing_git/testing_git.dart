import 'package:flutter/material.dart';

class TestingGit extends StatefulWidget {
  const TestingGit({super.key});

  @override
  State<TestingGit> createState() => _TestingGitState();
}

class _TestingGitState extends State<TestingGit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Git'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Testing Git Page',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next page or perform an action
              },
              child: const Text('Go to Next Page'),
            ),
          ],
        ),
      ),
    );
  }
}
