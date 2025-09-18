import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screen/places_detail.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceList extends ConsumerWidget {
  const PlaceList({super.key, required this.place});

  final List<Favorite>place;
 @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      final p = place[index];
        return Dismissible(
          key: ValueKey(p.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white,),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white,),
          ),
          confirmDismiss: (_) async{
            return await showDialog<bool>(
              context: context, 
              builder: (_)=>AlertDialog(
                backgroundColor: Colors.white,
                title: const Text('Delete this place?'),
                content: Text(p.title),
                actions: [
                  TextButton(
                    onPressed:()=>Navigator.pop(context,false) , 
                    child: const Text('cancel')
                    ),
                  TextButton(
                    onPressed:()=>Navigator.pop(context,true) , 
                    child: const Text('delete')
                    )
                ],
              ),
            )??
            false;
          },
          onDismissed: (_) async {
            await ref.read(userPlacesProvider.notifier).deletePlace(p.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text("Place Deleted"))
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundImage: FileImage(place[index].image),
            ),
            title: Text(place[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface
            ),
            ),
            subtitle: Text(
              place[index].location.address, 
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
          ),
        );
    },
   );
  }

}