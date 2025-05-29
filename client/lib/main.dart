import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'saved_words.dart';
import 'memory.dart';
import 'dictionary.dart';
import 'login.dart';

var auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.platform);
  runApp(MainApp());
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

    return (MediaQuery.of(context).orientation == Orientation.portrait)
        ? Scaffold(
          appBar: CustomBar(),
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
          appBar: CustomBar(),
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _selectedIndex,
                groupAlignment: 0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                indicatorColor: Theme.of(context).colorScheme.inversePrimary,
                onDestinationSelected: _onItemTapped,
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
              const VerticalDivider(thickness: 1, width: 1, color: Colors.grey),
              Expanded(child: mainScreen[_selectedIndex]),
            ],
          ),
        );
  }
}

//The logic for the AppBar was starting to become complicated, so this should make for a reusable modular component.
class CustomBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.userChanges(),
      builder: (context, snapshot) {
        return AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          actions: [
            IconButton(icon: Icon(Icons.contrast), onPressed: () {}),
            snapshot.hasData
                ? IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async => await auth.signOut(),
                )
                : IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
          ],
          title: Image.asset("assets/logo.png", height: 70),
          actionsPadding: EdgeInsets.all(8.0),
          elevation: 10.0,
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
