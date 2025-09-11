import 'dart:convert';
import 'package:favorite_places/env.dart'; // <-- pastikan TANPA spasi ekstra
import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

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
              onPressed: (){},
            ),
          ],
        )
      ],
    );
  }
}
