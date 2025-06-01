enum FolderMapKeys {
  name('name'),
  id('id'),
  notes('noteRefs');

  final String key;
  const FolderMapKeys(this.key);
}

enum GeneralKeys {
  timestamp('timestamp');

  final String key;
  const GeneralKeys(this.key);
}

enum NoteMapKeys {
  title('title'),
  content('content'),
  id('id'),
  pinned('pinned'),
  folderRefs('folderRefs');

  final String key;
  const NoteMapKeys(this.key);
}
