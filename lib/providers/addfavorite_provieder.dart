import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AddfavoriteNotifier extends StateNotifier<List<Favorite>> {
  AddfavoriteNotifier() : super([]);

  void addName(String name){
    if(name.trim().isEmpty)return;
    state =[...state,Favorite(title: name.trim())];
  }
}

final adfavorite = StateNotifierProvider<AddfavoriteNotifier,List<Favorite>>((ref){
  return AddfavoriteNotifier();
});