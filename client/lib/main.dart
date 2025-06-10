import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'jputils.dart';
import 'saved_words.dart';
import 'matching.dart';
import 'dictionary.dart';
import 'database.dart';
import 'uielems.dart';

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
  //FirebaseFirestore.instance.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
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
          primary: const Color(0xFF65B891),
          onPrimary: Colors.black,
          secondary: Color(0xFF93E5AB),
          onSecondary: Colors.grey,
          tertiary: Color(0xFFB5FFE1),
          onTertiary: Colors.black12,
          error: Colors.red,
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
  const HomePage({super.key});

  @override
  createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final Completer _completer = Completer();

  void initialize() async {
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

    MapEntry<String, String> randomSentence = JPUtils.sentences.entries.elementAt(Random().nextInt(JPUtils.sentences.length));

    List<Widget> mainScreen = [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16.0,
          children: [
            Tooltip(message: "Welcome to Miyabi!", child: Text("みやびへようこそ！", style: GoogleFonts.shipporiMincho(fontSize: 38.0))),
            Column(children: [Text(randomSentence.value),
            Text("Meaning: ${randomSentence.key}", style: GoogleFonts.notoSansJp(color: Colors.grey, fontStyle: FontStyle.italic))])
          ],
        ),
      ),
      DictionaryList(),
      SavedWords(),
      MatchingGame(),
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
                    label: 'Matching',
                  ),
                ],
              ),
            )
            : Scaffold(
              body: Row(
                children: [
                  NavigationRail(
                    leading: Column(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.all(16.0),
                          child: Text(
                            "みやび",
                            style: GoogleFonts.shipporiMincho(fontSize: 38.0),
                          ),
                        ),
                        Row(children: [LoginOut(),
                        InfoButton(),
                        SettingsButton()]),
                      ],
                    ),
                    selectedIndex: _selectedIndex,
                    extended: true,
                    groupAlignment: 0,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    indicatorColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    onDestinationSelected: _onItemTapped,
                    labelType: NavigationRailLabelType.none,
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
                        label: Text('Matching'),
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
