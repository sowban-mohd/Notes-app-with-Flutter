import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays a confirmation dialog before actions like LogOut, Note deletion
Future<bool?> showConfirmationDialog(BuildContext context, {String? type}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        if (type == 'Delete note') {
          return Dialog(
            child: Container(
              padding: EdgeInsets.only(top: 14),
              width: 350,
              height: 175,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4, left: 8, right: 8),
                    child: Column(children: [
                      Text(
                        'Delete Note',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Are you sure you want to delete this note?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          color: Colors.black.withValues(alpha: 51.0),
                        ),
                      ),
                    ]),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top:
                                  BorderSide(color: Colors.black54, width: 1.0),
                              right:
                                  BorderSide(color: Colors.black54, width: 1.0),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(12.0)),
                            border: Border(
                              top:
                                  BorderSide(color: Colors.black54, width: 1.0),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text(
                              'Delete',
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return Dialog();
        }
      });
}
