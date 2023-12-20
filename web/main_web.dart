import 'package:flutter/material.dart';
import 'package:mockapp/pages/map_page.dart'; // Import your MapPage file
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Flutter Web App',
      home: FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: 'AIzaSyC_AbVPkhf-nnGlo0EQ-gR2-drm5Mp8JJI',
            authDomain: 'workshop-2-26086.firebaseapp.com',
            projectId: 'workshop-2-26086',
            storageBucket: 'workshop-2-26086.appspot.com',
            messagingSenderId: '"339922420964",',
            appId: '1:339922420964:web:ec3040f3a787a2c48e18f1',
          ),
        ),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return SomethingWentWrong();
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MapPage();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Loading();
        },
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Something went wrong'),
      ),
    );
  }
}
