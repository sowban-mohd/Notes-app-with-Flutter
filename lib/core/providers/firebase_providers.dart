import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = Provider(
  (ref) => FirebaseAuth.instance,
);

final firestoreProvider = Provider(
  (ref) => FirebaseFirestore.instance,
);

final uidProvider = Provider<String>((ref){
  return ref.read(authProvider).currentUser!.uid;
}
);