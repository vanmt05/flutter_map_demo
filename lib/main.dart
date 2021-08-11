import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(19.440104, -70.697432), zoom: 12);

  GoogleMapController? _googleMapController;
  Marker? _origin;
  Marker? _destination;

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Map Demo',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          if (_origin != null)
            TextButton(
                onPressed: () => _googleMapController!.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                      target: _origin!.position,
                      zoom: 30,
                      tilt: 50.0,
                    ))),
                style: TextButton.styleFrom(
                  primary: Colors.green,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                child: const Text('ORIGIN')),
          if (_destination != null)
            TextButton(
                onPressed: () => _googleMapController!.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                      target: _destination!.position,
                      zoom: 30,
                      tilt: 50.0,
                    ))),
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                child: const Text('DESTINATION')),
        ],
        backgroundColor: Colors.white,
      ),
      body: GoogleMap(
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: {
          if (_origin != null) _origin!,
          if (_destination != null) _destination!,
        },
        onLongPress: _addMarker,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController!.animateCamera(
            CameraUpdate.newCameraPosition(_initialCameraPosition)),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  _addMarker(LatLng pos) {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Set destination to null
        _destination = null;
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
    }
  }
}
