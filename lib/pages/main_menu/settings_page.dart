import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoSaveEnabled = true;
  String _selectedLanguage = 'Español';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ajustes',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C4DFF),
            ),
          ),
          const SizedBox(height: 32),

          Expanded(
            child: ListView(
              children: [
                _SettingsSection(
                  title: 'Notificaciones',
                  icon: Icons.notifications,
                  children: [
                    _SwitchTile(
                      title: 'Notificaciones push',
                      subtitle: 'Recibe notificaciones de nuevas actividades',
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    _ListTile(
                      title: 'Frecuencia de notificaciones',
                      subtitle: 'Cada hora',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Mostrar opciones de frecuencia
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _SettingsSection(
                  title: 'Apariencia',
                  icon: Icons.palette,
                  children: [
                    _SwitchTile(
                      title: 'Modo oscuro',
                      subtitle: 'Cambiar entre tema claro y oscuro',
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          _darkModeEnabled = value;
                        });
                      },
                    ),
                    _ListTile(
                      title: 'Idioma',
                      subtitle: _selectedLanguage,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        _showLanguageDialog();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _SettingsSection(
                  title: 'Almacenamiento',
                  icon: Icons.storage,
                  children: [
                    _SwitchTile(
                      title: 'Guardado automático',
                      subtitle: 'Guardar archivos automáticamente',
                      value: _autoSaveEnabled,
                      onChanged: (value) {
                        setState(() {
                          _autoSaveEnabled = value;
                        });
                      },
                    ),
                    _ListTile(
                      title: 'Limpiar caché',
                      subtitle: 'Liberar espacio de almacenamiento',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        _showClearCacheDialog();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _SettingsSection(
                  title: 'Privacidad y Seguridad',
                  icon: Icons.security,
                  children: [
                    _ListTile(
                      title: 'Cambiar contraseña',
                      subtitle: 'Actualizar tu contraseña de acceso',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navegar a cambio de contraseña
                      },
                    ),
                    _ListTile(
                      title: 'Configuración de privacidad',
                      subtitle: 'Gestionar quién puede ver tu perfil',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navegar a configuración de privacidad
                      },
                    ),
                    _ListTile(
                      title: 'Sesiones activas',
                      subtitle: 'Ver y cerrar sesiones en otros dispositivos',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Mostrar sesiones activas
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _SettingsSection(
                  title: 'Soporte',
                  icon: Icons.help,
                  children: [
                    _ListTile(
                      title: 'Centro de ayuda',
                      subtitle: 'Encontrar respuestas a preguntas frecuentes',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Abrir centro de ayuda
                      },
                    ),
                    _ListTile(
                      title: 'Contactar soporte',
                      subtitle: 'Enviar un mensaje al equipo de soporte',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Contactar soporte
                      },
                    ),
                    _ListTile(
                      title: 'Acerca de Lumina',
                      subtitle: 'Información sobre la aplicación',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        _showAboutDialog();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Botón de cerrar sesión
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showLogoutDialog();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Seleccionar idioma'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LanguageOption('Español', 'Español'),
                _LanguageOption('English', 'Inglés'),
                _LanguageOption('Français', 'Francés'),
              ],
            ),
          ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Limpiar caché'),
            content: const Text(
              '¿Estás seguro de que quieres limpiar el caché? Esto liberará espacio de almacenamiento.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Caché limpiado exitosamente'),
                    ),
                  );
                },
                child: const Text('Limpiar'),
              ),
            ],
          ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Acerca de Lumina'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Versión: 1.0.0'),
                SizedBox(height: 8),
                Text(
                  'Lumina es una plataforma de aprendizaje colaborativo diseñada para estudiantes universitarios.',
                ),
                SizedBox(height: 16),
                Text('© 2024 Lumina. Todos los derechos reservados.'),
              ],
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Cerrar sesión en Supabase
                    await Supabase.instance.client.auth.signOut();

                    // Limpiar datos del usuario
                    await UserService.clearUser();

                    Navigator.pop(context);

                    // Navegar a la página de login
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  } catch (e) {
                    print('Error al cerrar sesión: $e');
                    Navigator.pop(context);

                    // Intentar navegar de todas formas
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Cerrar Sesión'),
              ),
            ],
          ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF6C4DFF)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF6C4DFF),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const _ListTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String language;
  final String displayName;

  const _LanguageOption(this.language, this.displayName);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(displayName),
      onTap: () {
        Navigator.pop(context);
        // Aquí se cambiaría el idioma
      },
    );
  }
}
