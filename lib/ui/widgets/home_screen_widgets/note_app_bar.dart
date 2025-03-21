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

    //App bar when notes are selected
    return selectedNotes.isNotEmpty
        ? AppBar(
            backgroundColor: colorScheme.surfaceContainerLowest,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      selectionNotifier.clearSelection();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: colorScheme.primary,
                      size: 22.0,
                    ),
                    label: Text('${selectedNotes.length}',
                        style: Styles.textButtonStyle(
                            fontSize: 18.0)),
                  ),
                ]))
        :
        //Normal app bar
        AppBar(
            elevation: 0.0,
            backgroundColor: colorScheme.surface,
            title: Padding(
              padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Date and Title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                  //Log out button
                  IconButton(
                    tooltip: 'Log Out',
                    onPressed: () async {
                      bool? confirmation = await showConfirmationDialog(context,
                          type: 'Log out');
                      if (confirmation == true) {
                        await authNotifier.logOut();
                      }
                    },
                    icon: Icon(
                      Icons.logout,
                    ),
                    color: colorScheme.onSurface.withAlpha(153),
                  ),
                ],
              ),
            ),
          );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
