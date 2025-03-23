import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/utils/utils.dart';
import 'package:notetakingapp1/ui/widgets/home_screen_widgets.dart';

class NotesGridView extends ConsumerWidget {
  final List<Map<String, dynamic>> notes;
  final bool isNotePinned;
  const NotesGridView(
      {super.key, required this.notes, required this.isNotePinned});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Notes grid
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop(context)
              ? 6
              : isTablet(context)
                  ? 4
                  : 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 168 / 198,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          //Note Card
          return NoteCard(
            note: note,
            isNotePinned: isNotePinned,
          );
        });
  }
}
