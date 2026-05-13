import 'package:flutter/material.dart';

ImageProvider getImageProvider(String imagePath) {
  final trimmedPath = imagePath.trim();

  if (trimmedPath.startsWith('data:image/') ||
      trimmedPath.startsWith('http://') ||
      trimmedPath.startsWith('https://')) {
    return NetworkImage(trimmedPath);
  }

  return AssetImage(trimmedPath);
}
