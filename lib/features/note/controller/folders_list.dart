import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/features/note/controller/folders_controller.dart';
import 'package:notetakingapp1/features/note/models/folder.dart';

class FoldersList extends Notifier<List<Folder>> {
  @override
  List<Folder> build() {
    // Start listening to the stream
    ref.listen<AsyncValue<List<Folder>>>(
      folderStreamProvider,
      (prev, next) {
        next.whenData((folders) {
          state = folders;
        });
      },
    );

    return []; // initial state
  }
}