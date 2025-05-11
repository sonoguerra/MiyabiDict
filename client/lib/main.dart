import 'package:flutter/material.dart';

void main() {

  runApp(const MainApp());
  
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: const Color.fromARGB(255, 200, 233, 233),
          onPrimary: Colors.black,
          secondary: Colors.cyan.shade300,
          onSecondary: Colors.grey,
          error: Colors.yellow,
          onError: Colors.red,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Miyabi')),
      body:
          <Widget>[
            Center(
              child: Text(
                'Learn Japanese',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            DictionaryList(),
            Text("Prova", style: Theme.of(context).textTheme.bodyLarge),
          ][_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.book), label: 'Dizionario'),
          NavigationDestination(
            icon: Icon(Icons.bookmark),
            label: 'Memorizzate',
          ),
        ],
      ),
    );
  }
}
