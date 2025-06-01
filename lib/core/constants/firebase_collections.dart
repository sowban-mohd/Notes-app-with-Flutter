enum FirebaseCollections {
  usersCollection('users'),
  notesCollection('notes'),
  foldersCollection('folders');

  final String collectionName;
  const FirebaseCollections(this.collectionName);
}
