import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HimathnagarMap extends StatefulWidget {
  const HimathnagarMap({Key? key}) : super(key: key);

  @override
  _HimathnagarMapState createState() => _HimathnagarMapState();
}

class _HimathnagarMapState extends State<HimathnagarMap> {
  // Approximate coordinates for Himathnagar, Hyderabad.
  static const LatLng _center = LatLng(17.3850, 78.4867);
  late GoogleMapController _controller;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: _center,
        zoom: 14,
      ),
      markers: {
        const Marker(
          markerId: MarkerId('himathnagar'),
          position: _center,
          infoWindow: InfoWindow(
            title: 'Himathnagar',
            snippet: 'Hyderabad, Telangana, India',
          ),
        ),
      },
      // Optionally, you can disable certain map gestures if desired.
    );
  }
}
