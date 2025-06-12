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
          bodyLarge: GoogleFonts.notoSansJp(fontSize: MediaQuery.textScalerOf(context).scale(25.0)),
          bodyMedium: GoogleFonts.notoSansJp(fontSize: MediaQuery.textScalerOf(context).scale(18.0)),
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
  MapEntry<String, String> randomSentence = JPUtils.sentences.entries.elementAt(
    Random().nextInt(
      JPUtils.sentences.length,
    ), //Gets a random sentence to display in the homepage
  );
  List<Widget> mainScreen = [];

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
    bool isLargeScreen = MediaQuery.sizeOf(context).width > 600;

    mainScreen = [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16.0,
          children: [
            Tooltip(
              message: "Welcome to Miyabi!",
              child: Text(
                "みやびへようこそ！",
                style: GoogleFonts.shipporiMincho(fontSize: MediaQuery.textScalerOf(context).scale(38.0)),
              ),
            ),
            Column(
              children: [
                Text(randomSentence.value),
                Text(
                  "Meaning: ${randomSentence.key}",
                  style: GoogleFonts.notoSansJp(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const DictionaryList(key: Key("dictionary")),
      const SavedWords(key: Key("saved")),
      const MatchingGame(key: Key("matching")),
    ];

    return FutureBuilder(
      future: _completer.future,
      builder: (context, snapshot) {
        if (ConnectionState.done != snapshot.connectionState) {
          return const Scaffold(body: LinearProgressIndicator());
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: isLargeScreen ? null : CustomBar(),
            bottomNavigationBar:
                isLargeScreen
                    ? null
                    : NavigationBar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      indicatorColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: _onItemTapped,
                      destinations: [
                        NavigationDestination(
                          label: 'Home',
                          icon: Icon(Icons.home),
                        ),
                        NavigationDestination(
                          label: 'Dictionary',
                          icon: Icon(Icons.book),
                        ),
                        NavigationDestination(
                          label: 'Collection',
                          icon: Icon(Icons.bookmark),
                        ),
                        NavigationDestination(
                          label: 'Matching',
                          icon: Icon(Icons.gamepad),
                        ),
                      ],
                    ),
            body: Row(
              children: [
                if (isLargeScreen)
                  NavigationRail(
                    leading: Column(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.all(16.0),
                          child: Text(
                            "みやび",
                            style: GoogleFonts.shipporiMincho(fontSize: MediaQuery.textScalerOf(context).scale(38.0)),
                          ),
                        ),
                        Row(
                          children: [
                            LoginOut(),
                            InfoButton(),
                            SettingsButton(),
                          ],
                        ),
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
                        label: Text('Home'),
                        icon: Icon(Icons.home),
                      ),
                      NavigationRailDestination(
                        label: Text('Dictionary'),
                        icon: Icon(Icons.book),
                      ),
                      NavigationRailDestination(
                        label: Text('Collection'),
                        icon: Icon(Icons.bookmark),
                      ),
                      NavigationRailDestination(
                        label: Text('Matching'),
                        icon: Icon(Icons.gamepad),
                      ),
                    ],
                  ),
                if (isLargeScreen)
                  const VerticalDivider(
                    thickness: 1,
                    width: 1,
                    color: Colors.grey,
                  ),
                Expanded(
                  child: IndexedStack(


                    
                      index: _selectedIndex,
                      children: mainScreen,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
