import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreService{
  //get collection of notes
  final CollectionReference notes=
  FirebaseFirestore.instance.collection('notes');

  //Create :add a new notes
 Future<void> addNote(String note){
   return notes.add({
     'note':note,
     'timestamp':Timestamp.now(),

   });
 }
  //read: get a notes from database
  Stream<QuerySnapshot> getNotesStream(){
   final notesStream=notes.orderBy('timestamp',descending: true).snapshots();
   return notesStream;
 }
  //update:update notes given a doc id
Future<void> updateNote(String docID,String newnote){
   return notes.doc(docID).update({
     'note':newnote,
     'timestamp':Timestamp.now(),
   }

   );
}

  //delete: delete notes given a doc id
Future<void>deleteNote(String,docID){
   return notes.doc(docID).delete();
}



}