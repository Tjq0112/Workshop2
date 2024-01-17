import 'package:flutter/material.dart';
import 'package:mockapp/user/controller/user_controller.dart';
import 'package:mockapp/user/view/update_privacy.dart';
import 'package:mockapp/user/view/update_profile.dart';
import 'package:mockapp/user/view/user_login.dart';

class SettingsPage extends StatefulWidget {
  final String loginId;
  const SettingsPage({Key? key, required this.loginId}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  late List<String> userDetails = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('Account Settings'),
            leading: Icon(Icons.account_circle),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateProfilePage(loginId: widget.loginId)));
            },
          ),
          ListTile(
            title: Text('Privacy Settings'),
            leading: Icon(Icons.lock),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdatePrivacyPage(loginId: widget.loginId)));
            },
          ),
          ListTile(
            title: Text('About'),
            leading: Icon(Icons.info),
            onTap: () {
              // Handle about page
              print('About tapped');
            },
          ),
          Divider(),
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User has been logged out successfully.'),
                ),
              );
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
