import 'package:flutter/material.dart';
import 'dictionary.dart';
import 'memory.dart';
import 'saved_words.dart';

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
          brightness: Brightness.dark,
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
  const HomePage({super.key});

  @override
  createState() => _MyHomePageState();
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

    List<Widget> mainScreen = [
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
      SavedWords(),
      MemoryGame(),
    ];

    return (MediaQuery.of(context).orientation == Orientation.portrait && MediaQuery.of(context).size.aspectRatio > 1.2)
        ? Scaffold(
          appBar: AppBar(
            title: Image.asset("assets/logo.png", height: 70),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          body: mainScreen[_selectedIndex],

          bottomNavigationBar: NavigationBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.inversePrimary,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(
                icon: Icon(Icons.book),
                label: 'Dizionario',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark),
                label: 'Memorizzate',
              ),
              NavigationDestination(icon: Icon(Icons.gamepad), label: 'Memory'),
            ],
          ),
        )
        : Scaffold(
          appBar: AppBar(
            title: Image.asset("assets/logo.png", height: 70),
            centerTitle: true,






            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          body: Row(
            children: [
              NavigationRail(
                leading: const SizedBox(height: 50),
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
                backgroundColor: Theme.of(context).colorScheme.primary,
                indicatorColor: Theme.of(context).colorScheme.inversePrimary,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.book),
                    label: Text('Dizionario'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.bookmark),
                    label: Text('Memorizzate'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.gamepad),
                    label: Text('Memory'),
                  ),
                ],
              ),
              Expanded(child: mainScreen[_selectedIndex])
            ],
          ),
        );
  }
}
