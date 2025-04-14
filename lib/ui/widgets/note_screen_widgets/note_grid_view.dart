import 'package:flutter/material.dart';
import 'package:notetakingapp1/logic/utils.dart';
import 'package:notetakingapp1/ui/widgets/note_screen_widgets/note_card.dart';

class NotesGridView extends StatelessWidget {
  final List<Map<dynamic, dynamic>> notes;
  final bool isPinned;

  const NotesGridView({super.key, required this.notes, required this.isPinned});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop(context)
                ? 6
                : isTablet(context)
                    ? 4
                    : 2,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 4.0,
            childAspectRatio: 170 / 200,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            //Essential values
            final note = notes[index];
            return NoteCard(note: note, isNotePinned: isPinned);
          }),
    );
  }
}
