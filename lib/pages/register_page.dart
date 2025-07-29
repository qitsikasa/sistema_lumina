import 'package:flutter/material.dart';
import '../controllers/register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final RegisterController registerController = RegisterController();

  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.6,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Regístrate',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'roboto',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Image.asset('images/EmuOtori.webp', height: 120),
                  const SizedBox(height: 12),
                  Text(
                    'Descubre la magia de colaborar y eleva tu aprendizaje',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'roboto',
                      color: Color.fromARGB(255, 154, 154, 154),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nombre completo',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu nombre',
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Correo institucional',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: correoController,
                    decoration: InputDecoration(
                      hintText: 'codsis@est.umss.edu',
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Contraseña',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Crea una contraseña',
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Confirmar contraseña',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Repite tu contraseña',
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (error != null)
                    Text(error!, style: const TextStyle(color: Colors.red)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 140,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4DFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          final correo = correoController.text.trim();
                          final correoValido = RegExp(
                            r'^\d{9}@est\.umss\.edu$',
                          ).hasMatch(correo);

                          if (!correoValido) {
                            setState(() {
                              error =
                                  'El correo no está escrito correctamente, el formato es xxxxxxxxx@est.umss.edu';
                            });
                            return;
                          }

                          // Validar el año
                          final anio = int.tryParse(correo.substring(0, 4));
                          final anioActual = DateTime.now().year;
                          if (anio == null ||
                              anio < (anioActual - 50) ||
                              anio > anioActual) {
                            setState(() {
                              error =
                                  'El año del correo debe estar entre ${anioActual - 50} y $anioActual';
                            });
                            return;
                          }

                          // Validar longitud de contraseña
                          if (passwordController.text.length < 6) {
                            setState(() {
                              error =
                                  'La contraseña debe tener al menos 6 caracteres';
                            });
                            return;
                          }

                          if (passwordController.text !=
                              confirmController.text) {
                            setState(() {
                              error = 'Las contraseñas no coinciden';
                            });
                            return;
                          }

                          final result = await registerController.registerUser(
                            nombre: nombreController.text,
                            correo: correo,
                            password: passwordController.text,
                          );
                          setState(() {
                            error = result;
                          });
                          if (result == null) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
