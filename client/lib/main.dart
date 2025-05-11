import 'package:flutter/material.dart';
import 'package:pwa_dict/dictionary.dart';

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
          bodyLarge: TextStyle(fontSize: 45),
          bodyMedium: TextStyle(fontSize: 32),
        ),
        colorScheme: ColorScheme(
          brightness:
              Brightness
                  .dark, //92, 143, 143, 254 Violetto               //255,200, 233, 233 Ghiaccio
          primary: const Color.fromARGB(92, 143, 143, 254),
          onPrimary: Colors.black,
          secondary: Colors.cyan.shade300,
          onSecondary: Colors.grey,
          error: Colors.yellow,
          onError: Colors.red,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 200, 233, 233),
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
      body:
          <Widget>[   
            Center(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text(
                      "Welcome to Miyabi",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),                    
                    Icon(
                      Icons.mood_bad,                      
                    ),
                  ],
                ),
              ),
            ),
            DictionaryList(),
            Text("Prova", style: Theme.of(context).textTheme.bodyMedium),
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
