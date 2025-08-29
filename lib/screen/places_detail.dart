
import 'package:flutter/material.dart';

class Placedetailscreen extends StatelessWidget {
  const Placedetailscreen({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,),
      ),
      body: Center(child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,),
      ),),
    );
  }
}