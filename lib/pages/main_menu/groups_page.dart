import 'package:flutter/material.dart';
import '../../models/group_model.dart';
import '../../services/group_service.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../../supabase_client.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<GroupModel> _groups = [];
  List<GroupModel> _filteredGroups = [];
  String _searchQuery = '';
  String _selectedMateria = 'Todas';
  String _selectedSemestre = 'Todos';
  String _selectedTipo = 'Todos';
  bool _isLoading = true;
  // ignore: unused_field
  UserModel? _currentUser;

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
      final futures = await Future.wait([
        GroupService.getGroups(),
        UserService.getUser(),
      ]);

      setState(() {
        _groups = futures[0] as List<GroupModel>;
        _filteredGroups = _groups;
        _currentUser = futures[1] as UserModel?;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando grupos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterGroups() {
    setState(() {
      _filteredGroups =
          _groups.where((group) {
            final matchesSearch =
                group.nombre.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                (group.descripcion?.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ??
                    false) ||
                (group.materia?.nombre.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ??
                    false);

            final matchesMateria =
                _selectedMateria == 'Todas' ||
                group.materia?.nombre == _selectedMateria;

            final matchesSemestre =
                _selectedSemestre == 'Todos' ||
                group.semestre == _selectedSemestre;

            final matchesTipo =
                _selectedTipo == 'Todos' || group.tipo == _selectedTipo;

            return matchesSearch &&
                matchesMateria &&
                matchesSemestre &&
                matchesTipo;
          }).toList();
    });
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
            // Navegación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Inicio > Grupos',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCreateGroupDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Grupo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4DFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

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
                        hintText:
                            'Buscar grupos por nombre, materia o interés...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                        _filterGroups();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Filtros
            Row(
              children: [
                _FilterButton(
                  title: 'Materia',
                  icon: Icons.arrow_drop_down,
                  onTap: () => _showMateriaFilter(),
                ),
                const SizedBox(width: 12),
                _FilterButton(
                  title: 'Semestre',
                  icon: Icons.arrow_drop_down,
                  onTap: () => _showSemestreFilter(),
                ),
                const SizedBox(width: 12),
                _FilterButton(
                  title: 'Tipo de grupo',
                  icon: Icons.arrow_drop_down,
                  onTap: () => _showTipoFilter(),
                ),
                const SizedBox(width: 12),
                _FilterButton(
                  title: 'Más Filtros',
                  icon: Icons.filter_list,
                  onTap: () => _showMoreFilters(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Grid de grupos
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.1,
              ),
              itemCount: _filteredGroups.length,
              itemBuilder: (context, index) {
                final group = _filteredGroups[index];
                return _GroupCard(group: group);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMateriaFilter() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filtrar por Materia'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  [
                        'Todas',
                        'Matemáticas',
                        'Física',
                        'Química',
                        'Programación',
                        'Historia',
                        'Sociología',
                        'Biología',
                      ]
                      .map(
                        (materia) => ListTile(
                          title: Text(materia),
                          onTap: () {
                            setState(() {
                              _selectedMateria = materia;
                            });
                            _filterGroups();
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
    );
  }

  void _showSemestreFilter() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filtrar por Semestre'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  [
                        'Todos',
                        '1er Semestre',
                        '2do Semestre',
                        '3er Semestre',
                        '4to Semestre',
                        '5to Semestre',
                        '6to Semestre',
                      ]
                      .map(
                        (semestre) => ListTile(
                          title: Text(semestre),
                          onTap: () {
                            setState(() {
                              _selectedSemestre = semestre;
                            });
                            _filterGroups();
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
    );
  }

  void _showTipoFilter() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filtrar por Tipo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  [
                        'Todos',
                        'Estudio',
                        'Investigación',
                        'Debate',
                        'Laboratorio',
                        'Proyecto',
                      ]
                      .map(
                        (tipo) => ListTile(
                          title: Text(tipo),
                          onTap: () {
                            setState(() {
                              _selectedTipo = tipo;
                            });
                            _filterGroups();
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
    );
  }

  void _showMoreFilters() {
    // Implementar filtros adicionales
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filtros adicionales próximamente')),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    String selectedMateria = 'Matemáticas';
    String selectedSemestre = '1er Semestre';
    String selectedTipo = 'Estudio';
    String selectedCarrera = 'Ingeniería Informática';
    String selectedFacultad = 'Facultad de Ciencias y Tecnología';

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: const Text('Crear Nuevo Grupo'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nombreController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del Grupo',
                            hintText: 'Ej: Grupo de Matemáticas Avanzadas',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: descripcionController,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                            hintText: 'Describa el propósito del grupo',
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Materia',
                          ),
                          value: selectedMateria,
                          items:
                              [
                                    'Matemáticas',
                                    'Física',
                                    'Química',
                                    'Programación',
                                    'Historia',
                                    'Sociología',
                                    'Biología',
                                  ]
                                  .map(
                                    (materia) => DropdownMenuItem(
                                      value: materia,
                                      child: Text(materia),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedMateria = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Semestre',
                          ),
                          value: selectedSemestre,
                          items:
                              [
                                    '1er Semestre',
                                    '2do Semestre',
                                    '3er Semestre',
                                    '4to Semestre',
                                    '5to Semestre',
                                    '6to Semestre',
                                  ]
                                  .map(
                                    (semestre) => DropdownMenuItem(
                                      value: semestre,
                                      child: Text(semestre),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedSemestre = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Grupo',
                          ),
                          value: selectedTipo,
                          items:
                              [
                                    'Estudio',
                                    'Investigación',
                                    'Debate',
                                    'Laboratorio',
                                    'Proyecto',
                                  ]
                                  .map(
                                    (tipo) => DropdownMenuItem(
                                      value: tipo,
                                      child: Text(tipo),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedTipo = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Carrera',
                          ),
                          value: selectedCarrera,
                          items:
                              [
                                    'Ingeniería Informática',
                                    'Ingeniería Química',
                                    'Ingeniería Industrial',
                                    'Filosofía',
                                    'Historia',
                                    'Sociología',
                                    'Biología',
                                  ]
                                  .map(
                                    (carrera) => DropdownMenuItem(
                                      value: carrera,
                                      child: Text(carrera),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedCarrera = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Facultad',
                          ),
                          value: selectedFacultad,
                          items:
                              [
                                    'Facultad de Ciencias y Tecnología',
                                    'Facultad de Humanidades',
                                    'Facultad de Ciencias Económicas',
                                    'Facultad de Medicina',
                                  ]
                                  .map(
                                    (facultad) => DropdownMenuItem(
                                      value: facultad,
                                      child: Text(facultad),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedFacultad = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (nombreController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('El nombre del grupo es requerido'),
                            ),
                          );
                          return;
                        }

                        Navigator.pop(context);

                        // Mostrar loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Text('Creando grupo...'),
                              ],
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        // Crear el grupo con timeout más corto
                        GroupModel? nuevoGrupo;
                        try {
                          nuevoGrupo = await GroupService.createGroup(
                            nombre: nombreController.text.trim(),
                            descripcion: descripcionController.text.trim(),
                            tipo: selectedTipo,
                            semestre: selectedSemestre,
                            carrera: selectedCarrera,
                            facultad: selectedFacultad,
                          ).timeout(
                            const Duration(seconds: 5),
                            onTimeout: () {
                              throw Exception(
                                'Timeout: La operación tardó demasiado',
                              );
                            },
                          );
                        } catch (e) {
                          print('Error creando grupo: $e');
                          nuevoGrupo = null;
                        }

                        // Ocultar loading
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        if (nuevoGrupo != null) {
                          // Recargar datos
                          try {
                            await _loadData();
                          } catch (e) {
                            print('Error recargando datos: $e');
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '¡Grupo "${nuevoGrupo.nombre}" creado exitosamente!',
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Error al crear el grupo. Verifica tu conexión e inténtalo de nuevo.',
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 4),
                            ),
                          );
                        }
                      },
                      child: const Text('Crear Grupo'),
                    ),
                  ],
                ),
          ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF6C4DFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(icon, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final GroupModel group;

  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono y título
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getGroupColor(group.tipo).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getGroupIcon(group.tipo),
                    color: _getGroupColor(group.tipo),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        group.materia?.nombre ?? "General",
                        style: TextStyle(
                          fontSize: 14,
                          color: _getGroupColor(group.tipo),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Descripción
            Text(
              group.descripcion ?? 'Sin descripción disponible',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Estadísticas en chips
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people, size: 14, color: Colors.blue.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${group.miembrosCount}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.folder,
                        size: 14,
                        color: Colors.green.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${group.archivosCount}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _joinGroup(context, group),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4DFF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Unirse',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () => _viewGroupDetails(context, group),
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    tooltip: 'Ver detalles',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getGroupIcon(String? tipo) {
    switch (tipo?.toLowerCase()) {
      case 'programación':
      case 'codificación':
        return Icons.code;
      case 'laboratorio':
      case 'química':
        return Icons.science;
      case 'matemáticas':
      case 'ecuaciones':
        return Icons.functions;
      case 'historia':
      case 'sociología':
        return Icons.public;
      case 'biología':
      case 'investigación':
        return Icons.biotech;
      case 'debate':
      case 'discusión':
        return Icons.chat_bubble;
      default:
        return Icons.group;
    }
  }

  Color _getGroupColor(String? tipo) {
    switch (tipo?.toLowerCase()) {
      case 'programación':
      case 'codificación':
        return Colors.blue;
      case 'laboratorio':
      case 'química':
        return Colors.green;
      case 'matemáticas':
      case 'ecuaciones':
        return Colors.orange;
      case 'historia':
      case 'sociología':
        return Colors.purple;
      case 'biología':
      case 'investigación':
        return Colors.teal;
      case 'debate':
      case 'discusión':
        return Colors.red;
      default:
        return const Color(0xFF6C4DFF);
    }
  }

  void _joinGroup(BuildContext context, GroupModel group) {
    final TextEditingController codigoController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Unirse a ${group.nombre}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ingresa el código de invitación para unirte al grupo:',
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: codigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código de Invitación',
                    hintText: 'Ej: ABC12345',
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 16),
                if (group.codigoInvitacion != null) ...[
                  const Text('Código del grupo:'),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      group.codigoInvitacion!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final codigo = codigoController.text.trim().toUpperCase();
                  if (codigo.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ingresa un código de invitación'),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);

                  // Mostrar loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 16),
                          Text('Uniéndose al grupo...'),
                        ],
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Unirse al grupo
                  final success = await GroupService.joinGroupByCode(codigo);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '¡Te has unido exitosamente a ${group.nombre}!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Error al unirse al grupo. Verifica el código.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Unirse'),
              ),
            ],
          ),
    );
  }

  void _viewGroupDetails(BuildContext context, GroupModel group) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _GroupDetailsPage(group: group)),
    );
  }
}

