import 'package:flutter/material.dart';
import 'package:notetakingapp1/core/theme/styles.dart';

class EmptyScreenBody extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyScreenBody({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48.0, color: Colors.grey),
          const SizedBox(height: 8.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Styles.universalFont(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
