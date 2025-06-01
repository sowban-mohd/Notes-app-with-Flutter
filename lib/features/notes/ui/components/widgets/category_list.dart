import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/features/notes/controller/category_provider.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/notes/controller/folders_controller.dart';

class CategoryList extends ConsumerWidget {
  const CategoryList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryProvider);
    final isAFolderClicked = ref
        .watch(currentlyClickedFolderProvider.select((state) => state != null));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CategoryCard(
            categoryType: Category.allNotes.categoryName,
            isSelected: category == Category.allNotes.categoryName,
            selectedColor: Color(0xFF4E94F8),
            categoryIcon: Icons.note_alt_sharp,
            onPressed: () {
              ref.read(currentlyClickedFolderProvider.notifier).state = null;
              ref.read(categoryProvider.notifier).state =
                  Category.allNotes.categoryName;
            }),
        CategoryCard(
            categoryType: Category.folders.categoryName,
            isSelected: category != Category.allNotes.categoryName,
            selectedColor: colorScheme.secondary,
            categoryIcon: Icons.folder_outlined,
            onPressed: () {
              if (isAFolderClicked) {
                ref.read(currentlyClickedFolderProvider.notifier).state = null;
              } else {
                ref.read(categoryProvider.notifier).state =
                    Category.folders.categoryName;
              }
            })
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryType;
  final bool isSelected;
  final Color selectedColor;
  final IconData categoryIcon;
  final VoidCallback onPressed;

  const CategoryCard(
      {super.key,
      required this.categoryType,
      required this.isSelected,
      required this.selectedColor,
      required this.categoryIcon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 140,
        height: 60,
        child: Card(
          color: isSelected ? selectedColor : colorScheme.surfaceContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: selectedColor,
                  foregroundColor: colorScheme.onInverseSurface,
                  radius: 21.0,
                  child: Icon(
                    categoryIcon,
                    size: 21.0,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  categoryType,
                  style: Styles.w600texts(
                      color: isSelected
                          ? colorScheme.onInverseSurface
                          : colorScheme.inverseSurface,
                      fontSize: 13.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
