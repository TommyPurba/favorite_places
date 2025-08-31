import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UserPlacesNotifier extends StateNotifier<List<Favorite>> {
   UserPlacesNotifier() : super(const []);

  void addPlace(String title){
    final newPlaces = Favorite(title: title);
    state = [newPlaces, ...state];
  }
}

final addPlacesProvider = StateNotifierProvider((ref)=> UserPlacesNotifier(),);