import 'package:mockapp/admin/Login.dart';
import 'package:mockapp/admin/Schedule.dart';
import 'package:flutter/material.dart';

import 'Driver.dart';
import 'Fixed.dart';
import 'ManageDriver.dart';
import 'Setting.dart';
import 'package:mockapp/pages/map_page.dart';

class Menu extends StatefulWidget {
  final String username;
  final String password;

  Menu({required this.username, required this.password});

  @override
  State<Menu> createState() => _MenuState(username, password);
}

class _MenuState extends State<Menu> {
  String username;
  String password;

  _MenuState(this.username, this.password);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
          child: const Text('Main Menu', style: TextStyle(fontSize: 50)),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: MenuBar(
                  children: <Widget>[
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Fixed(username: username,password: password)
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('&Fixed'),
                    ),
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Schedule(username: username,password: password)
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('&Demand'),
                    ),
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageDriver(username: username,password: password)
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('&Manage Driver'),
                    ),
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Driver(username: username,password: password)
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('&Add Driver'),
                    ),
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapPage()), // Add this line for MapPage navigation
                        );
                      },
                      child: const MenuAcceleratorLabel('&Map'),
                    ),
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Setting(username: username,password: password)
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('Setting'),
                    ),
                    MenuItemButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Do you sure you want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()
                                  ),
                                );},
                              child: const Text('Sure'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ),
                      child: const MenuAcceleratorLabel('&Logout'),
                    ),
                  ],

                ),

              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('assets/wasteCollect1.png'),
            ),
          )
        ],
      ),
    );
  }
}
