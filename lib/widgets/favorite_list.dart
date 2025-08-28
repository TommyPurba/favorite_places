import 'package:favorite_places/providers/addfavorite_provieder.dart';
import 'package:favorite_places/screen/placedetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteList extends ConsumerWidget{
  const FavoriteList({super.key});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(addfavorite);

      Widget mainContent = Center(
        child: Text('No places added yet!', 
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary
        ),),
      );

        if(favorites.isNotEmpty){
          mainContent = ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (ctx, index) {
              final place = favorites[index];
              return ListTile(
                title: Text(place.title),
                trailing: const Icon(Icons.chevron_right),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Placedetailscreen(title: place.title),
                    )
                  );
                },
              );
            },
          );
        }
    return mainContent;

  }
}