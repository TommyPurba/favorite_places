import 'package:favorite_places/screen/placedetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';

class FavoriteList extends StatelessWidget{
  const FavoriteList({super.key, required this.favorite});
  final List<Favorite> favorite ;


  @override
  Widget build(BuildContext context) {

      Widget mainContent = Center(
        child: Text('No places added yet!', 
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary
        ),),
      );

        if(favorite.isNotEmpty){
          mainContent = ListView.builder(
            itemBuilder: (ctx, index) => Placedetailscreen(place: favorite[index].id) ,
          );
        }
    return mainContent;

  }
}