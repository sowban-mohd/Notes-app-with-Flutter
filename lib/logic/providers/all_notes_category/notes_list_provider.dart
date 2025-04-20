import 'package:flutter_riverpod/flutter_riverpod.dart';

final notesListProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);