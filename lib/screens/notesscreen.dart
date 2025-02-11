import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
                )
              ],
            ),
          ),
        ),
        floatingActionButton: 
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, right: 6.0),
          child: FloatingActionButton(
            onPressed: (){
              context.go('/note');
          },
          elevation: 2.0,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: const Icon(Icons.edit),
          ),
        ),);
  }
}
