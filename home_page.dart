import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/firestore.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 //firestore
  final FirestoreService firestoreService=FirestoreService();

  //text controller
  final TextEditingController textController=TextEditingController();

  //open dialogBox
  void openNoteBox({String? docID}){
    showDialog(context: context, builder: (context)=>AlertDialog(
      content: TextField(
        controller: textController,
      ),
      actions: [
        //button save
        ElevatedButton(
            onPressed: (){
              //add a new note
              if(docID==null) {
                firestoreService.addNote(textController.text);
              }
              //update an existing note
              else{
                firestoreService.updateNote(docID, textController.text);
              }

              //clear a text
              textController.clear();
              //close the box
              Navigator.pop(context);
            },
            child: Text("Add"),
        )
        
      ],
    ),);
  }

@override
Widget build(BuildContext context) {
  return Scaffold (
    appBar: AppBar(
      title: Text("Notes"),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: openNoteBox,
      child: const Icon(Icons.add),
    ),
    body: StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getNotesStream(),
      builder: (context,snapshot) {
        //if we have a data , get all the docs
        if(snapshot.hasData){
          List notesList=snapshot.data!.docs;
          //display as a list
          return ListView.builder(
            itemCount: notesList.length,
              itemBuilder: (context,index){

                //get individual doc
                DocumentSnapshot document=notesList[index];
                String docID=document.id;
                //get note from each doc
            Map<String,dynamic>data=
            document.data() as Map<String,dynamic>;
            String noteText=data['note'];
                //display as alist tile
                return ListTile(
                  title: Text(noteText),
                  trailing:Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //update button
                      IconButton(
                        onPressed: ()=>openNoteBox(docID: docID),
                        icon: Icon(Icons.settings),
                      ),
                      //delete button
                      IconButton(
                        onPressed: () => firestoreService.deleteNote(String,docID),
                        icon: Icon(Icons.delete),
                      ),


                    ],
                  ) ,
                );
              }
          );
        }
        else{
          return const Text("No notes...");
        }
      },
    ),
  );
}
}
