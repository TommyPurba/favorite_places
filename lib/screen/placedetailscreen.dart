import 'package:flutter/material.dart';

class Placedetailscreen extends StatelessWidget {
  const Placedetailscreen({super.key, required this.place});
  final String place;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place),
      ),
      body: Center(child: Text(place),),
    );
  }
}