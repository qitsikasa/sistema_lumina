import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? _currentUser;
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
      final user = await UserService.getUser();
      setState(() {
        _currentUser = user;
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
    if (_currentUser?.profileImageUrl != null &&
        _currentUser!.profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(_currentUser!.profileImageUrl!),
        onBackgroundImageError: (exception, stackTrace) {
          print('Error cargando imagen de perfil: $exception');
        },
      );
    } else {
      return CircleAvatar(
        radius: 16,
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.person, size: 20, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final userName = _currentUser?.name ?? 'Usuario';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header superior
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Inicio',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _buildProfileImage(),
                ],
              ),
              const SizedBox(height: 40),

              // Sección principal de bienvenida
              Center(
                child: Column(
                  children: [
                    Text(
                      '¡Hola, $userName!',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Image.asset(
                      'images/saludo.png',
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Sección Acciones Rápidas
              const Text(
                'Acciones Rápidas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Barra de búsqueda
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar archivos...',
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Botones de acciones rápidas
              Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.upload_file,
                      iconColor: Colors.blue,
                      title: 'Subir Archivo',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Subir archivo próximamente'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.people,
                      iconColor: Colors.orange,
                      title: 'Conectar con Compañeros',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Conectar próximamente'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Sección Recomendaciones Inteligentes de Mentora
              const Text(
                'Recomendaciones Inteligentes de Mentora',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Tarjetas de recomendaciones
              _RecommendationCard(
                title: '¡Mentora tiene nuevos ejercicios!',
                description: 'Practica los últimos temas de Matemáticas.',
              ),
              const SizedBox(height: 12),
              _RecommendationCard(
                title: 'Repasa \'La Revolución Francesa\'',
                description: 'Según tu progreso, es hora de un repaso.',
              ),
              const SizedBox(height: 12),
              _RecommendationCard(
                title: 'Tu resumen personalizado',
                description: 'El resumen de \'Termodinámica\' está listo.',
              ),
              const SizedBox(height: 40),

              // Sección Mis Materias
              const Text(
                'Mis Materias',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Tarjetas de materias
              Row(
                children: [
                  Expanded(
                    child: _SubjectCard(
                      title: 'Matemáticas discretas',
                      subtitle: 'Apuntes    Exámenes',
                      status: 'Nuevo material disponible',
                      icon: Icons.calculate,
                      iconColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SubjectCard(
                      title: 'Física Cuántica',
                      subtitle: 'Apuntes',
                      status: 'Actividad reciente',
                      icon: Icons.science,
                      iconColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
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
  final String description;

  const _RecommendationCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final IconData icon;
  final Color iconColor;

  const _SubjectCard({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            status,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
