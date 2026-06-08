import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [

          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text("Dark Mode"),
            subtitle: Text("Coming Soon"),
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export Data"),
            subtitle: Text("Coming Soon"),
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.backup),
            title: Text("Backup & Restore"),
            subtitle: Text("Coming Soon"),
          ),
        ],
      ),
    );
  }
}