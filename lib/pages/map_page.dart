import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mockapp/consts.dart';
import 'package:mockapp/pages/report.dart';
import 'schedule.dart';
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
  Map<PolylineId, Polyline> polylines = {};
  bool _addingMarkerMode = false;
  Set<Marker> _markers = {};
  Set<Marker> _userAddedMarkers = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then(
          (_) {
        // Initial location updates will set the current location
        fetchBinsFromFirestore();
      },
    );
  }

  Future<void> fetchBinsFromFirestore() async {
    try {
      DocumentSnapshot binDoc =
      await FirebaseFirestore.instance.collection('bin').doc('b01').get();

      double latitude = binDoc['latitude'] ?? 0.0;
      double longitude = binDoc['longitude'] ?? 0.0;

      _userAddedMarkers.add(
        Marker(
          markerId: MarkerId('b01'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(latitude, longitude),
        ),
      );

      setState(() {});
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
      body: _currentLocation == null
          ? const Center(child: Text("Loading..."))
          : Stack(
        children: [
          GoogleMap(
            onMapCreated: ((GoogleMapController controller) =>
                _mapController.complete(controller)),
            initialCameraPosition: CameraPosition(
              target: _currentLocation!,
              zoom: 13,
            ),
            markers: _getMarkers(),
            polylines: Set<Polyline>.of(polylines.values),
            onTap: _addingMarkerMode ? _onMapTapped : null,
            zoomControlsEnabled: true, // enable default zoom controls
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _toggleAddingMarkerMode,
              tooltip: 'Toggle Marker Mode',
              child: Icon(_addingMarkerMode ? Icons.add : Icons.edit),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Toggle Marker Mode'),
              onTap: _toggleAddingMarkerMode,
            ),
            ListTile(
              title: Text('Remove Added Markers'),
              onTap: () {
                _removeAddedMarkers();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Return to Default State'),
              onTap: () {
                setState(() {
                  _addingMarkerMode = false;
                  _markers.clear();
                  polylines.clear();
                  // Do not clear the markers fetched from Firestore
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Go to Schedule'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Schedule()),
                );
              },
            ),
            ListTile(
              title: Text('Go to Report'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Report()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Set<Marker> _getMarkers() {
    Set<Marker> markers = _addingMarkerMode
        ? {..._userAddedMarkers, ..._markers}
        : {..._getDefaultMarkers(), ..._userAddedMarkers, ..._markers};

    return markers;
  }

  Set<Marker> _getDefaultMarkers() {
    return {
      Marker(
        markerId: MarkerId("_currentLocation"),
        icon: BitmapDescriptor.defaultMarker,
        position: _currentLocation!,
      ),
    };
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen(
          (LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _currentLocation = LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            );
            _cameraToPosition(_currentLocation!);
          });
        }
      },
    );
  }

  Future<List<LatLng>> getPolylinePoints(List<Marker> markers) async {
    if (markers.length < 2) {
      return []; // Return an empty list if there are not enough markers
    }

    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    for (int i = 0; i < markers.length - 1; i++) {
      LatLng source = markers[i].position;
      LatLng destination = markers[i + 1].position;

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_MAPS_API_KEY,
        PointLatLng(source.latitude, source.longitude),
        PointLatLng(destination.latitude, destination.longitude),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
      }
    }

    return polylineCoordinates;
  }

  void generatePolylinefromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  void _toggleAddingMarkerMode() {
    setState(() {
      _addingMarkerMode = !_addingMarkerMode;
    });
  }

  void _onMapTapped(LatLng position) {
    if (_addingMarkerMode) {
      setState(() {
        _userAddedMarkers.add(
          Marker(
            markerId: MarkerId("newMarker${_userAddedMarkers.length + 1}"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: position,
          ),
        );

        // Fetch and display the route polyline
        _displayRoutePolyline();
      });
    }
  }

  Future<void> _displayRoutePolyline() async {
    if (_userAddedMarkers.length >= 2) {
      List<LatLng> polylineCoordinates =
      await getPolylinePoints([..._getDefaultMarkers(), ..._userAddedMarkers]);

      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 8,
      );

      setState(() {
        polylines[id] = polyline;
      });
    }
  }

  void _removeAddedMarkers() {
    setState(() {
      _userAddedMarkers.clear();
      polylines.clear();
    });
    // Fetch markers from Firestore again after removing user-added markers
    fetchBinsFromFirestore();
  }

}
