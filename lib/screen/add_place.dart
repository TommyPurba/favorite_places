import 'package:flutter/material.dart';

class AddPlaceScreen extends StatefulWidget{
  const AddPlaceScreen({super.key});
  @override
  State<AddPlaceScreen> createState() {
    return _AddnewplacescreenState();
  }
}

class _AddnewplacescreenState extends State<AddPlaceScreen>{
   final _textControler = TextEditingController();

   @override
  void dispose() {
   _textControler.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'title'),
            controller: _textControler,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16,),
          ElevatedButton.icon(
            onPressed: () {
            },
            icon: Icon(Icons.add),
            label: const Text('Add Place'),
          )
        ],
      ),
    ),
    );
  }
}