import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;


class UserPlacesNotifier extends StateNotifier<List<Favorite>> {
   UserPlacesNotifier() : super(const []);

  void addPlace(String title, File image, PlaceLocation location) async{
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');
    final newPlaces = Favorite(title: title,image: copiedImage, location: location);
    state = [newPlaces, ...state];
  }
}

final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier, List<Favorite>>((ref)=> UserPlacesNotifier(),);