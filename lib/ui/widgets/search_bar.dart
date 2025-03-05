import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetakingapp1/logic/search_controller.dart';
import 'package:notetakingapp1/ui/utils/styles.dart';
import 'package:notetakingapp1/ui/utils/utils.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _searchController;
  final _searchControllerX = Get.find<SearchControllerX>();

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: _searchControllerX.searchQuery.value);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Styles.textSelectionTheme(),
      child: Obx(() {
        final searchQuery = _searchControllerX.searchQuery;
        return SearchBar(
          controller: _searchController,
          leading: Icon(
            Icons.search,
            color: colorScheme.outline,
          ),
          trailing: [
            if (searchQuery.isNotEmpty) ...[
              IconButton(
                  onPressed: () {
                    searchQuery.value = '';
                    _searchController.clear();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: colorScheme.outline,
                  ))
            ]
          ],
          onChanged: (query) {
            searchQuery.value = query;
          }, //Starts filtering notes based on query once the user starts typing
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          }, //Unfocus the searchbar when user clicks anywhere outside of the searchbar
          elevation: WidgetStatePropertyAll(1.0),
          overlayColor: WidgetStatePropertyAll(
              colorScheme.surfaceContainer), //Color when focused
          constraints: BoxConstraints(
            minHeight: 38,
            maxWidth: isDesktop(context)
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
        );
      }),
    );
  }
}
