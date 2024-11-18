// settings_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Future functions for changing password, DOB, etc., can be added here

  Widget _buildSettingsOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingsOption(
              icon: Icons.logout,
              title: 'Log Out',
              onTap: () => _logout(context),
            ),
            Divider(),
            _buildSettingsOption(
              icon: Icons.lock,
              title: 'Change Password',
              onTap: () {
                // Implement change password functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Change Password feature coming soon!')),
                );
              },
            ),
            Divider(),
            _buildSettingsOption(
              icon: Icons.calendar_today,
              title: 'Update Date of Birth',
              onTap: () {
                // Implement update DOB functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Update DOB feature coming soon!')),
                );
              },
            ),
            // Add more settings options as needed
          ],
        ),
      ),
    );
  }
}
