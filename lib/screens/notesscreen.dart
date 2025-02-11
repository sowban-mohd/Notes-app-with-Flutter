import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notetakingapp1/providers/notes_provider.dart';

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
                          return ListView.builder(
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                final note = notes[index];
                                return ListTile(
                                  title: Text(note['title'] ?? ''),
                                  subtitle: Text(note['content'] ?? ''),
                                  onTap: () {
                                    context.go('/note');
                                  },
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
          tooltip: 'Create new notes',
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
