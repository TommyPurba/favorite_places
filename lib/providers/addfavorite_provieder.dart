import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AddfavoriteNotifier extends StateNotifier<List<Favorite>> {
  AddfavoriteNotifier() : super([]);

  void addName(String name){
    final n = name.trim();
    if(n.isEmpty)return;
    state =[...state,Favorite(title: n)];
  }
}

final addfavorite = StateNotifierProvider<AddfavoriteNotifier,List<Favorite>>((ref){
  return AddfavoriteNotifier();
});