import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/home_screen_providers/note_type_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 5.0,
      childAspectRatio: 170 / 70,
      children: [
        CategoryCard(
            categoryType: 'All Notes',
            categoryColor: colorScheme.tertiary,
            categoryIcon: Icons.note_alt_sharp),
        CategoryCard(
            categoryType: 'Folders',
            categoryColor: colorScheme.secondary,
            categoryIcon: Icons.folder_outlined)
      ],
    );
  }
}

class CategoryCard extends ConsumerWidget {
  final String categoryType;
  final Color categoryColor;
  final IconData categoryIcon;

  const CategoryCard(
      {super.key,
      required this.categoryType,
      required this.categoryColor,
      required this.categoryIcon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteType = ref.watch(categoryProvider);
    final noteTypeNotifier = ref.read(categoryProvider.notifier);

    return GestureDetector(
      onTap: () => noteTypeNotifier.updateCategory(categoryType),
      child: SizedBox(
        width: 160,
        height: 70,
        child: Card(
          color: categoryType == noteType
              ? categoryColor
              : colorScheme.surfaceContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: categoryColor,
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
                      color: categoryType == noteType
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
