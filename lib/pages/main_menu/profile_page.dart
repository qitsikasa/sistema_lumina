import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../../services/storage_service.dart'; // Added import for StorageService

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _currentUser;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await UserService.getUser();
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      setState(() {
        _isUploading = true;
      });

      // Verificar conexión con Supabase Storage
      final isConnected = await StorageService.checkStorageConnection();
      if (!isConnected) {
        setState(() {
          _isUploading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Error de conexión con el servidor'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      final MediaInfo? image = await ImagePickerWeb.getImageInfo();

      if (image != null && _currentUser != null) {
        // Mostrar indicador de carga
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Subiendo imagen...'),
                ],
              ),
              duration: Duration(seconds: 5),
            ),
          );
        }

        // Subir imagen a Supabase Storage
        final imageUrl = await UserService.uploadNewProfileImage(
          image,
          _currentUser!.id,
        );

        if (imageUrl != null) {
          // Actualizar usuario con la nueva URL
          final updatedUser = _currentUser!.copyWith(profileImageUrl: imageUrl);

          // Guardar en SharedPreferences
          await UserService.updateUser(updatedUser);

          setState(() {
            _currentUser = updatedUser;
            _isUploading = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Foto de perfil actualizada'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else {
          setState(() {
            _isUploading = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('❌ Error al subir la imagen'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      } else {
        setState(() {
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al actualizar foto: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildProfileImage() {
    if (_currentUser?.profileImageUrl != null &&
        _currentUser!.profileImageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          _currentUser!.profileImageUrl!,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C4DFF)),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // Si hay error al cargar la imagen, mostrar la imagen por defecto
            return ClipOval(
              child: Image.asset(
                'images/EmuOtori.webp',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      );
    }

    // Imagen por defecto
    return ClipOval(
      child: Image.asset(
        'images/EmuOtori.webp',
        width: 64,
        height: 64,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
      child: ListView(
        children: [
          const Text(
            'Mi Perfil',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _isUploading ? null : _pickImage,
                  child: Stack(
                    children: [
                      _buildProfileImage(),
                      if (!_isUploading)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C4DFF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      if (_isUploading)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _currentUser!.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4DFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              // Aquí se abriría un modal para editar perfil
                            },
                            child: const Text(
                              'Editar Perfil',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CORREO ELECTRÓNICO:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  _currentUser!.email,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'CARRERA:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  _currentUser!.career,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ID DE ESTUDIANTE:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  _currentUser!.studentId,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'FACULTAD:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  _currentUser!.faculty,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Reputación
          const Text(
            'Mi Reputación',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_currentUser!.reputationPoints} Puntos',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF6C4DFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nivel: ${_currentUser!.level}',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value:
                      _currentUser!.reputationPoints /
                      2000, // Meta de 2000 puntos
                  color: const Color(0xFF6C4DFF),
                  backgroundColor: Colors.grey.shade300,
                  minHeight: 8,
                ),
                const SizedBox(height: 4),
                Text(
                  'Has alcanzado el ${((_currentUser!.reputationPoints / 2000) * 100).toInt()}% de tu meta de puntos',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Actividad reciente
          const Text(
            'Actividad Reciente',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _ActividadItem(
                  icon: Icons.upload_file,
                  texto:
                      'Subiste un nuevo archivo a Cálculo I: Ejercicios_Caps.pdf',
                  fecha: 'hace 3 horas',
                ),
                Divider(height: 1, color: Colors.grey.shade200),
                _ActividadItem(
                  icon: Icons.group,
                  texto:
                      'Te uniste al grupo de estudio de Taller de sistemas operativos',
                  fecha: 'ayer',
                ),
                Divider(height: 1, color: Colors.grey.shade200),
                _ActividadItem(
                  icon: Icons.star,
                  texto:
                      'Ganaste 50 puntos de reputación por ayudar a un compañero',
                  fecha: 'hace 2 días',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Ajustes de perfil
          const Text(
            'Ajustes de Perfil',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock, color: Color(0xFF6C4DFF)),
                  title: const Text('Privacidad'),
                  subtitle: const Text('Configura quién puede ver tu perfil'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                Divider(height: 1, color: Colors.grey.shade200),
                ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Color(0xFF6C4DFF),
                  ),
                  title: const Text('Notificaciones'),
                  subtitle: const Text('Gestiona tus notificaciones'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                Divider(height: 1, color: Colors.grey.shade200),
                ListTile(
                  leading: const Icon(Icons.password, color: Color(0xFF6C4DFF)),
                  title: const Text('Cambiar Contraseña'),
                  subtitle: const Text('Actualiza tu contraseña de acceso'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActividadItem extends StatelessWidget {
  final IconData icon;
  final String texto;
  final String fecha;

  const _ActividadItem({
    required this.icon,
    required this.texto,
    required this.fecha,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6C4DFF)),
      title: Text(texto, style: const TextStyle(fontSize: 14)),
      trailing: Text(
        fecha,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }
}
