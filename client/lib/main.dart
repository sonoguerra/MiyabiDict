import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'saved_words.dart';
import 'memory.dart';
import 'dictionary.dart';
import 'login.dart';
import 'package:web/web.dart' as web;
import 'database.dart';

var auth = FirebaseAuth.instance;
Map tagMap = {};

void main() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final dictionary = await rootBundle.loadString('assets/license.txt');
    yield LicenseEntryWithLineBreaks(['Dictionary'], dictionary);
    final fonts = await rootBundle.loadString('assets/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], fonts);
  });
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.platform);
  //This method is shown as deprecated but is actually the right option on the web platform.
  FirebaseFirestore.instance.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
  FirebaseFirestore.instance.settings = Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.notoSansJp(fontSize: 22.0),
          bodyMedium: GoogleFonts.notoSansJp(fontSize: 19.0),
        ),
        colorScheme: ColorScheme(
          brightness: Brightness.light,
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
  Completer _completer = Completer();

  void initialize() async {
    //TODO: Errors management?
    tagMap = await Database.retrieveTags();
    await GoogleFonts.pendingFonts([
      GoogleFonts.shipporiMincho(),
      GoogleFonts.ebGaramond(),
      GoogleFonts.notoSansJp(),
    ]);
    setState(() {
      _completer.complete(false);
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

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

    var scaffold =
        (MediaQuery.of(context).orientation == Orientation.portrait)
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
                    label: 'Dictionary',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.bookmark),
                    label: 'Collection',
                  ),

                  NavigationDestination(
                    icon: Icon(Icons.gamepad),
                    label: 'Memory',
                  ),
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
                    indicatorColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    onDestinationSelected: _onItemTapped,
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.book),
                        label: Text('Dictionary'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.bookmark),
                        label: Text('Collection'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.gamepad),
                        label: Text('Memory'),
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    width: 1,
                    color: Colors.grey,
                  ),
                  Expanded(child: mainScreen[_selectedIndex]),
                ],
              ),
            );

    return FutureBuilder(
      future: _completer.future,
      builder: (context, snapshot) {
        if (ConnectionState.done != snapshot.connectionState) {
          return Scaffold(body: const LinearProgressIndicator());
        } else {
          return scaffold;
        }
      },
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
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                showLicensePage(context: context, applicationName: "Miyabi");
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => SettingsDialog(),
                );
              },
            ),
            snapshot.hasData
                ? IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await auth.signOut();
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Signed out.")));
                    }
                  },
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

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool _toggled = false;
  late Future<bool> _installed;

  @override
  void initState() {
    super.initState();
    _installed = Database.isDatabaseInstalled();
    initialToggle();
  }

  void initialToggle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var local = prefs.getBool("useLocalDictionary");
    if (local != null) {
      setState(() {
        _toggled = local;
      });
    }
  }

  void toggle() async {
    setState(() => _toggled = !_toggled);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("useLocalDictionary", _toggled);
  }

  void delete() async {
    setState(() {
      _installed = Database.delete();
    });
  }

  void install() async {
    setState(() {
      _installed = Database.download();
    });
  }







  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Row(
          children: [
            Text("Download dictionary"),
            FutureBuilder(
              future: _installed,
              builder: (context, snapshot) {
                if (ConnectionState.done == snapshot.connectionState) {
                  if (true == snapshot.data) {
                    //The compiler gives an error if this condition isn't written explicitly
                      return IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: delete,
                      );
                  } else {
                      return IconButton(
                        icon: Icon(Icons.download),
                        onPressed: install,
                      );
                    }
                  }
                   else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
        SwitchListTile(
          title: Text("Use locally installed dictionary as default."),
          subtitle: Text(
            "Enabling this option is recommended in case of slow internet speed or if you're using mobile data. Not recommended with slow or older devices.",
          ),
          value: _toggled,
          onChanged: (value) => toggle(),
        ),
      ],
    );
  }
}
