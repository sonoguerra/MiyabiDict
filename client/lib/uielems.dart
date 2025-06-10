import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pwa_dict/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'main.dart';

//The logic for the AppBar was starting to become complicated, so this should make for a reusable modular component.
class CustomBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      actions: [InfoButton(), SettingsButton(), LoginOut()],
      title: Text("みやび", style: GoogleFonts.shipporiMincho(fontSize: 38.0)),
      actionsPadding: EdgeInsets.all(8.0),
      elevation: 10.0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class InfoButton extends StatelessWidget {
  const InfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info_outline),
      onPressed: () {
        showLicensePage(context: context, applicationName: "Miyabi");
      },
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        showDialog(context: context, builder: (context) => SettingsDialog());
      },
    );
  }
}

class LoginOut extends StatelessWidget {
  const LoginOut({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.userChanges(),
      builder: (context, snapshot) {
        return snapshot.hasData
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
            : ElevatedButton(
              child: Text("Login"),
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            );
      },
    );
  }
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
                } else {
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
