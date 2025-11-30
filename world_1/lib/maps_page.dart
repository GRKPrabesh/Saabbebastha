import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? _mapController;
  
  // Default location (you can change this to your preferred location)
  static const LatLng _initialPosition = LatLng(28.6139, 77.2090); // New Delhi, India
  LatLng _currentPosition = _initialPosition;
  
  // Map type
  MapType _mapType = MapType.normal;
  bool _mapCreated = false;
  String? _mapError;

  // Sample markers for crematoriums/burial services
  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('location1'),
      position: LatLng(28.6139, 77.2090),
      infoWindow: InfoWindow(
        title: 'Electric Crematorium',
        snippet: 'Delhi Crematorium Services',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
    Marker(
      markerId: MarkerId('location2'),
      position: LatLng(28.6280, 77.2160),
      infoWindow: InfoWindow(
        title: 'Fire Burning Service',
        snippet: 'Traditional Fire Services',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ),
    Marker(
      markerId: MarkerId('location3'),
      position: LatLng(28.6000, 77.2000),
      infoWindow: InfoWindow(
        title: 'Burial Systems',
        snippet: 'Burial Ground Services',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ),
  };

  @override
  void initState() {
    super.initState();
    // You can add location permission and current location fetching here
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _mapCreated = true;
      _mapError = null;
    });
    
    // Set a timeout to detect if map fails to load
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_mapCreated) {
        setState(() {
          _mapError = 'Map failed to load. Please check your internet connection and Google Maps API key configuration.';
        });
      }
    });
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _mapType = _mapType == MapType.normal
          ? MapType.satellite
          : _mapType == MapType.satellite
              ? MapType.terrain
              : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Service Locations',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _mapType == MapType.normal
                  ? Icons.map
                  : _mapType == MapType.satellite
                      ? Icons.satellite
                      : Icons.terrain,
              color: Colors.black,
            ),
            onPressed: _onMapTypeButtonPressed,
            tooltip: 'Change Map Type',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _mapError != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'Map Loading Error',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _mapError!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _mapError = null;
                          _mapCreated = false;
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                if (!_mapCreated)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 13.0,
                    ),
                    mapType: _mapType,
                    markers: _markers,
                    myLocationEnabled: false, // Disable for web compatibility
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    mapToolbarEnabled: false,
                    onTap: (LatLng location) {
                      // Handle map tap if needed
                    },
                  ),
                ),
          // Custom Location Button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                // Move camera to current position or a default location
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(_currentPosition, 15.0),
                );
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),
          // Info Card
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Available Services',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildServiceLegend('Electric Crematorium', Colors.red),
                  const SizedBox(height: 4),
                  _buildServiceLegend('Fire Burning Service', Colors.orange),
                  const SizedBox(height: 4),
                  _buildServiceLegend('Burial Systems', Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceLegend(String service, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          service,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}



