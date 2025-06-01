import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/features/notes/controller/category_provider.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/folders_body.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/all_notes_body.dart';

class HomeBody extends ConsumerWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryProvider);
    return category == Category.allNotes.categoryName
        ? AllNotesBody()
        : FoldersBody();
  }
}
