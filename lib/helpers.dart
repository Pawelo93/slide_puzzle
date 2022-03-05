import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<ui.Image> loadImage(String path) async {
  final data = await rootBundle.load(path);
  final list = Uint8List.view(data.buffer);
  return decodeImageFromList(list);
}