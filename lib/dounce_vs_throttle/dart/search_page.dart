import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test2/dounce_vs_throttle/dart/debounce.dart';
import 'package:test2/dounce_vs_throttle/dart/throttle.dart';

class SearchPage extends StatelessWidget {
  final Debounce _debounce = Debounce(duration: const Duration(milliseconds: 500));
  final Throttle _throttle = Throttle(duration: const Duration(seconds: 3));
  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('Search Page',style:TextStyle(color:Colors.white),),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child:Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
               onChanged:(value) {
                  // Handle search logic here
                 getUserInput(value);
                },
                      ),
              const SizedBox(height: 40,),
              ElevatedButton(
                style:ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                  onPressed: (){
                    // Example of using throttle
                    _throttle.call(() {
                      if (kDebugMode) {
                        print("*************************");
                        print('Throttled action executed');
                        print("*************************");
                      }
                    });
                  }, child:const Text('Send otp again')),
            ],
          ),
            ),
      )));
  }

  void getUserInput(String input) {
    _debounce.call(() {
      // Perform search or any other action with the input
      if (kDebugMode) {
        print('//////////////////////');
        print('User input: $input');
        print('//////////////////////');

      }
    });
  }
}
