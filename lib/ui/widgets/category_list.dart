import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/category_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class CategoryList extends ConsumerWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteType = ref.watch(categoryProvider);

    return Row(
      children: [
        CategoryCard(
            categoryType: 'All Notes',
            isSelected: noteType == 'All Notes',
            selectedColor: Color(0xFF4E94F8),
            categoryIcon: Icons.note_alt_sharp),
        CategoryCard(
            categoryType: 'Folders',
            isSelected: noteType != 'All Notes',
            selectedColor: colorScheme.secondary,
            categoryIcon: Icons.folder_outlined)
      ],
    );
  }
}

class CategoryCard extends ConsumerWidget {
  final String categoryType;
  final bool isSelected;
  final Color selectedColor;
  final IconData categoryIcon;

  const CategoryCard(
      {super.key,
      required this.categoryType,
      required this.isSelected,
      required this.selectedColor,
      required this.categoryIcon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteTypeNotifier = ref.read(categoryProvider.notifier);

    return GestureDetector(
      onTap: () => noteTypeNotifier.state = categoryType,
      child: SizedBox(
        width: 160,
        height: 65,
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
                  width: 8.0,
                ),
                Text(
                  categoryType,
                  style: Styles.w600texts(
                      color: isSelected
                          ? colorScheme.onInverseSurface
                          : colorScheme.inverseSurface,
                      fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
