import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provides a stream of notes from user's note collection
final notesProvider = StreamProvider.autoDispose((ref) {
  String? uid = FirebaseAuth.instance.currentUser?.uid; //ID unique to the user

  return FirebaseFirestore.instance
      .collection('users') // Get the 'users' collection
      .doc(uid)            // Get the document of a specific user (identified by uid)
      .collection('notes') // Get the 'notes' subcollection inside that user document
      .orderBy('timestamp', descending: true) //Sorts based on created/updated time
      .snapshots() //Real-time updates
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList()); 
      //Converts each note to a map and all the notes to list of maps
});
