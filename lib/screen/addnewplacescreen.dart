import 'package:flutter/material.dart';

class Addnewplacescreen extends StatefulWidget{
  const Addnewplacescreen({super.key});

  @override
  State<Addnewplacescreen> createState() {
    return _AddnewplacescreenState();
  }
}

class _AddnewplacescreenState extends State<Addnewplacescreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new place'),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body: Center(child: Text('addd'),),
    );
  }
}