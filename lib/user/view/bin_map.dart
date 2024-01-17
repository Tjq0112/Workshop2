import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();
  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = _locationController.onLocationChanged.listen(
          (LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          if (mounted) {
            setState(() {
              _currentLocation = LatLng(
                currentLocation.latitude!,
                currentLocation.longitude!,
              );
            });

            // Fetch bins and calculate route after location updates
            fetchBinsFromFirestore();
          }
        }
      },
    );
  }

  Future<void> fetchBinsFromFirestore() async {
    try {
      DocumentSnapshot binDoc =
      await FirebaseFirestore.instance.collection('bin').doc('b01').get();

      double binLatitude = binDoc['latitude'] ?? 0.0;
      double binLongitude = binDoc['longitude'] ?? 0.0;

      _calculateRoute(
        LatLng(binLatitude, binLongitude),
      );
    } catch (e) {
      print('Error fetching bin b01: $e');
    }
  }

  Future<void> _calculateRoute(LatLng destination) async {
    if (_currentLocation != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      List<LatLng> polylineCoordinates = [];

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        // Replace with your Google Maps API Key
        'AIzaSyB5v3HJfXgOhqcpZRx9bajilGpy7SLkSzI',
        PointLatLng(_currentLocation!.latitude, _currentLocation!.longitude),
        PointLatLng(destination.latitude, destination.longitude),
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }

      setState(() {
        _markers = {
          Marker(
            markerId: MarkerId('userMarker'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: _currentLocation!,
          ),
          Marker(
            markerId: MarkerId('binMarker'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            position: destination,
          ),
        };

        _polylines = {
          Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            points: polylineCoordinates,
            width: 8,
          ),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: _currentLocation == null
          ? const Center(child: Text("Loading..."))
          : GoogleMap(
        onMapCreated: ((GoogleMapController controller) =>
            _mapController.complete(controller)),
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 13,
        ),
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}
