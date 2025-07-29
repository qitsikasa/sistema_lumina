import '../supabase_client.dart';

class RegisterController {
  Future<String?> registerUser({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: correo,
        password: password,
      );
      final user = response.user;
      if (user != null) {
        await supabase.from('usuarios').insert({
          'id': user.id,
          'display_name': nombre,
        });
        return null; // Sin error
      } else {
        return 'No se pudo crear el usuario';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
