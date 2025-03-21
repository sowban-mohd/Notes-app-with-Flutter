import 'package:flutter/material.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class EmptyNoteScreenBody extends StatelessWidget {
  const EmptyNoteScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.edit_note,
            size: 50.0,
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text('No notes yet!\nCreate one.',
              textAlign: TextAlign.center,
              style: Styles.universalFont(fontSize: 20.0)),
        ],
      ),
    ));
  }
}
