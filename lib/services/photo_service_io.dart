import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class PhotoService {
  static final PhotoService _instance = PhotoService._internal();
  final ImagePicker _imagePicker = ImagePicker();

  factory PhotoService() {
    return _instance;
  }

  PhotoService._internal();

  /// Captura una foto usando la cámara
  Future<String?> takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );

      if (photo != null) {
        return await _savePhotoFromXFile(photo);
      }
      return null;
    } catch (e) {
      print('Error al capturar foto: $e');
      return null;
    }
  }

  /// Selecciona una foto de la galería
  Future<String?> pickPhotoFromGallery() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (photo != null) {
        return await _savePhotoFromXFile(photo);
      }
      return null;
    } catch (e) {
      print('Error al seleccionar foto: $e');
      return null;
    }
  }

  /// Guarda la foto en el directorio de la aplicación
  Future<String> _savePhotoFromXFile(XFile sourceFile) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String photoDir = path.join(appDir.path, 'photos');
      final Directory photoDirFile = Directory(photoDir);
      if (!await photoDirFile.exists()) {
        await photoDirFile.create(recursive: true);
      }

      final String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(photoDir, fileName);
      final File savedFile = File(filePath);
      final bytes = await sourceFile.readAsBytes();
      await savedFile.writeAsBytes(bytes, flush: true);
      return savedFile.path;
    } catch (e) {
      print('Error al guardar foto: $e');
      rethrow;
    }
  }

  /// Obtiene todas las fotos guardadas
  Future<List<String>> getSavedPhotos() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String photoDir = '${appDir.path}/photos';
      final Directory photoDirFile = Directory(photoDir);

      if (!await photoDirFile.exists()) {
        return [];
      }

      final List<FileSystemEntity> files = photoDirFile.listSync();
      final List<String> photoPaths = [];

      for (var file in files) {
        if (file is File &&
            (file.path.endsWith('.jpg') ||
                file.path.endsWith('.jpeg') ||
                file.path.endsWith('.png'))) {
          photoPaths.add(file.path);
        }
      }

      return photoPaths;
    } catch (e) {
      print('Error al obtener fotos: $e');
      return [];
    }
  }

  /// Elimina una foto guardada
  Future<bool> deletePhoto(String filePath) async {
    try {
      final File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error al eliminar foto: $e');
      return false;
    }
  }
}
