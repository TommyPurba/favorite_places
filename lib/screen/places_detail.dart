import 'package:favorite_places/env.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screen/maps.dart';
import 'package:flutter/material.dart';

class PlacesDetailScreen extends StatelessWidget {
  const PlacesDetailScreen({super.key, required this.place});

  final Favorite place;

    String get locationImage{

    final lat = place.location.latitude;
    final lng = place.location.longitude;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title, 
        ),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,

          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: 
                    (ctx) => MapScreen(location: place.location, isSelecting: false,),
                    ));
                  },
                  child: CircleAvatar(radius: 70, backgroundImage: NetworkImage(
                    locationImage
                  ),),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    ),
                  ),
                  child: Text(
                    place.location.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}