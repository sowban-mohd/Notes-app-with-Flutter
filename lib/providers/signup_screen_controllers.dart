import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final emailControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

final passwordControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

final passwordVisibilityProvider = StateProvider<bool>((ref) => true);