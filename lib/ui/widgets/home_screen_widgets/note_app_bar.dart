import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notetakingapp1/logic/providers/auth_screen_providers/auth_state_provider.dart';
import 'package:notetakingapp1/logic/providers/home_screen_providers.dart';
import 'package:notetakingapp1/ui/widgets/confirmaton_dialog.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class NoteAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const NoteAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String formattedDate =
        DateFormat('d MMMM, yyyy').format(DateTime.now()); //Formatted date
    final selectedNotes = ref.watch(selectionProvider); //List of selected notes
    final selectionNotifier =
        ref.read(selectionProvider.notifier); //Access to selection notifier
    final authNotifier = ref.read(authStateProvider
        .notifier); //Access to methods to manipukate authentication state

    return AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        title: selectedNotes.isEmpty
            ?
            // Default Appbar title
            Padding(
                padding: EdgeInsets.only(left: 4.0, top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Date and time
                    Text(
                      formattedDate,
                      style: Styles.w400texts(
                        fontSize: 12.0,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Notes',
                      style: Styles.titleStyle(fontSize: 24.0),
                    ),
                  ],
                ),
              )
            :
            //Appbar title when notes are selected
            Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: TextButton.icon(
                  onPressed: () {
                    selectionNotifier.clearSelection();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: colorScheme.primary,
                    size: 24.0,
                  ),
                  label: Text('${selectedNotes.length} selected',
                      style: Styles.w500texts(
                          fontSize: 20.0, color: colorScheme.primary)),
                ),
              ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 8.0),
            child: PopupMenuButton(
              icon: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary,
                    width: 1,
                  ),
                  color: colorScheme.surface,
                ),
                child: Icon(
                  Icons.more_horiz,
                  size: 15.0,
                  color: colorScheme.primary,
                ),
              ),
              color: colorScheme.surfaceContainer,
              constraints: BoxConstraints(minWidth: 120.0),
              itemBuilder: (context) {
                return selectedNotes.isEmpty
                    ?
                    //Default popup menu items
                    [
                        PopupMenuItem(
                          child: Text(
                            'Log out',
                            style: Styles.w500texts(fontSize: 15.0),
                          ),
                          onTap: () async {
                            bool? confirmation = await showConfirmationDialog(
                                context,
                                type: 'Log out');
                            if (confirmation == true) {
                              await authNotifier.logOut();
                            }
                          },
                        ),
                        PopupMenuItem(
                          child: Text(
                            'Quit app',
                            style: Styles.w500texts(fontSize: 15.0),
                          ),
                        ),
                      ]
                    : 
                    //Popup menu for selected notes
                    [
                        PopupMenuItem(
                            child: Text(
                              'Pin note',
                              style: Styles.w500texts(fontSize: 15.0),
                            ),
                            onTap: () {}),
                        PopupMenuItem(
                          child: Text(
                            'Add to folders',
                            style: Styles.w500texts(fontSize: 15.0),
                          ),
                        ),
                      ];
              },
            ),
          ),
        ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
