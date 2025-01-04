import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

// global variable
final counter = signal<int>(0);

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Watch.builder'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.value++;
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        // state watch
        child: Watch.builder(builder: (context) {
          return Text('Counter: $counter');
        }),
      ),
    );
  }
}