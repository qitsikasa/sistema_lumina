import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker_web/image_picker_web.dart';

class StorageService {
  static const String _bucketName = 'profile-images';

  // Subir imagen de perfil
  static Future<String?> uploadProfileImage(
    MediaInfo image,
    String userId,
  ) async {
    try {
      print('🔄 Iniciando subida de imagen para usuario: $userId');

      // Crear nombre único para la imagen
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '$userId/$fileName';

      print('📁 Ruta del archivo: $filePath');

      // Leer la imagen como bytes
      final bytes = image.data!;
      print('📊 Tamaño de la imagen: ${bytes.length} bytes');

      // Subir a Supabase Storage
      print('☁️ Subiendo a Supabase Storage...');
      await Supabase.instance.client.storage
          .from(_bucketName)
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      print('✅ Imagen subida exitosamente');

      // Obtener URL pública
      final imageUrl = Supabase.instance.client.storage
          .from(_bucketName)
          .getPublicUrl(filePath);

      print('🔗 URL pública generada: $imageUrl');

      return imageUrl;
    } catch (e) {
      print('❌ Error subiendo imagen: $e');
      print('🔍 Detalles del error: ${e.toString()}');
      return null;
    }
  }

  // Eliminar imagen de perfil anterior
  static Future<void> deleteProfileImage(String? imageUrl) async {
    if (imageUrl == null) return;

    try {
      // Extraer el path del archivo de la URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      if (pathSegments.length >= 3) {
        final filePath =
            '${pathSegments[pathSegments.length - 2]}/${pathSegments.last}';

        await Supabase.instance.client.storage.from(_bucketName).remove([
          filePath,
        ]);
      }
    } catch (e) {
      print('Error eliminando imagen anterior: $e');
    }
  }

  // Obtener URL de imagen de perfil
  static String getProfileImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return ''; // Retornar URL por defecto o null
    }
    return imageUrl;
  }

  // Verificar si una imagen existe
  static Future<bool> imageExists(String imageUrl) async {
    if (imageUrl.isEmpty) return false;

    try {
      final response =
          await Supabase.instance.client.storage.from(_bucketName).list();

      // Verificar si la imagen existe en la lista
      return response.any((file) => file.name.contains(imageUrl));
    } catch (e) {
      print('Error verificando imagen: $e');
      return false;
    }
  }

  // Verificar conexión con Supabase Storage
  static Future<bool> checkStorageConnection() async {
    try {
      print('🔍 Verificando conexión con Supabase Storage...');

      // Intentar listar archivos del bucket
      final response =
          await Supabase.instance.client.storage.from(_bucketName).list();

      print('✅ Conexión exitosa con bucket: $_bucketName');
      print('📁 Archivos en bucket: ${response.length}');
      return true;
    } catch (e) {
      print('❌ Error conectando con Supabase Storage: $e');
      return false;
    }
  }

  // Comprimir imagen antes de subir (específico para web)
  static Future<MediaInfo> compressImage(MediaInfo image) async {
    // En web, el ImagePicker ya maneja la compresión automáticamente
    // pero aquí podrías agregar lógica adicional si es necesario
    return image;
  }
}
