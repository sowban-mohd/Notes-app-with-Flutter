import 'package:flutter/material.dart';

bool isDesktop(context) => MediaQuery.sizeOf(context).width >= 1100;
bool isTablet(context) => MediaQuery.sizeOf(context).width >= 500;
