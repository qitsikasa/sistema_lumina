import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class LoginController {
  Future<String?> loginUser({
    required String correo,
    required String password,
  }) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: correo,
        password: password,
      );
      if (response.user == null) {
        return 'Correo o contraseña incorrectos';
      }

      // Obtener datos del usuario desde la tabla usuarios
      final userData =
          await Supabase.instance.client
              .from('usuarios')
              .select()
              .eq('id', response.user!.id)
              .single();

      // Crear y guardar usuario con datos reales
      final user = UserModel(
        id: response.user!.id,
        name: userData['display_name'] ?? 'Usuario',
        email: correo,
        studentId: userData['student_id'] ?? '',
        career: userData['career'] ?? '',
        faculty: userData['faculty'] ?? '',
        reputationPoints: userData['reputation_points'] ?? 0,
        level: _getLevelFromPoints(userData['reputation_points'] ?? 0),
      );

      await UserService.saveUser(user);
      return null; // Login exitoso
    } catch (e) {
      String errorMessage = e.toString();

      // Manejar errores específicos de Supabase
      if (errorMessage.contains('Invalid login credentials')) {
        return 'Correo o contraseña incorrectos';
      } else if (errorMessage.contains('email_address_invalid')) {
        return 'La dirección de email no es válida o no está registrada. Verifica que el email esté correcto.';
      } else if (errorMessage.contains('JWT')) {
        return 'Error de autenticación. Intenta nuevamente.';
      }

      return 'Error al iniciar sesión: $errorMessage';
    }
  }

  String _getLevelFromPoints(int points) {
    if (points >= 2000) return 'Experto';
    if (points >= 1500) return 'Avanzado';
    if (points >= 1000) return 'Intermedio';
    if (points >= 500) return 'Principiante';
    return 'Novato';
  }

  Future<String?> resendConfirmationEmail(String email) async {
    try {
      // Primero verificar si el email es válido
      if (!_isValidEmail(email)) {
        return 'La dirección de email no tiene un formato válido.';
      }

      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: email,
      );
      return null; // Email reenviado exitosamente
    } catch (e) {
      String errorMessage = e.toString();

      // Manejar errores específicos del reenvío
      if (errorMessage.contains('email_address_invalid')) {
        return 'La dirección de email no es válida o no está registrada. Verifica que el email esté correcto.';
      } else if (errorMessage.contains('User not found')) {
        return 'No existe una cuenta con esta dirección de email.';
      }

      return 'Error al reenviar el email: $errorMessage';
    }
  }

  bool _isValidEmail(String email) {
    // Validación básica de email
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
