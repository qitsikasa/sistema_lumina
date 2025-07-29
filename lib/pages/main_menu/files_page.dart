import 'package:flutter/material.dart';
import '../../services/file_service.dart';
import '../../services/user_service.dart';
import '../../models/file_model.dart';
import '../../models/user_model.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  List<FileModel> _files = [];
  List<FileModel> _filteredFiles = [];
  String _searchQuery = '';
  String _selectedFileType = 'Todos';
  bool _isLoading = true;
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
      // Cargar usuario actual y archivos en paralelo
      final results = await Future.wait([
        UserService.getUser(),
        FileService.getFiles(),
      ]);

      setState(() {
        _currentUser = results[0] as UserModel?;
        _files = results[1] as List<FileModel>;
        _filteredFiles = _files;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando datos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFiles() async {
    try {
      final files = await FileService.getFiles();
      setState(() {
        _files = files;
        _filteredFiles = files;
      });
    } catch (e) {
      print('Error cargando archivos: $e');
    }
  }

  void _filterFiles() {
    setState(() {
      _filteredFiles =
          _files.where((file) {
            final matchesSearch =
                _searchQuery.isEmpty ||
                file.nombreOriginal.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                (file.materia?.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ??
                    false);

            final matchesType =
                _selectedFileType == 'Todos' || file.tipo == _selectedFileType;

            return matchesSearch && matchesType;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Column(
        children: [
          // Header con saludo y avatar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              children: [
                // Fila superior con saludo e íconos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    Text(
                      '¡Hola, ${_currentUser?.name ?? 'Usuario'}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_outlined),
                          iconSize: 24,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.account_circle_outlined),
                          iconSize: 24,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Avatar central
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.yellow.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'assets/images/EmuOtori.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contenido principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con título y botón
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mis Archivos',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showUploadDialog(context),
                        icon: const Icon(Icons.upload_outlined, size: 20),
                        label: const Text('Subir Archivo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Barra de búsqueda
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Buscar archivos...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                              _filterFiles();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filtros
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'Todos',
                          isSelected: _selectedFileType == 'Todos',
                          onSelected: (value) {
                            setState(() {
                              _selectedFileType = 'Todos';
                            });
                            _filterFiles();
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Documentos',
                          isSelected: _selectedFileType == 'Documentos',
                          onSelected: (value) {
                            setState(() {
                              _selectedFileType = 'Documentos';
                            });
                            _filterFiles();
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Imágenes',
                          isSelected: _selectedFileType == 'Imágenes',
                          onSelected: (value) {
                            setState(() {
                              _selectedFileType = 'Imágenes';
                            });
                            _filterFiles();
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Presentaciones',
                          isSelected: _selectedFileType == 'Presentaciones',
                          onSelected: (value) {
                            setState(() {
                              _selectedFileType = 'Presentaciones';
                            });
                            _filterFiles();
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Otros',
                          isSelected: _selectedFileType == 'Otros',
                          onSelected: (value) {
                            setState(() {
                              _selectedFileType = 'Otros';
                            });
                            _filterFiles();
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Ordenar por',
                          isSelected: false,
                          onSelected: (value) {
                            // Implementar ordenamiento
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tabla de archivos
                  Expanded(
                    child:
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  // Headers de la tabla
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          flex: 3,
                                          child: Text(
                                            'NOMBRE',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            'TIPO',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            'TAMAÑO',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 2,
                                          child: Text(
                                            'ÚLTIMA MODIFICACIÓN',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 40,
                                        ), // Espacio para menú
                                      ],
                                    ),
                                  ),
                                  // Filas de archivos
                                  Expanded(
                                    child:
                                        _filteredFiles.isEmpty
                                            ? const Center(
                                              child: Text(
                                                'No se encontraron archivos',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            )
                                            : ListView.builder(
                                              itemCount: _filteredFiles.length,
                                              itemBuilder: (context, index) {
                                                final file =
                                                    _filteredFiles[index];
                                                return _FileRow(
                                                  file: file,
                                                  onDelete:
                                                      () =>
                                                          _deleteFile(file.id),
                                                  onDownload:
                                                      () => _downloadFile(
                                                        file.id,
                                                      ),
                                                );
                                              },
                                            ),
                                  ),
                                ],
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUploadDialog(BuildContext context) {
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Subir Archivo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Selecciona un archivo de tu dispositivo para subirlo.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                    hintText: 'Describe el contenido del archivo',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
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
                          Text('Seleccionando archivo...'),
                        ],
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Subir archivo
                  final newFile = await FileService.uploadFile(
                    description: descriptionController.text.trim(),
                  );

                  // Ocultar loading
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  if (newFile != null) {
                    // Recargar archivos
                    await _loadFiles();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '¡Archivo "${newFile.nombreOriginal}" subido exitosamente!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No se seleccionó ningún archivo o hubo un error.',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                child: const Text('Seleccionar Archivo'),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteFile(String fileId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar archivo'),
            content: const Text(
              '¿Estás seguro de que quieres eliminar este archivo?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final success = await FileService.deleteFile(fileId);
      if (success) {
        await _loadFiles();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Archivo eliminado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al eliminar el archivo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _downloadFile(String fileId) async {
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
            Text('Descargando archivo...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );

    final success = await FileService.downloadFile(fileId);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Archivo descargado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al descargar el archivo'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _FileRow extends StatelessWidget {
  final FileModel file;
  final VoidCallback onDelete;
  final VoidCallback onDownload;

  const _FileRow({
    required this.file,
    required this.onDelete,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final fileTypeInfo = FileService.getFileTypeInfo(file.tipo);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          // Ícono del archivo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: fileTypeInfo['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              fileTypeInfo['icon'],
              color: fileTypeInfo['color'],
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          // Nombre del archivo
          Expanded(
            flex: 3,
            child: Text(
              file.nombreOriginal,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Tipo
          Expanded(
            flex: 1,
            child: Text(
              file.tipo,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          // Tamaño
          Expanded(
            flex: 1,
            child: Text(
              FileService.formatFileSize(file.tamano),
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          // Fecha
          Expanded(
            flex: 2,
            child: Text(
              _formatDate(file.createdAt),
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          // Menú de opciones
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz, color: Colors.grey.shade600, size: 20),
            onSelected: (value) {
              if (value == 'download') {
                onDownload();
              } else if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'download',
                    child: Row(
                      children: [
                        Icon(Icons.download, size: 16),
                        SizedBox(width: 8),
                        Text('Descargar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} días atrás';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'semana' : 'semanas'} atrás';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'mes' : 'meses'} atrás';
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
        ),
      ),
      child: InkWell(
        onTap: () => onSelected(!isSelected),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
