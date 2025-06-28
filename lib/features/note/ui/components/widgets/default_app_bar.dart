import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/auth/controller/auth_controller.dart';
import 'package:notetakingapp1/features/note/ui/components/widgets/confirmaton_dialog.dart';

class DefaultAppBar extends ConsumerWidget implements PreferredSizeWidget {
  DefaultAppBar({super.key});

  final String formattedDate =
      DateFormat('d MMMM, yyyy').format(DateTime.now()); //Formatted date

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider.notifier);

    return AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        title: Padding(
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
                style: Styles.titleStyle(fontSize: 22.0),
              ),
            ],
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
                return [
                  PopupMenuItem(
                    child: Text(
                      'Log out',
                      style: Styles.w500texts(fontSize: 15.0),
                    ),
                    onTap: () async {
                      bool? confirmation = await showConfirmationDialog(context,
                          type: 'Log Out');
                      if (confirmation == true) {
                        await authController.logOut();
                      }
                    },
                  ),
                  if (Platform.isAndroid)
                    PopupMenuItem(
                      child: Text(
                        'Quit app',
                        style: Styles.w500texts(fontSize: 15.0),
                      ),
                      onTap: () async {
                        bool? confirmation = await showConfirmationDialog(
                            context,
                            type: 'Quit App');
                        if (confirmation == true) {
                          SystemNavigator.pop();
                        }
                      },
                    ),
                ];
              },
            ),
          )
        ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
