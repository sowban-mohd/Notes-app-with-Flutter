import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/controllers_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteEditingscreen extends ConsumerWidget {
  const NoteEditingscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesController = ref.watch(controllersProvider).notesController;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 2.0, right: 10.0, top: 6.0, bottom: 18.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        context.go('/home');
                      },
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.blue),
                      label: Text(
                        "Back",
                        style: GoogleFonts.nunitoSans(
                          color: Colors.blue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          context.go('/home');
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            minimumSize: const Size(60, 35),
                            backgroundColor: Color.fromRGBO(31, 33, 36, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        child: Text(
                          'Save',
                          style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ]),
            ),
            Theme(
              data: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Colors.blue,
                  selectionColor: Colors.blue.withAlpha(51),
                  selectionHandleColor: Colors.blue,
                ),
              ),
              child: TextField(
                controller: notesController.titleController,
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 26.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    hintText: 'Page Title',
                    hintStyle: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 26.0,
                      color: Color.fromRGBO(28, 33, 33, 0.3),
                    )),
              ),
            ),
            Expanded(
              child: Theme(
                data: ThemeData(
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: Colors.blue,
                    selectionColor: Colors.blue.withAlpha(51),
                    selectionHandleColor: Colors.blue,
                  ),
                ),
                child: TextField(
                  controller: notesController.contentController,
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.normal,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 18.0, right: 18.0, top: 8.0, bottom: 20.0),
                      hintText: 'Notes goes here...',
                      hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        color: Color.fromRGBO(28, 33, 33, 0.3),
                      )),
                  maxLines: null,
                  expands: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
