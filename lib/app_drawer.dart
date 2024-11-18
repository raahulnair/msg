// app_drawer.dart
import 'package:flutter/material.dart';
import 'message_boards_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  
  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(''),
      accountEmail: Text(''),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.person,
          size: 40,
          color: Colors.blueAccent,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildDrawerOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(),
          _buildDrawerOption(
            icon: Icons.message,
            title: 'Message Boards',
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MessageBoardsPage()),
              );
            },
          ),
          Divider(),
          _buildDrawerOption(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          Divider(),
          _buildDrawerOption(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          Divider(),
          // Add more drawer options if needed
        ],
      ),
    );
  }
}
