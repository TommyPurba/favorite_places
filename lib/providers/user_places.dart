import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';


class UserPlacesNotifier extends StateNotifier<List<Favorite>> {
   UserPlacesNotifier() : super(const []);

  void addPlace(String title, File image, PlaceLocation location) async{
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');
    final newPlaces = Favorite(title: title,image: copiedImage, location: location);
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version){
        return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
      },
      version: 1,
    );

    db.insert('user_places', {
      'id' : newPlaces.id,
      'title' : newPlaces.title,
      'image' : newPlaces.image.path,
      'lat' : newPlaces.location.latitude,
      'lng' : newPlaces.location.longitude,
      'address' : newPlaces.location.address,
    });
    state = [newPlaces, ...state];
  }
}

final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier, List<Favorite>>((ref)=> UserPlacesNotifier(),);