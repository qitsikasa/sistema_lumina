import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'main_menu/home_page.dart';
import 'main_menu/subjects_page.dart';
import 'main_menu/groups_page.dart';
import 'main_menu/files_page.dart';
import 'main_menu/ai_mentor_page.dart';
import 'main_menu/settings_page.dart';
import 'main_menu/profile_page.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final SideMenuController _sideMenuController = SideMenuController();
  final PageController _pageController = PageController();
  UserModel? _currentUser;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _sideMenuController.addListener((index) {
      setState(() {
        _currentPageIndex = index;
      });
      _pageController.jumpToPage(index);
    });
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

  Future<void> _refreshUserData() async {
    await UserService.syncUserWithSupabase();
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar personalizado
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Logo Lumina
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C4DFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.book,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Lumina',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4DFF),
                        ),
                      ),
                    ],
                  ),
                ),

                // Menú de navegación
                Expanded(
                  child: Column(
                    children: [
                      _NavigationItem(
                        icon: Icons.home,
                        title: 'Inicio',
                        isSelected: _currentPageIndex == 0,
                        onTap: () => _sideMenuController.changePage(0),
                      ),
                      _NavigationItem(
                        icon: Icons.book,
                        title: 'Materias',
                        isSelected: _currentPageIndex == 1,
                        onTap: () => _sideMenuController.changePage(1),
                      ),
                      _NavigationItem(
                        icon: Icons.group,
                        title: 'Grupos',
                        isSelected: _currentPageIndex == 2,
                        onTap: () => _sideMenuController.changePage(2),
                      ),
                      _NavigationItem(
                        icon: Icons.folder,
                        title: 'Archivos',
                        isSelected: _currentPageIndex == 3,
                        onTap: () => _sideMenuController.changePage(3),
                      ),
                      _NavigationItem(
                        icon: Icons.auto_awesome,
                        title: 'Mentora AI',
                        isSelected: _currentPageIndex == 4,
                        onTap: () => _sideMenuController.changePage(4),
                      ),
                      _NavigationItem(
                        icon: Icons.settings,
                        title: 'Ajustes',
                        isSelected: _currentPageIndex == 5,
                        onTap: () => _sideMenuController.changePage(5),
                      ),
                      _NavigationItem(
                        icon: Icons.person,
                        title: 'Perfil',
                        isSelected: _currentPageIndex == 6,
                        onTap: () {
                          _sideMenuController.changePage(6);
                          _refreshUserData();
                        },
                      ),
                    ],
                  ),
                ),

                // Sección de reputación y perfil
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Línea divisoria
                      Container(
                        height: 1,
                        color: const Color(0xFF6C4DFF),
                        margin: const EdgeInsets.only(bottom: 16),
                      ),

                      // Reputación
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFF6C4DFF)),
                          const SizedBox(width: 8),
                          const Text(
                            'Reputación',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6C4DFF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (_currentUser?.reputationPoints ?? 0) / 100.0,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6C4DFF),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Perfil del usuario principal
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.green.shade100,
                            child: _buildProfileImage(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _currentUser?.name ?? 'Usuario',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Contenido principal
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const HomePage(),
                const SubjectsPage(),
                const GroupsPage(),
                const FilesPage(),
                const AIMentorPage(),
                const SettingsPage(),
                const ProfilePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    print('🔍 Debug MainMenu: _currentUser = ${_currentUser?.name}');
    print(
      '🔍 Debug MainMenu: profileImageUrl = ${_currentUser?.profileImageUrl}',
    );

    if (_currentUser?.profileImageUrl != null &&
        _currentUser!.profileImageUrl!.isNotEmpty) {
      print(
        '✅ MainMenu: Intentando cargar imagen desde: ${_currentUser!.profileImageUrl}',
      );
      return ClipOval(
        child: Image.network(
          _currentUser!.profileImageUrl!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('❌ MainMenu: Error cargando imagen: $error');
            return const Icon(Icons.person, color: Colors.green, size: 20);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              print('✅ MainMenu: Imagen cargada exitosamente');
              return child;
            }
            print(
              '⏳ MainMenu: Cargando imagen: ${(loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1) * 100).toStringAsFixed(1)}%',
            );
            return const CircularProgressIndicator(strokeWidth: 2);
          },
        ),
      );
    } else {
      print(
        '⚠️ MainMenu: No hay URL de imagen disponible, mostrando ícono por defecto',
      );
      return const Icon(Icons.person, color: Colors.green, size: 20);
    }
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isSelected ? Colors.grey.shade100 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color:
                      isSelected
                          ? const Color(0xFF6C4DFF)
                          : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color:
                        isSelected
                            ? const Color(0xFF6C4DFF)
                            : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
