import 'package:notetakingapp1/core/constants/map_keys.dart';

class Folder {
  final String name;
  final String? id;
  final List<dynamic>
      noteRefs; //References (Ids) of notes which belongs to the folder are stored here

  Folder({
    required this.name,
    this.id,
    required this.noteRefs,
  });

  Folder copywith({String? name, String? id, List<String>? noteRefs}) {
    return Folder(
      name: name ?? this.name,
      id: id ?? this.id,
      noteRefs: noteRefs ?? this.noteRefs,
    );
  }

  // Convert Folder object to Map
  Map<String, dynamic> toMap() {
    return {
      FolderMapKeys.name.key: name,
      FolderMapKeys.id.key: id,
      FolderMapKeys.notes.key: noteRefs,
    };
  }

  // Create Folder object from Map
  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      name: map[FolderMapKeys.name.key] as String,
      id: map[FolderMapKeys.id.key] as String?,
      noteRefs: map[FolderMapKeys.notes.key],
    );
  }
}
