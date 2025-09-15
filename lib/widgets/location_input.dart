// ini code saya untuk location_input.dart

import 'dart:convert'; // <-- tambah untuk decode JSON (reverse geocoding)
import 'package:favorite_places/env.dart'; // <-- pastikan TANPA spasi ekstra
import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:favorite_places/screen/maps.dart'; // <-- tambah import MapScreen

class LocationInput extends StatefulWidget{
  const LocationInput({super.key, required this.onSelectLocation});
  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput>{

  PlaceLocation? _pickLocation;
  var _isGettingLocation = false;

  String get locationImage{
    if (_pickLocation == null || locationIqToken.isEmpty) return '';
    final lat = _pickLocation!.latitude;
    final lng = _pickLocation!.longitude;

    // LocationIQ static map (tanpa paket)
    final uri = Uri.https('maps.locationiq.com', '/v3/staticmap', {
      'key': locationIqToken,
      'center': '$lat,$lng',
      'zoom': '16',
      'size': '600x300',
      'markers': '$lat,$lng',
    });
    return uri.toString();
  }

  void _getCurrentLocation() async{
    Location location = Location();

    setState(() {
      _isGettingLocation = true;
    });

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // reset loading sebelum keluar
        if (mounted) setState(() => _isGettingLocation = false);
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        if (mounted) setState(() => _isGettingLocation = false);
        return;
      }
    }

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if(lat==null || lng== null){
      if (mounted) setState(() => _isGettingLocation = false);
      return;
    }

    // ini kalau ada billing api maps google
    // final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=XXXX');
    // final response = await http.get(url);
    // final resData = json.decode(response.body);
    // final address = resData['results'][0]['formatted_address'];

    // sementara alamat manual (hardcode) biar jalan
    const address = '277 Bedford Avenue, Brooklyn, NY 11211, USA';

    if (!mounted) return;
    setState(() {
      _pickLocation = PlaceLocation(longitude: lng, latitude: lat, address: address);
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickLocation!);
  }

  // ===== Tambahan: reverse geocoding LocationIQ untuk dapat alamat =====
  Future<String> _reverseGeocode(double lat, double lng) async {
    if (locationIqToken.isEmpty) return '';
    final uri = Uri.https('us1.locationiq.com', '/v1/reverse', {
      'key': locationIqToken,
      'lat': '$lat',
      'lon': '$lng',
      'format': 'json',
    });
    try {
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        return (data['display_name'] as String?) ?? '';
      }
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
    }
    return '';
  }
  // ====================================================================

  // ==== Tambahan: pilih lokasi manual di peta (MapScreen) ====
  Future<void> _selectOnMap() async {
    // buka full-screen map untuk memilih lokasi
    final result = await Navigator.of(context).push<PlaceLocation>(
      MaterialPageRoute(
        builder: (_) => const MapScreen(isSelecting: true),
      ),
    );

    // jika user batal
    if (result == null) return;
    if (!mounted) return;

    // Ambil alamat dari LocationIQ (biar address tampil)
    final addr = await _reverseGeocode(result.latitude, result.longitude);
    final withAddr = PlaceLocation(
      longitude: result.longitude,
      latitude: result.latitude,
      address: addr.isNotEmpty ? addr : result.address,
    );

    // simpan hasil & kabari parent (sesuai pola kamu)
    setState(() {
      _pickLocation = withAddr;
    });
    widget.onSelectLocation(withAddr);
  }
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No Location Choosen",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface
      ),
    );

    if (_pickLocation != null){
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        // tambah errorBuilder supaya UI aman kalau URL gagal
        errorBuilder: (_, __, ___) => const Text('Map image unavailable'),
      );
    }

    if(_isGettingLocation){
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),

        // ===== Tambahan: tampilkan alamat kalau ada =====
        if ((_pickLocation?.address.isNotEmpty ?? false))
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _pickLocation!.address,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        // =================================================

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_pin),
              label: const Text('Get Current Location'),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select On Map'),
              onPressed: _selectOnMap, // <-- panggil MapScreen
            ),
          ],
        )
      ],
    );
  }
}
