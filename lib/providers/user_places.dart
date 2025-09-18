import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async{
final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version){
        return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
      },
      version: 1,
    );
    return db;
}

class UserPlacesNotifier extends StateNotifier<List<Favorite>> {
   UserPlacesNotifier() : super(const []);

   Future<void> loadPlace() async{
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map(
      (row)=> Favorite(id: row['id'] as String, title: row['title'] as String, image: File(row['image'] as String), location: PlaceLocation(longitude: row['lng'] as double, latitude: row['lat'] as double, address: row['address'] as String))
    ).toList();
    state = places ;
   }

   Future<void> deletePlace(String id) async{
    final db = await _getDatabase();

    //ambil path image agr bisa dihapus dari storage
    final rows = await db.query(
      'user_places',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isNotEmpty){
      final imagePath = rows.first['image'] as String?;
      if(imagePath !=null){
        final file = File(imagePath);
        if(await file.exists()){
          try {
            await file.delete();
          } catch (_) {
            
          }
        }
      }
    }
    //hapus dari database
    await db.delete(
      'user_places',
      where: 'id = ?',
      whereArgs: [id],
    );

    // sinkronkan state riverpod
    state = state.where((p)=> p.id != id).toList();
   }

  void addPlace(String title, File image, PlaceLocation location) async{
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');
    final newPlaces = Favorite(title: title,image: copiedImage, location: location);
   
    final db =await _getDatabase() ;

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