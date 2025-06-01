import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/core/constants/constants.dart';
import 'package:notetakingapp1/core/constants/routes.dart';
import 'package:notetakingapp1/core/providers/shared_prefs_provider.dart';
import 'package:notetakingapp1/core/utils.dart';
import 'package:notetakingapp1/features/auth/controller/auth_controller.dart';
import 'package:notetakingapp1/features/notes/controller/all_notes_controller.dart';
import 'package:notetakingapp1/features/notes/controller/folders_controller.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/home_app_bar.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/category_list.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/home_body.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/home_fab.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/search_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Listener for generalError
    ref.listen(authControllerProvider.select((state) => state.generalError),
        (prev, next) async {
      if (next != null) {
        Utils.showSnackbar(context, next);
      }
    });

    ref.listen(userProvider, (prev, next) {
      next.whenData((next) async {
        if (next == null) {
          final prefs = ref.read(sharedPreferencesProvider);
          final loginPath = Routes.loginScreen.path;
          final goContext = GoRouter.of(context);
          await prefs.setString(Constants.initialLocationKey, loginPath);
          goContext.go(loginPath);
        }
      });
    });

    ref.listen(allNotesControllerProvider, (_, next) {
      if (next.successMessage != null || next.errorMessage != null) {
        final message = next.successMessage ?? next.errorMessage;
        Utils.showSnackbar(context, message!);
      }
    });

    ref.listen(
      foldersControllerProvider,
      (_, next) {
        if (next.successMessage != null || next.errorMessage != null) {
          final message = next.successMessage ?? next.errorMessage;
          Utils.showSnackbar(context, message!);
        }
      },
    );

    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: HomeAppbar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18.0, top: 10.0, bottom: 16.0),
            child: Consumer(
              builder: (context, ref, child) {
                User? user;
                ref
                    .watch(userProvider)
                    .whenData((currentUser) => user = currentUser);
                if (user == null) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                      Text(
                        'Logging out...',
                        style: Styles.universalFont(fontSize: 16.0),
                      ),
                    ],
                  )); // Show spinner
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SearchBarWidget(),
                    CategoryList(),
                    SizedBox(height: screenHeight * 0.01),
                    Expanded(
                      child: HomeBody(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButton: HomeFAB());
  }
}
