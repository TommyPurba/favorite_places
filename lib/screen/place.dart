import 'package:favorite_places/widgets/place_list.dart';
import 'package:flutter/material.dart';

class PlaceScreen extends StatelessWidget{
  const PlaceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: PlaceList(place: []),
    );
  }
}