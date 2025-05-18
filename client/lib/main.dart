import 'package:flutter/material.dart';
import 'package:pwa_dict/dictionary.dart';
import 'package:pwa_dict/memory.dart';

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
          bodyLarge: TextStyle(fontSize: 30),
          bodyMedium: TextStyle(fontSize: 20),
        ),
        colorScheme: ColorScheme(
          brightness:
              Brightness
                  .dark, //92, 143, 143, 254 Violetto               //255,200, 233, 233 Ghiaccio
          primary: const Color.fromARGB(92, 143, 143, 254),
          onPrimary: Colors.black,
          secondary: Color.fromARGB(255, 122, 239, 239),
          onSecondary: Colors.grey,
          error: Colors.yellow,
          onError: Colors.red,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white,
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Miyabi App',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body:
          <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Welcome to Miyabi",
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.3,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea ca",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            DictionaryList(),
            Text("Prova", style: Theme.of(context).textTheme.bodyMedium),
            MemoryGame(),
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
          NavigationDestination(icon: Icon(Icons.gamepad), label: 'Memory'),
        ],
      ),
    );
  }
}
