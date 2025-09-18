import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screen/add_place.dart';
import 'package:favorite_places/widgets/place_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceScreen extends ConsumerStatefulWidget{
  const PlaceScreen({super.key});
  @override

  ConsumerState<PlaceScreen> createState() {
    return _PlaceScreenState();
  }

}

class _PlaceScreenState extends ConsumerState<PlaceScreen>{
  late Future<void> _placeFuture;

@override
  void initState() {
    super.initState();
    _placeFuture = ref.read(userPlacesProvider.notifier).loadPlace();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(future:_placeFuture , builder:  (context, snapshot) => snapshot.connectionState== ConnectionState.waiting? Center(child: CircularProgressIndicator(),) :PlaceList(place: userPlace,),),
      ),
    );
  }

}