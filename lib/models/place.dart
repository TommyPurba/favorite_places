import 'package:uuid/uuid.dart';



const uuid = Uuid();

class Favorite{
  Favorite({
   required this.title,
    this.map = '',
    this.img = '',
  }): id = uuid.v4();

  final String id;
  final String title;
  final String map;
  final String img;
}