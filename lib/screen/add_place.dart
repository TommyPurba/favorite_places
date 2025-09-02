import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_inpurt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget{
  const AddPlaceScreen({super.key});
  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddnewplacescreenState();
  }
}

class _AddnewplacescreenState extends ConsumerState<AddPlaceScreen>{
  
   final _textControler = TextEditingController();

  void _saveTitle(){
    final enteredTilte = _textControler.text;
    if(enteredTilte.isEmpty){
      return;
    }
      ref.read(userPlacesProvider.notifier).addPlace(enteredTilte);
      Navigator.of(context).pop();
  }

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
          const SizedBox(height: 10,),
          ImageInput(),
          const SizedBox(height: 16,),
          ElevatedButton.icon(
            onPressed: _saveTitle,
            icon: Icon(Icons.add),
            label: const Text('Add Place'),
          )
        ],
      ),
    ),
    );
  }
}