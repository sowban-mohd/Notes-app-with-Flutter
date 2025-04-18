import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/category_provider.dart';
import 'package:notetakingapp1/logic/services/firestore_service.dart';

final bodyStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final String category = ref.watch(categoryProvider);
  final String collection = category == 'All Notes'
      ? 'notes'
      : category == 'Folders'
          ? 'folders'
          : category.replaceAll(' ','').toLowerCase();
  final firestoreService = FirestoreService();

  return firestoreService.getCollectionStream(collection);
});
