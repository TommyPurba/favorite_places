
import 'package:flutter/material.dart';

class YourfavoriteScreen extends StatefulWidget{
  const YourfavoriteScreen({super.key});

  @override
  State<YourfavoriteScreen> createState() {
    return _YourfavoriteScreenState();
  }
}

class _YourfavoriteScreenState extends State<YourfavoriteScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your places'),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.add))
        ],
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body:ListView(),
    );
  }
}