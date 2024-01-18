import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockapp/admin/Menu.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();
  LatLng _initialLocation = LatLng(2.3139540456330923, 102.32108416531727);
  Set<Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchBinsFromFirestore() async {
    try {
      DocumentSnapshot binDoc =
      await FirebaseFirestore.instance.collection('bin').doc('b01').get();

      double latitude = binDoc['latitude'] ?? 0.0;
      double longitude = binDoc['longitude'] ?? 0.0;

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('b01'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: LatLng(latitude, longitude),
          ),
        );
      });
    } catch (e) {
      print('Error fetching bin b01: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Show Bins'),
              onTap: () {
                _showBins();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Show Drivers Location'),
              onTap: () {
                _showDriversLocation();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Return to Main Menu'),
              onTap: () {
                Navigator.push(
                  context,
                MaterialPageRoute(builder: (context) => Menu(username: 'admin', password: 'admin1')));
              },
            ),
          ],
        ),
      ),
      body: GoogleMap(
        onMapCreated: ((GoogleMapController controller) =>
            _mapController.complete(controller)),
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: 15,
        ),
        markers: _markers,
        polylines: Set<Polyline>.of(polylines.values),
        zoomControlsEnabled: false, // Disable default zoom controls
      ),
    );
  }

  void _showBins() async {
    setState(() {
      _markers.clear();
      polylines.clear();
    });

    await fetchBinsFromFirestore();
  }

  void _showDriversLocation() async {
    setState(() {
      _markers.clear();
      polylines.clear();
    });

    try {
      QuerySnapshot driverDocs =
      await FirebaseFirestore.instance.collection('Driver').get();

      driverDocs.docs.forEach((driverDoc) {
        double latitude = driverDoc['latitude'] ?? 0.0;
        double longitude = driverDoc['longitude'] ?? 0.0;

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(driverDoc.id),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position: LatLng(latitude, longitude),
            ),
          );
        });
      });
    } catch (e) {
      print('Error fetching drivers locations: $e');
    }
  }

  // Other methods...

  @override
  void dispose() {
    // Dispose any resources or cleanup if needed
    super.dispose();
  }
}
