import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UserPlacesNotifier extends StateNotifier<List<Favorite>> {
   UserPlacesNotifier() : super(const []);

  void addPlace(String title, File image){
    final newPlaces = Favorite(title: title,image: image);
    state = [newPlaces, ...state];
  }
}

final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier, List<Favorite>>((ref)=> UserPlacesNotifier(),);