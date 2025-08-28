import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';

class FavoriteList extends StatelessWidget{
  const FavoriteList({super.key, required this.favorite});
  final List<Favorite> favorite ;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        
      } ,
    );

  }
}