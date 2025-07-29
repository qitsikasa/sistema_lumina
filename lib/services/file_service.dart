import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_client.dart';
import '../models/file_model.dart';

class FileService {
  static final SupabaseClient _supabase = supabase;
  static const String _bucketName = 'archivos-estudiantes';

  // Obtener todos los archivos
  static Future<List<FileModel>> getFiles({
    String? searchQuery,
    String? fileType,
    String? materiaId,
    String? grupoId,
  }) async {
    try {
      // Intentar obtener de Supabase con consulta simple
      var query = _supabase
          .from('archivos')
          .select('*')
          .order('created_at', ascending: false);

      final response = await query;

      return (response as List)
          .map((json) => FileModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error obteniendo archivos de Supabase: $e');
      // Fallback a datos de ejemplo
      return getExampleFiles();
    }
  }

  // Subir archivo real usando image_picker_web
  static Future<FileModel?> uploadFile({
    String? materiaId,
    String? grupoId,
    String? description,
  }) async {
    try {
      // Seleccionar archivo usando image_picker_web
      final MediaInfo? mediaInfo = await ImagePickerWeb.getImageInfo();

      if (mediaInfo == null) {
        return null;
      }

      final user = _supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Generar nombre único para el archivo
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = _getExtensionFromMimeType(mediaInfo.fileName);
      final fileName = '${user.id}_$timestamp.$extension';
      final filePath = '${user.id}/$fileName';

      // Convertir Uint8List a bytes para subir
      final bytes = mediaInfo.data!;

      // Subir archivo a Supabase Storage
      await _supabase.storage.from(_bucketName).uploadBinary(filePath, bytes);

      // Obtener URL pública
      final url = _supabase.storage.from(_bucketName).getPublicUrl(filePath);

      // Guardar información en la base de datos
      final fileData = {
        'nombre': fileName,
        'nombre_original':
            mediaInfo.fileName ?? 'archivo_$timestamp.$extension',
        'tipo': _getFileType(extension),
        'tamano': bytes.length,
        'url_storage': url,
        'usuario_id': user.id,
        'descripcion': description,
      };

      if (materiaId != null) {
        fileData['materia_id'] = materiaId;
      }

      if (grupoId != null) {
        fileData['grupo_id'] = grupoId;
      }

      final dbResponse =
          await _supabase
              .from('archivos')
              .insert(fileData)
              .select('*')
              .single();

      return FileModel.fromJson(dbResponse);
    } catch (e) {
      print('Error subiendo archivo: $e');
      return null;
    }
  }

  // Descargar archivo real
  static Future<bool> downloadFile(String fileId) async {
    try {
      // Obtener información del archivo
      final fileResponse =
          await _supabase
              .from('archivos')
              .select('nombre, url_storage, usuario_id')
              .eq('id', fileId)
              .single();

      final url = fileResponse['url_storage'];
      final fileName = fileResponse['nombre']; // Nombre del archivo
      final userId = fileResponse['usuario_id']; // ID del usuario

      // Construir la ruta completa: usuario_id/nombre_archivo
      final filePath = '$userId/$fileName';

      print('🔗 URL del archivo: $url');
      print('📁 Nombre del archivo: $fileName');
      print('👤 ID del usuario: $userId');
      print('🛤️ Ruta completa en Storage: $filePath');

      // Para Flutter Web, usar la URL pública directamente
      if (url.isNotEmpty) {
        print('🌐 Abriendo archivo en nueva pestaña: $url');

        // Abrir la URL en una nueva pestaña para descargar el archivo
        html.window.open(url, '_blank');

        return true;
      } else {
        print('❌ No hay URL pública disponible');
        return false;
      }
    } catch (e) {
      print('❌ Error descargando archivo: $e');
      return false;
    }
  }

  // Eliminar archivo real
  static Future<bool> deleteFile(String fileId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Obtener información del archivo
      final fileResponse =
          await _supabase
              .from('archivos')
              .select('nombre, usuario_id')
              .eq('id', fileId)
              .single();

      // Verificar que el usuario es el propietario
      if (fileResponse['usuario_id'] != user.id) {
        throw Exception('No tienes permisos para eliminar este archivo');
      }

      // Eliminar de la base de datos
      await _supabase.from('archivos').delete().eq('id', fileId);

      // Eliminar de Storage usando la ruta completa
      final fileName = fileResponse['nombre'];
      final userId = fileResponse['usuario_id'];
      final filePath = '$userId/$fileName';

      print('🗑️ Eliminando archivo de Storage: $filePath');
      await _supabase.storage.from(_bucketName).remove([filePath]);

      return true;
    } catch (e) {
      print('❌ Error eliminando archivo: $e');
      return false;
    }
  }

