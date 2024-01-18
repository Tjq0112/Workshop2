import 'package:flutter/material.dart';
import 'package:mockapp/pages/map_page.dart'; // Import your map page file
import 'package:mockapp/pages/report.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime date = DateTime(2024, 1, 1);
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Schedule', style: TextStyle(fontSize: 50)),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  child: SizedBox(
                    height: 50.0,
                    width: 150,
                    child: TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Date",
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2100),
                    );

                    if (newDate == null) return;
                    setState(() {
                      date = newDate;
                      dateController.text = "${date.year} - ${date.month} - ${date.day}";
                    });
                  },
                  child: const Icon(Icons.calendar_today),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}