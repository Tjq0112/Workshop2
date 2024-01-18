import 'package:flutter/material.dart';
import 'package:mockapp/Driver/Pages/profile.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Waste Collection Settings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: SettingsList(),
      ),
    );
  }
}

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Account Settings'),
          onTap: () {
            // Navigate to account settings page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DriverProfilePage(driverId: '',)),
            );
          },
        ),
        ListTile(
          title: Text('Notification Settings'),
          onTap: () {
            // Navigate to notification settings page
            // Implement navigation logic here
          },
        ),
        ListTile(
          title: Text('Collection Settings'),
          onTap: () {
            // Navigate to collection settings page
            // Implement navigation logic here
          },
        ),
        ListTile(
          title: Text('Usage Analytics'),
          onTap: () {
            // Navigate to usage analytics page
            // Implement navigation logic here
          },
        ),
        ListTile(
          title: Text('System Preferences'),
          onTap: () {
            // Navigate to system preferences page
            // Implement navigation logic here
          },
        ),
        ListTile(
          title: Text('Help & Support'),
          onTap: () {
            // Navigate to help & support page
            // Implement navigation logic here
          },
        ),
        ListTile(
          title: Text('Log Out'),
          onTap: () {
            // Implement logout functionality
            // Implement logout logic here
          },
        ),
      ],
    );
  }
}
