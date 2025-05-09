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
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: const Color.fromARGB(255,200,233,233),
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
      appBar: AppBar(title: Text('Main Page')),
      body: Center(child: Text('Imparare a leggere in Giapponese, weeb')),
      bottomNavigationBar: BottomNavigationBar(   
        backgroundColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        items: [          
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Dizionario'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Parole Memorizzate',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
