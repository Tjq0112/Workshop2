import 'package:flutter/material.dart';
import 'schedule.dart';
import 'map_page.dart'; // Import your map page file

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Report', style: TextStyle(fontSize: 50))),
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
                            builder: (context) => Schedule(),
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('&Schedule'),
                    ),
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Report(),
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('&Report'),
                    ),
                    // Add the button to go back to the map page
                    MenuItemButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapPage(), // Replace with your map page class
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('&Back to Map'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