  // Obtener tipos de archivo disponibles
  static List<String> getFileTypes() {
    return [
      'Todos',
      'PDF',
      'DOC',
      'DOCX',
      'XLS',
      'XLSX',
      'PPT',
      'PPTX',
      'JPG',
      'PNG',
      'GIF',
      'ZIP',
      'RAR',
      'TXT',
    ];
  }

  // Obtener icono y color según tipo de archivo
  static Map<String, dynamic> getFileTypeInfo(String type) {
    switch (type.toUpperCase()) {
      case 'PDF':
        return {
          'icon': Icons.picture_as_pdf,
          'color': Colors.red,
          'label': 'PDF',
        };
      case 'DOC':
      case 'DOCX':
        return {
          'icon': Icons.description,
          'color': Colors.blue,
          'label': 'Documento',
        };
      case 'XLS':
      case 'XLSX':
        return {
          'icon': Icons.table_chart,
          'color': Colors.green,
          'label': 'Hoja de calculo',
        };
      case 'PPT':
      case 'PPTX':
        return {
          'icon': Icons.slideshow,
          'color': Colors.orange,
          'label': 'Presentacion',
        };
      case 'JPG':
      case 'PNG':
      case 'GIF':
        return {'icon': Icons.image, 'color': Colors.purple, 'label': 'Imagen'};
      case 'ZIP':
      case 'RAR':
        return {
          'icon': Icons.archive,
          'color': Colors.brown,
          'label': 'Comprimido',
        };
      case 'TXT':
        return {
          'icon': Icons.text_snippet,
          'color': Colors.grey,
          'label': 'Texto',
        };
      default:
        return {
          'icon': Icons.insert_drive_file,
          'color': Colors.grey,
          'label': 'Archivo',
        };
    }
  }

  // Convertir extensión a tipo de archivo
  static String _getFileType(String extension) {
    return extension.toUpperCase();
  }

  // Obtener extensión desde nombre del archivo
  static String _getExtensionFromMimeType(String? fileName) {
    if (fileName == null) return 'bin';

    final parts = fileName.split('.');
    if (parts.length < 2) return 'bin';

    final extension = parts.last.toLowerCase();

    // Mapear extensiones comunes
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'jpg';
      case 'png':
        return 'png';
      case 'gif':
        return 'gif';
      case 'webp':
        return 'webp';
      case 'pdf':
        return 'pdf';
      case 'doc':
        return 'doc';
      case 'docx':
        return 'docx';
      case 'xls':
        return 'xls';
      case 'xlsx':
        return 'xlsx';
      case 'ppt':
        return 'ppt';
      case 'pptx':
        return 'pptx';
      case 'txt':
        return 'txt';
      case 'zip':
        return 'zip';
      case 'rar':
        return 'rar';
      default:
        return extension;
    }
  }

  // Formatear tamaño de archivo
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  // Obtener archivos de ejemplo para fallback
  static List<FileModel> getExampleFiles() {
    return [
      FileModel(
        id: '1',
        nombre: 'Apuntes de Algebra Lineal.pdf',
        nombreOriginal: 'Apuntes de Algebra Lineal.pdf',
        tipo: 'PDF',
        tamano: 2500000,
        urlStorage: '',
        usuarioId: '1',
        usuario: 'Sofia Garcia',
        materiaId: '1',
        materia: 'Matematicas',
        grupoId: null,
        grupo: null,
        descripcion: 'Apuntes completos de algebra lineal',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      FileModel(
        id: '2',
        nombre: 'Diagrama de Flujo Proyecto.png',
        nombreOriginal: 'Diagrama de Flujo Proyecto.png',
        tipo: 'PNG',
        tamano: 800000,
        urlStorage: '',
        usuarioId: '2',
        usuario: 'Carlos Lopez',
        materiaId: '2',
        materia: 'Programacion',
        grupoId: null,
        grupo: null,
        descripcion: 'Diagrama de flujo del proyecto final',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      FileModel(
        id: '3',
        nombre: 'Presupuesto Semestral.xlsx',
        nombreOriginal: 'Presupuesto Semestral.xlsx',
        tipo: 'XLSX',
        tamano: 1200000,
        urlStorage: '',
        usuarioId: '3',
        usuario: 'Ana Martinez',
        materiaId: '3',
        materia: 'Administracion',
        grupoId: null,
        grupo: null,
        descripcion: 'Presupuesto detallado del semestre',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      FileModel(
        id: '4',
        nombre: 'Recursos de Programacion.zip',
        nombreOriginal: 'Recursos de Programacion.zip',
        tipo: 'ZIP',
        tamano: 15000000,
        urlStorage: '',
        usuarioId: '4',
        usuario: 'Luis Rodriguez',
        materiaId: '2',
        materia: 'Programacion',
        grupoId: null,
        grupo: null,
        descripcion: 'Recursos y codigos de programacion',
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
        updatedAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
    ];
  }
}
