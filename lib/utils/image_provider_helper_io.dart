import 'dart:io';
import 'package:flutter/material.dart';

ImageProvider getImageProvider(String imagePath) {
  final trimmedPath = imagePath.trim();

  if (trimmedPath.startsWith('data:image/') ||
      trimmedPath.startsWith('http://') ||
      trimmedPath.startsWith('https://')) {
    return NetworkImage(trimmedPath);
  }

  final file = File(trimmedPath);
  if (file.existsSync()) {
    return FileImage(file);
  }

  return AssetImage(trimmedPath);
}
