import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screen/add_place.dart';
import 'package:favorite_places/widgets/place_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceScreen extends ConsumerWidget{
  const PlaceScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPlace = ref.watch(userPlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => const AddPlaceScreen()
              ));
            }, 
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: PlaceList(place: userPlace),
    );
  }
}