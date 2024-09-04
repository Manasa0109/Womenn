import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DestinationTrackingPage extends StatefulWidget {
  const DestinationTrackingPage({super.key});

  @override
  _DestinationTrackingPageState createState() => _DestinationTrackingPageState();
}

class _DestinationTrackingPageState extends State<DestinationTrackingPage> {
  GoogleMapController? _mapController;
  LatLng _currentLocation = LatLng(37.7749, -122.4194); // Example coordinates

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Destination Tracking"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('destination'),
            position: _currentLocation,
            infoWindow: InfoWindow(title: 'Destination'),
          ),
        },
      ),
    );
  }
}
