import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// your token file: const String locationIqToken = 'pk.YOUR_TOKEN';
import '../env.dart';

// your model
import '../models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: '',
    ), // default center (Google campus coords)
    this.isSelecting = true, // true: pick mode, false: view mode
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _picked; // set when user taps

  @override
  Widget build(BuildContext context) {
    // start center (either passed-in place or default)
    final start = LatLng(widget.location.latitude, widget.location.longitude);

    // markers logic:
    // - selecting + no pick yet -> no marker
    // - selecting + picked -> marker at picked
    // - viewing (isSelecting=false) -> marker at start
    final markers = <Marker>[
      if (widget.isSelecting && _picked != null)
        Marker(
          width: 40,
          height: 40,
          point: _picked!,
          child: const Icon(Icons.location_pin, size: 40),
        ),
      if (!widget.isSelecting)
        Marker(
          width: 40,
          height: 40,
          point: start,
          child: const Icon(Icons.location_pin, size: 40),
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              tooltip: _picked == null ? 'Tap the map to pick' : 'Save location',
              icon: const Icon(Icons.save),
              onPressed: _picked == null
                  ? null // disabled until user taps
                  : () {
                      final pos = _picked!;
                      Navigator.of(context).pop(
                        PlaceLocation(
                          latitude: pos.latitude,
                          longitude: pos.longitude,
                          address: '', // fill later with reverse geocoding if needed
                        ),
                      );
                    },
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: start,
          initialZoom: 16,
          // tap to pick
          onTap: (tapPosition, latLng) {
            if (!widget.isSelecting) return;
            setState(() => _picked = latLng);
          },
        ),
        children: [
          // LocationIQ tiles (no Google key needed)
          TileLayer(
            urlTemplate:
                'https://{s}-tiles.locationiq.com/v3/streets/r/{z}/{x}/{y}.png?key=$locationIqToken',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.yourapp.package',
            maxZoom: 18,
          ),
          MarkerLayer(markers: markers),
        ],
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(6),
        child: Text(
          '© LocationIQ • © OpenStreetMap contributors',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
