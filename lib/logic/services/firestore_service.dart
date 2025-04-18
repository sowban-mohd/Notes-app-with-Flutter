import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  /// Returns a stream of list of documents from specified collection
  Stream<List<Map<String, dynamic>>> getCollectionStream(String collection) {
    if (_uid == null) {
      return Stream.empty();
    } // Return an empty stream when the user is logged out to prevent Firestore errors

    var collectionRef =
        _firestore.collection('users').doc(_uid).collection(collection);

    return collectionRef
        .orderBy('timestamp',
            descending: true) //Sorts based on created/updated time
        .snapshots() //Real-time updates
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    //Converts each document to a map and all the maps to list of maps
  }

  ///Adds document to the collection with the given content and returns the related document id for other operations
  Future<String> addToCollection(
      {required String collection,
      required Map<String, dynamic> content}) async {
    final collectionRef =
        _firestore.collection('users').doc(_uid).collection(collection);
    final docRef = await collectionRef.add(content);
    return docRef.id;
  }

  /// Updates the document of given document id with the given content
  Future<void> updateInCollection(
      {required String collection,
      required String docId,
      required Map<String, dynamic> content}) async {
    var collectionRef =
        _firestore.collection('users').doc(_uid).collection(collection);
    await collectionRef.doc(docId).set(content, SetOptions(merge : true));
  }

  /// Deletes document from the collection with specified document Ids
  Future<void> deleteFromCollection(
      {required String collection, required Set<String> docIds}) async {
    //Enables firebase batch opeartions
    final batch = _firestore.batch();
    final collectionRef =
        _firestore.collection('users').doc(_uid).collection(collection);

    for (final docId in docIds) {
      final docRef = collectionRef.doc(docId);

      //Queues delete operation for each documents with document Ids from specified collection
      batch.delete(docRef);
    }
    //Performs queued batch operations
    await batch.commit();
  }
}
