import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const SettingsScreen({super.key, required this.themeNotifier});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Volver',
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Ajustes'),
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
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: widget.themeNotifier,
        builder: (context, themeMode, _) {
          return ListView(
            children: [
              // Sección de Tema
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apariencia',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    // Tema Claro
                    _buildThemeCard(
                      context: context,
                      title: 'Modo Claro',
                      icon: Icons.light_mode,
                      isSelected: themeMode == ThemeMode.light,
                      onTap: () => _setTheme(ThemeMode.light),
                    ),
                    const SizedBox(height: 12),
                    // Tema Oscuro
                    _buildThemeCard(
                      context: context,
                      title: 'Modo Oscuro',
                      icon: Icons.dark_mode,
                      isSelected: themeMode == ThemeMode.dark,
                      onTap: () => _setTheme(ThemeMode.dark),
                    ),
                    const SizedBox(height: 12),
                    // Tema Sistema
                    _buildThemeCard(
                      context: context,
                      title: 'Sistema',
                      icon: Icons.brightness_auto,
                      isSelected: themeMode == ThemeMode.system,
                      onTap: () => _setTheme(ThemeMode.system),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),
              // Sección de Información
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      context: context,
                      icon: Icons.info_outline,
                      title: 'Acerca de InstaDAM',
                      subtitle: 'Versión 1.0.0',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoTile(
                      context: context,
                      icon: Icons.accessibility,
                      title: 'Accesibilidad',
                      subtitle: 'Características inclusivas para todos',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _setTheme(ThemeMode mode) async {
    widget.themeNotifier.value = mode;
    await PreferencesService.setThemeMode(mode);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            mode == ThemeMode.light
                ? 'Modo claro activado'
                : mode == ThemeMode.dark
                    ? 'Modo oscuro activado'
                    : 'Tema del sistema activado',
          ),
          duration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  Widget _buildThemeCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? Colors.blue.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected ? Colors.blue : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : null,
                        color: isSelected ? Colors.blue : null,
                      ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
