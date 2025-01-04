import 'package:signals/signals_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Example(),
    );
  }
}

class TabIndex extends FlutterSignal<int> {
  TabIndex([super.value = 0]);

  void changeTab(int index) {
    value = index;
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalProvider<TabIndex>(
      create: () => TabIndex(0),
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Bottom Navigation Demo'),
      ),
      body: Watch((context) {
        final tabIndex = SignalProvider.of<TabIndex>(context);
        return IndexedStack(
          index: tabIndex!.value,
          children: const [
            Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
            Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
            Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
          ],
        );
      }),
      bottomNavigationBar: Watch((context) {
        final tabIndex = SignalProvider.of<TabIndex>(context);
        return BottomNavigationBar(
          backgroundColor: Colors.blueAccent,
          currentIndex: tabIndex!.value,
          onTap: tabIndex.changeTab,
          items: const [
            BottomNavigationBarItem(
              tooltip: 'Home',
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              tooltip: 'Search',
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              tooltip: 'Profile',
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
}
