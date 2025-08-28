import 'package:favorite_places/providers/addfavorite_provieder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Addnewplacescreen extends ConsumerStatefulWidget{
  const Addnewplacescreen({super.key});

  @override
  ConsumerState<Addnewplacescreen> createState() {
    return _AddnewplacescreenState();
  }
}

class _AddnewplacescreenState extends ConsumerState<Addnewplacescreen>{
  final _ctrl = TextEditingController();

@override
  void dispose() {
   _ctrl.dispose();
    super.dispose();
  }

void _submit (){
  final text= _ctrl.text.trim();
  if(text.isEmpty){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Name still empty !'))
    );
    return;
  }

  //masukkan ke rivedpood
  ref.read(addfavorite.notifier).addName(text);


  if(!mounted)return;
  Navigator.of(context).pop(true); //kembali ke list
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new place'),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _ctrl,
              decoration: const InputDecoration(
                labelText: 'title',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_)=>_submit(),
            ),
            const SizedBox(height: 12,),
             Center(
               child: ElevatedButton(
                  onPressed: _submit, 
                  child: Row(
                    children: [
                      Icon(
                    Icons.add,
                    
                  ),
                  Text('Add Place')
                    ],
                  )
                
                ),
             ),
            
          ],
        ),
      ),
    );
  }
}