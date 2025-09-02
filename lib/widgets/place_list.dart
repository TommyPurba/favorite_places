import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screen/places_detail.dart';
import 'package:flutter/material.dart';

class PlaceList extends StatelessWidget {
  const PlaceList({super.key, required this.place});

  final List<Favorite>place;
 @override
  Widget build(BuildContext context) {
    if(place.isEmpty){
      return  Center(
        child: Text('No places added yet',
         style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface
          ),
      ),) ;
    }

   return ListView.builder(
    itemCount: place.length,
    itemBuilder: (ctx, index){
        return ListTile(
          title: Text(place[index].title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface
          ),
          ),
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PlacesDetailScreen(place: place[index])
              )
            );
          } ,
        );
    },
   );
  }

}