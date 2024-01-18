import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver Image Upload',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageUploadScreen(),
    );
  }
}

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  // Other existing code...

  Future<void> fetchDriverData() async {
    try {
      // Reference to the 'drivers' collection in Firestore
      CollectionReference drivers = FirebaseFirestore.instance.collection('drivers');

      // Get the document for the currently logged-in user (you need to implement authentication)
      DocumentSnapshot driverSnapshot = await drivers.doc('current_user_id').get();

      // Extract and display relevant data
      if (driverSnapshot.exists) {
        print('Driver data: ${driverSnapshot.data()}');
      } else {
        print('Driver data not found.');
      }
    } catch (e) {
      print('Error fetching driver data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload/Update Driver Image'),
      ),
      body: Column(
        children: [
          // Existing code...

          ElevatedButton(
            onPressed: () {
              fetchDriverData(); // Call this function to fetch driver data from Firestore
            },
            child: Text('Fetch Driver Data'),
          ),
        ],
      ),
    );
  }
}
