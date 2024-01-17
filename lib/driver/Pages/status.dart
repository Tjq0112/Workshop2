import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionStatusPage extends StatefulWidget {
  @override
  _CollectionStatusPageState createState() => _CollectionStatusPageState();
}

class _CollectionStatusPageState extends State<CollectionStatusPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> bins = <Map<String, dynamic>>[];

  List<bool> binStatus = List.generate(10, (index) => false);

  // Function to update the status of a bin
  void updateBinStatus(int index, bool value) {
    setState(() {
      binStatus[index] = value;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the notification plugin
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'Waste Wise',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Bins Picked Up',
      'Bins have been collected.',
      platformChannelSpecifics,
      payload: 'notification',
    );
  }

  // Function to fetch bin data from Firestore
  Future<void> fetchBins() async {
    try {
      QuerySnapshot scheduleSnapshot =
      await _firestore.collection('Schedule').get();

      bins = scheduleSnapshot.docs
          .map((doc) {
        Map<String, dynamic> data =
            doc.data() as Map<String, dynamic>? ?? {};

        // Retrieve the necessary fields from the Schedule document
        String binId = data['bin_Id'] ?? '';
        String date = data['date'] ?? '';
        String locationName = data['location'] ?? '';

        return {
          'bin_Id': binId,
          'date': date,
          'location': locationName,
        };
      })
          .toList();
    } catch (e) {
      print('Error fetching bins: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection Status'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'List of Bins for Collection:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder(
                future: fetchBins(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return ListView.builder(
                      itemCount: bins.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bin ID: ${bins[index]['bin_Id']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Date: ${bins[index]['date']}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Location: ${bins[index]['location']}',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          value: binStatus[index],
                          onChanged: (bool? value) {
                            updateBinStatus(index, value ?? false);
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print('Updated Bin Status: $binStatus');
                  showNotification(); // Show notification on status update
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Collection Status Updated')),
                  );
                },
                child: Text('Submit Collection Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}