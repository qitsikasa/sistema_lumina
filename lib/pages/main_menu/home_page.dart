import 'package:flutter/material.dart';
import '../../services/home_service.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../../models/materia_model.dart';
import '../../models/actividad_model.dart';
import '../../models/recomendacion_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? _currentUser;
  List<MateriaModel> _materias = [];
  List<RecomendacionModel> _recomendaciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Cargar datos en paralelo
      final futures = await Future.wait([
        UserService.getUser(),
        HomeService.getMaterias(),
        HomeService.getRecomendaciones(),
      ]);

      setState(() {
        _currentUser = futures[0] as UserModel?;
        _materias = futures[1] as List<MateriaModel>;
        _recomendaciones = futures[2] as List<RecomendacionModel>;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando datos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildProfileImage() {
    print('🔍 Debug: _currentUser = ${_currentUser?.name}');
    print('🔍 Debug: profileImageUrl = ${_currentUser?.profileImageUrl}');

    if (_currentUser?.profileImageUrl != null &&
        _currentUser!.profileImageUrl!.isNotEmpty) {
      print(
        '✅ Intentando cargar imagen desde: ${_currentUser!.profileImageUrl}',
      );
      return ClipOval(
        child: Image.network(
          _currentUser!.profileImageUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('❌ Error cargando imagen: $error');
            return const Icon(Icons.person, color: Colors.grey, size: 30);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              print('✅ Imagen cargada exitosamente');
              return child;
            }
            print(
              '⏳ Cargando imagen: ${(loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1) * 100).toStringAsFixed(1)}%',
            );
            return const CircularProgressIndicator(strokeWidth: 2);
          },
        ),
      );
    } else {
      print('⚠️ No hay URL de imagen disponible, mostrando ícono por defecto');
      return const Icon(Icons.person, color: Colors.grey, size: 30);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: Colors.grey.shade50,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con saludo y avatar
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola, ${_currentUser?.name ?? 'Usuario'}!',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4DFF),
                        ),
                      ),
                    ],
                  ),
                ),
                // Avatar del usuario con foto de Supabase Storage
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.shade200,
                  child: _buildProfileImage(),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Ilustración principal
            Row(
              children: [
                const Spacer(),
                Image.asset(
                  'assets/images/EmuOtori.webp',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Acciones Rápidas
            const Text(
              'Acciones Rápidas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Barra de búsqueda
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Buscar archivos...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        // Implementar búsqueda
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botones de acción rápida
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    title: 'Subir Archivo',
                    icon: Icons.upload_file,
                    color: Colors.blue,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _QuickActionButton(
                    title: 'Conectar con Compañeros',
                    icon: Icons.group,
                    color: Colors.green,
                    onTap: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Recomendaciones Inteligentes
            const Text(
              'Recomendaciones Inteligentes de Mentora',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Tarjetas de recomendación
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _RecommendationCard(
                    title: '¡Mentora tiene nuevos ejercicios!',
                    subtitle: 'Practica los últimos temas de Matemáticas.',
                    icon: Icons.calculate,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _RecommendationCard(
                    title: 'Repasa \'La Revolución Francesa\'',
                    subtitle: 'Según tu progreso, es hora de un repaso.',
                    icon: Icons.history,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  _RecommendationCard(
                    title: 'Tu resumen personalizado',
                    subtitle: 'El resumen de \'Termodinámica\' está listo.',
                    icon: Icons.science,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Mis Materias
            const Text(
              'Mis Materias',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Tarjetas de materias
            Row(
              children: [
                Expanded(
                  child: _SubjectCard(
                    title: 'Matemáticas discretas',
                    subtitle: 'Apuntes • Exámenes • Nuevo material disponible',
                    icon: Icons.calculate,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SubjectCard(
                    title: 'Física Cuántica',
                    subtitle: 'Apuntes • Actividad reciente',
                    icon: Icons.science,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 48),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _RecommendationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SubjectCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
