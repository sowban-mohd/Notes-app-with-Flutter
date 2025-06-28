class Note {
  final String title;
  final String content;
  final bool pinned;
  final List<dynamic> folderRefs;
  final String? id;

  Note({
    required this.title,
    required this.content,
    required this.pinned,
    required this.folderRefs,
    this.id,
  });

  Note copyWith({String? title, String? content, bool? pinned, List<String>? folderRefs, String? id}) {
    return Note(
        title: title ?? this.title,
        content: content ?? this.content,
        pinned: pinned ?? this.pinned,
        folderRefs: folderRefs ?? this.folderRefs,
        id: id ?? this.id);
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      pinned: map['pinned'],
      folderRefs: map['folderRefs'],
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'pinned': pinned,
      'folderRefs' : folderRefs,
      'id': id,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is Note && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