class _GroupDetailsPage extends StatelessWidget {
  final GroupModel group;

  const _GroupDetailsPage({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.nombre),
        backgroundColor: const Color(0xFF6C4DFF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del grupo
            Center(
              child: Image.asset(
                'assets/images/EmuOtori.webp',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),

            // Información del grupo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.nombre,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      group.descripcion ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.people, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text('${group.miembrosCount} miembros'),
                        const SizedBox(width: 16),
                        Icon(Icons.folder, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text('${group.archivosCount} archivos'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Código de invitación
            if (group.codigoInvitacion != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Código de Invitación',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                group.codigoInvitacion!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Copiar código al portapapeles
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Código copiado'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Abrir chat del grupo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _GroupChatPage(group: group),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Abrir Chat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4DFF),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Ver archivos del grupo
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Archivos del grupo próximamente'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.folder),
                    label: const Text('Ver Archivos'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6C4DFF),
                      side: const BorderSide(color: Color(0xFF6C4DFF)),
                    ),
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

class _GroupChatPage extends StatefulWidget {
  final GroupModel group;

  const _GroupChatPage({required this.group});

  @override
  State<_GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<_GroupChatPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _loadMessages();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() async {
    // Cargar mensajes de ejemplo que coincidan con la imagen
    setState(() {
      _messages.clear();
      _messages.addAll([
        ChatMessage(
          id: '1',
          text:
              '¿Alguien tiene dificultades con la integración numérica? Encontré un excelente recurso que te podría ayudar con la resolución de este tipo de problemas.',
          senderName: 'Miguel Ochoa',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isCurrentUser: false,
          avatar: 'MO',
        ),
        ChatMessage(
          id: '2',
          text:
              'Hola Miguel! Gracias, realmente estaba teniendo dificultades en el viernes 3 de la tarde con la biblioteca. Apreciaría cualquier ayuda sobre transformadas de Fourier.',
          senderName: 'Laura Ramos',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isCurrentUser: false,
          avatar: 'LR',
        ),
        ChatMessage(
          id: '3',
          text: 'Por cierto de Miguel, ¿Podrías compartir el enlace?',
          senderName: 'Tú',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
          isCurrentUser: true,
          avatar: 'TU',
        ),
        ChatMessage(
          id: '4',
          text:
              '¡Claro! Lo subiré después de que termine de revisar las notas. Te ayudaré en el apartado de documentos.',
          senderName: 'Miguel Ochoa',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
          isCurrentUser: false,
          avatar: 'MO',
        ),
      ]);
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    final localMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: messageText,
      senderName: 'Tú',
      timestamp: DateTime.now(),
      isCurrentUser: true,
      avatar: 'TU',
    );

    setState(() {
      _messages.add(localMessage);
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header con breadcrumb y botones
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                // Breadcrumb y botones superiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Inicio > Grupos > ${widget.group.nombre}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            'Crear Grupo',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Información del grupo
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.calculate,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.group.nombre,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.group.descripcion ??
                                'Un grupo específico para estudiantes de diferentes carreras que quieren aprobar cálculo, y que realizan la resolución de problemas y preparación de exámenes.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Pestañas
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey.shade600,
                    indicatorColor: Colors.blue,
                    indicatorWeight: 2,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(text: 'Chat'),
                      Tab(text: 'Miembros'),
                      Tab(text: 'Archivos'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Contenido de las pestañas
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Pestaña Chat
                _buildChatTab(),
                // Pestaña Miembros
                _buildMembersTab(),
                // Pestaña Archivos
                _buildFilesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        // Título del chat
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: const Text(
            'Chat grupal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        // Lista de mensajes
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return _buildChatMessage(message);
            },
          ),
        ),

        // Campo de entrada de mensaje
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade300,
            child: Text(
              message.avatar,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Contenido del mensaje
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y timestamp
                Row(
                  children: [
                    Text(
                      message.senderName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimestamp(message.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Mensaje
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
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

  Widget _buildMembersTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Miembros del grupo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Lista de miembros
          Row(
            children: [
              _buildMemberAvatar('TU', 'Tú'),
              const SizedBox(width: 16),
              _buildMemberAvatar('MO', 'Miguel Ochoa'),
              const SizedBox(width: 16),
              _buildMemberAvatar('LR', 'Laura Ramos'),
              const SizedBox(width: 16),
              _buildMemberAvatar('AR', 'Ana Rodriguez'),
              const SizedBox(width: 16),
              _buildMemberAvatar('CP', 'Carlos Pérez'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberAvatar(String initials, String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade300,
          child: Text(
            initials,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFilesTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Documentos compartidos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Lista de documentos
          _buildDocumentItem(
            'Cálculo Límites.docx.pdf',
            '2 MB',
            Icons.picture_as_pdf,
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildDocumentItem(
            'Apuntes Cálculo Numérico.pdf',
            '5 MB',
            Icons.picture_as_pdf,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(
    String name,
    String size,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  size,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Descargar', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays >= 1) {
      return 'Ayer';
    } else if (difference.inMinutes >= 1) {
      return 'hace ${difference.inMinutes} minutos';
    } else {
      return 'Ahora';
    }
  }
}

class ChatMessage {
  final String id;
  final String text;
  final String senderName;
  final DateTime timestamp;
  final bool isCurrentUser;
  final String avatar;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderName,
    required this.timestamp,
    required this.isCurrentUser,
    this.avatar = 'U',
  });
}
