import 'dart:io';
import 'package:test/test.dart';

void prepareTest() {
  // https://github.com/flutter/flutter/issues/20907
  if (Directory.current.path.endsWith('/test')) {
    Directory.current = Directory.current.parent;
  }
}

void main() {
  prepareTest();
}