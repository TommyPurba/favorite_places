import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// where your token lives (const String locationIqToken = 'pk.XXXX')
import '../env.dart';

// your own model
import '../models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
       latitude: 37.422,
      longitude: -122.084,
      address: '',
    ),              // existing location (optional)
    this.isSelecting = true,    // true = pick mode, false = view mode
  });

  final PlaceLocation? location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _picked; // set when user taps the map

  @override
  Widget build(BuildContext context) {
    // default center (Google campus coords) if no location passed
    final start = LatLng(
      widget.location?.latitude ?? 37.422,
      widget.location?.longitude ?? -122.084,
    );

    // show either the picked marker (selecting) or the given/start marker
    final markers = <Marker>[
      if (widget.isSelecting && _picked != null)
        Marker(
          point: _picked!,
          width: 40,
          height: 40,
          child: const Icon(Icons.location_pin, size: 40),
        )
      else
        Marker(
          point: start,
          width: 40,
          height: 40,
          child: const Icon(Icons.location_pin, size: 40),
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                final pos = _picked ?? start;
                Navigator.of(context).pop(
                  PlaceLocation(
                    latitude: pos.latitude,
                    longitude: pos.longitude,
                    address: '', // fill later via reverse geocoding if you want
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
          onTap: (tapPosition, latLng) {
            if (!widget.isSelecting) return;
            setState(() => _picked = latLng);
          },
        ),
        children: [
          // LocationIQ tiles (streets style). Requires your token.
          TileLayer(
            urlTemplate:
              'https://{s}-tiles.locationiq.com/v3/streets/r/{z}/{x}/{y}.png?key=$locationIqToken',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.yourapp.package',
            maxZoom: 18,
            // Note: add caching or a fallbackUrl if you need
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
