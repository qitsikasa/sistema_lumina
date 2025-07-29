import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class UserService {
  static const String _userKey = 'current_user';

  // Guardar usuario en SharedPreferences
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  // Obtener usuario guardado
  static Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo usuario: $e');
      return null;
    }
  }

  // Actualizar datos del usuario
  static Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }

  // Sincronizar datos del usuario con Supabase
  static Future<void> syncUserWithSupabase() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser != null) {
        final userData =
            await Supabase.instance.client
                .from('usuarios')
                .select()
                .eq('id', currentUser.id)
                .single();

        final user = UserModel(
          id: currentUser.id,
          name: userData['display_name'] ?? 'Usuario',
          email: currentUser.email ?? '',
          studentId: userData['student_id'] ?? '',
          career: userData['career'] ?? '',
          faculty: userData['faculty'] ?? '',
          profileImageUrl: userData['profile_image_url'], // Cambiado
          reputationPoints: userData['reputation_points'] ?? 0,
          level: _getLevelFromPoints(userData['reputation_points'] ?? 0),
        );

        await saveUser(user);
      }
    } catch (e) {
      print('Error sincronizando usuario: $e');
    }
  }

  // Actualizar foto de perfil en Supabase
  static Future<void> updateProfileImage(String imageUrl) async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser != null) {
        await Supabase.instance.client
            .from('usuarios')
            .update({'profile_image_url': imageUrl}) // Cambiado
            .eq('id', currentUser.id);
      }
    } catch (e) {
      print('Error actualizando foto de perfil: $e');
    }
  }

  // Subir nueva imagen de perfil
  static Future<String?> uploadNewProfileImage(
    MediaInfo image,
    String userId,
  ) async {
    try {
      print('🚀 Iniciando proceso de subida de imagen de perfil');
      print('👤 Usuario ID: $userId');

      // Subir imagen a Supabase Storage
      final imageUrl = await StorageService.uploadProfileImage(image, userId);

      if (imageUrl != null) {
        print('📝 Actualizando base de datos con nueva URL: $imageUrl');

        // Actualizar en la base de datos
        await Supabase.instance.client
            .from('usuarios')
            .update({'profile_image_url': imageUrl})
            .eq('id', userId);

        print('✅ Base de datos actualizada exitosamente');
        return imageUrl;
      } else {
        print('❌ No se pudo obtener URL de la imagen subida');
        return null;
      }
    } catch (e) {
      print('❌ Error subiendo nueva imagen de perfil: $e');
      print('🔍 Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  // Eliminar usuario (logout)
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Verificar si hay un usuario logueado
  static Future<bool> isLoggedIn() async {
    try {
      final user = await getUser();
      return user != null;
    } catch (e) {
      print('❌ Error en isLoggedIn: $e');
      return false;
    }
  }

  // Crear usuario de ejemplo (para testing)
  static UserModel createDefaultUser() {
    return UserModel(
      id: '1',
      name: 'Usuario',
      email: 'usuario@example.com',
      studentId: '202300123',
      career: 'Ingeniería de Sistemas',
      faculty: 'Facultad de ciencias y tecnología',
      reputationPoints: 1250,
      level: 'Avanzado',
    );
  }

  static String _getLevelFromPoints(int points) {
    if (points >= 2000) return 'Experto';
    if (points >= 1500) return 'Avanzado';
    if (points >= 1000) return 'Intermedio';
    if (points >= 500) return 'Principiante';
    return 'Novato';
  }
}
