import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

class PhotoService {
  static final PhotoService _instance = PhotoService._internal();

  factory PhotoService() => _instance;

  PhotoService._internal();

  Future<String?> takePhoto() async {
    return await _pickImageWeb(
      accept: 'image/*',
      capture: 'camera',
    );
  }

  Future<String?> pickPhotoFromGallery() async {
    return await _pickImageWeb(
      accept: 'image/*',
    );
  }

  Future<String?> _pickImageWeb({required String accept, String? capture}) async {
    final input = html.FileUploadInputElement()
      ..accept = accept
      ..multiple = false;

    if (capture != null) {
      input.setAttribute('capture', capture);
    }

    final completer = Completer<String?>();

    input.onChange.listen((_) {
      final files = input.files;
      if (files == null || files.isEmpty) {
        completer.complete(null);
        return;
      }

      final file = files.first;
      final reader = html.FileReader();

      reader.onLoad.listen((_) {
        final result = reader.result;
        if (result is String && result.startsWith('data:')) {
          completer.complete(result);
        } else {
          completer.complete(null);
        }
      });

      reader.onError.listen((_) {
        completer.complete(null);
      });

      reader.readAsDataUrl(file);
    });

    input.click();
    return completer.future;
  }

  Future<List<String>> getSavedPhotos() async {
    return [];
  }

  Future<bool> deletePhoto(String filePath) async {
    return false;
  }
}
