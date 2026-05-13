import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/photo_service.dart';
import '../localization/app_localizations.dart';
import '../utils/image_provider_helper.dart';

class PhotoPickerScreen extends StatefulWidget {
  final Function(String) onPhotoSelected;

  const PhotoPickerScreen({
    super.key,
    required this.onPhotoSelected,
  });

  @override
  State<PhotoPickerScreen> createState() => _PhotoPickerScreenState();
}

class _PhotoPickerScreenState extends State<PhotoPickerScreen> {
  final PhotoService _photoService = PhotoService();
  String? _selectedPhotoPath;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(localization.createPostUploadPhoto),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade600,
                Colors.pink.shade500,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _selectedPhotoPath == null
          ? _buildPhotoOptions(context, localization)
          : _buildPhotoPreview(context, localization),
    );
  }

  Widget _buildPhotoOptions(BuildContext context, AppLocalizations localization) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPhotoButton(
          context,
          icon: Icons.camera_alt,
          label: localization.createPostTakePhoto,
          onPressed: _takePhoto,
          color: Colors.blue,
        ),
        const SizedBox(height: 24),
        _buildPhotoButton(
          context,
          icon: Icons.image,
          label: localization.createPostGallery,
          onPressed: _pickFromGallery,
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        _buildPhotoButton(
          context,
          icon: Icons.folder,
          label: 'Fotos Guardadas',
          onPressed: _showSavedPhotos,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildPhotoButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Semantics(
        button: true,
        label: label,
        hint: 'Pulsa para $label',
        child: Material(
          child: InkWell(
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.8), color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 32, color: Colors.white),
                  const SizedBox(width: 16),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPreview(BuildContext context, AppLocalizations localization) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: getImageProvider(_selectedPhotoPath!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _selectedPhotoPath = null),
                  icon: const Icon(Icons.edit),
                  label: Text(localization.cancel),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    widget.onPhotoSelected(_selectedPhotoPath!);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: Text(localization.ok),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _takePhoto() async {
    final photoPath = await _photoService.takePhoto();
    if (photoPath != null && mounted) {
      setState(() => _selectedPhotoPath = photoPath);
    }
  }

  Future<void> _pickFromGallery() async {
    final photoPath = await _photoService.pickPhotoFromGallery();
    if (photoPath != null && mounted) {
      setState(() => _selectedPhotoPath = photoPath);
    }
  }

  Future<void> _showSavedPhotos() async {
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las fotos guardadas no están disponibles en web')),
        );
      }
      return;
    }
    final photos = await _photoService.getSavedPhotos();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fotos Guardadas'),
        content: photos.isEmpty
            ? const Text('No hay fotos guardadas')
            : SizedBox(
                width: double.maxFinite,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedPhotoPath = photos[index]);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: getImageProvider(photos[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

}
