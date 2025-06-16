import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Scaffold(
      appBar: AppBar(
        title: const Text('Home Page',style:TextStyle(color:Colors.white),),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to the Home Page!', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to another page or perform an action
                },
                child: const Text('Go to Search Page'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
