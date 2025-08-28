
import 'package:favorite_places/screen/addnewplacescreen.dart';
import 'package:favorite_places/widgets/favorite_list.dart';
import 'package:flutter/material.dart';

class YourfavoriteScreen extends StatefulWidget{
  const YourfavoriteScreen({super.key});

  @override
  State<YourfavoriteScreen> createState() {
    return _YourfavoriteScreenState();
  }
}

class _YourfavoriteScreenState extends State<YourfavoriteScreen>{

  void _addbutton(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Addnewplacescreen(),
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your places'),
        actions: [
          IconButton(onPressed: _addbutton, icon: Icon(Icons.add))
        ],
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body:FavoriteList(),
    );
  }
}