import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String driverId; // Add driverId parameter

  DriverProfilePage({required this.driverId}); // Constructor to receive driverId

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Profile'),
      ),
      body: FutureBuilder(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic>? userData = snapshot.data;

            if (userData != null) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80.0,
                      // You can use userData['imageUrl'] if you store an image URL in your Firestore document
                      backgroundImage: AssetImage('assets/driver_image.jpg'),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      userData['name'] ?? '', // Replace with the actual field in your Firestore document
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildDetailRow('Email', userData['email'] ?? 'N/A'),
                    _buildDetailRow('IC Number', userData['ic number'] ?? 'N/A'),
                    _buildDetailRow('ID', userData['id'] ?? 'N/A'),
                    _buildDetailRow('Name', userData['name'] ?? 'N/A'),
                    _buildDetailRow('Password', userData['password'] ?? 'N/A'),
                    _buildDetailRow('Phone Number', userData['phone number'] ?? 'N/A'),
                    _buildDetailRow('Username', userData['username'] ?? 'N/A'),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfileScreen()),
                        );
                      },
                      child: Text('Edit Profile'),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('User data is null.'));
            }
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('Driver').doc(driverId).get();

      print('User Data: ${userDoc.data()}');

      return userDoc.data() as Map<String, dynamic>?;
    } else {
      throw Exception('User not signed in');
    }
  }
}

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Add text editing controllers and other necessary variables

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add form fields for editing details
            // Use TextFormField for text input
            // Customize according to your data model

            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement save functionality
                Navigator.pop(context); // Go back to the previous screen after saving
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
