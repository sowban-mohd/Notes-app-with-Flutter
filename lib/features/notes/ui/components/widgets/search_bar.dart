import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:notetakingapp1/features/notes/controller/search_provider.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/core/utils.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  const SearchBarWidget({super.key});

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(searchProvider));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 8.0, bottom: Utils.isDesktop(context) ? 18.0 : 8.0),
      child: Theme(
        data: Styles.textSelectionTheme(),
        child: SearchBar(
          controller: _searchController,
          leading: Icon(
            Icons.search,
            color: colorScheme.outline,
          ),
          onChanged: (query) {
            ref.read(searchProvider.notifier).state = query;
          }, //Starts filtering notes based on query once the user starts typing
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          }, //Unfocus the searchbar when user clicks anywhere outside of the searchbar
          elevation: WidgetStatePropertyAll(1.0),
          overlayColor: WidgetStatePropertyAll(
              colorScheme.surfaceContainer), //Color when focused
          constraints: BoxConstraints(
            minHeight: 38,
            maxWidth: Utils.isDesktop(context)
                ? 400
                : 320, //A max width is given so that it won't stretch in desktop
          ),
          backgroundColor: WidgetStatePropertyAll(
              colorScheme.surfaceContainer), //Color when unfocused
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
