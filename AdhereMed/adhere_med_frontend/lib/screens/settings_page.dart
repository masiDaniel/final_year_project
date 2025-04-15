import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Help"),
            content: Text(
              "Need assistance? Reach out to support@adheremed.com.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
    );
  }

  void _navigateToChangePassword() {
    Navigator.pushNamed(
      context,
      '/change_password',
    ); // You can define this route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        children: [
          SwitchListTile(
            title: Text("Dark Theme"),
            subtitle: Text("Toggle between light and dark modes"),
            value: isDarkMode,
            onChanged: (val) {
              setState(() {
                isDarkMode = val;
                // TODO: Implement theme switching logic with provider or setState
              });
            },
          ),
          Divider(),

          SwitchListTile(
            title: Text("Notifications"),
            subtitle: Text("Enable or disable push notifications"),
            value: notificationsEnabled,
            onChanged: (val) {
              setState(() {
                notificationsEnabled = val;
              });
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Change Password"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _navigateToChangePassword,
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text("Help"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showHelpDialog,
          ),
          Divider(),

          SizedBox(height: 30),

          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle logout
                Navigator.pushReplacementNamed(context, '/sign_in');
              },
              icon: Icon(Icons.logout),
              label: Text("Log Out"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
