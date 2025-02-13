import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../providers/notes_screen_providers/note_controllers.dart';
import '../../../providers/notes_screen_providers/note_selection_provider.dart';
import '../../../providers/notes_screen_providers/notes_provider.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('d MMMM, yyyy').format(DateTime.now());
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 246, 1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: GoogleFonts.nunito(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(60, 60, 67, 0.6),
                        ),
                      ),
                      Text(
                        'Notes',
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      //Icon function
                    },
                    icon: Icon(
                      Icons.more_horiz,
                    ),
                    color: Color.fromRGBO(78, 148, 248, 1),
                  ),
                ],
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final notesAsync = ref.watch(notesProvider);

                    return notesAsync.when(
                        data: (notes) {
                          if (notes.isEmpty) {
                            return Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit_note,
                                  size: 50.0,
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  'No notes yet!\nCreate one.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ));
                          }
                          return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 6.0,
                                mainAxisSpacing: 12.0,
                                childAspectRatio: 168 / 198,
                              ),
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                final note = notes[index];
                                final String? noteId = note['noteId'];
                                final String title = note['title'];
                                final bool hasTitle = title.trim().isNotEmpty;
                                final selectionState =
                                    ref.watch(selectionProvider);
                                final isSelected =
                                    selectionState[index] ?? false;

                                return GestureDetector(
                                  onTap: () {
                                    final controllers = ref.read(notesControllersProvider);
                                    controllers.titleController.text = note['title'];
                                    controllers.contentController.text = note['content'];

                                    context.go('/note?noteId=$noteId');
                                  },
                                  onLongPress: () => ref
                                      .read(selectionProvider.notifier)
                                      .toggleSelection(index),
                                  child: Card(
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: isSelected
                                          ? BorderSide(
                                              color: Colors.blue, width: 1.0)
                                          : BorderSide.none,
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (hasTitle) ...[
                                            Text(
                                              title,
                                              style: GoogleFonts.nunitoSans(
                                                color: Color.fromRGBO(
                                                    28, 33, 33, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                            Divider(),
                                            SizedBox(
                                              height: 3,
                                            ),
                                          ],
                                          Flexible(
                                            child: Text(note['content'] ?? '',
                                                style: GoogleFonts.nunitoSans(
                                                    color: Color.fromRGBO(
                                                        28, 33, 33, 1),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 14),
                                                overflow: TextOverflow.fade),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        loading: () => Center(
                                child: CircularProgressIndicator(
                              color: Colors.blue,
                            )),
                        error: (error, stackTrace) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'An error occured',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                                TextButton(
                                    onPressed: () => ref.refresh(notesProvider),
                                    child: Text(
                                      'Retry',
                                      style: GoogleFonts.nunito(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ))
                              ],
                            )));
                          });
                          return SizedBox.shrink();
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, right: 6.0),
        child: FloatingActionButton(
          tooltip: 'Create a new note',
          onPressed: () {
            context.go('/note');
          },
          elevation: 2.0,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
