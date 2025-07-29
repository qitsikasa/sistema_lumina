import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? error;

  @override
  Widget build(BuildContext context) {
    final colorPrimario = const Color(0xFF6C4DFF);
    final colorFondoInput = const Color(0xFFF7F7F7);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Bienvenido',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ClipOval(
                child: Image.asset(
                  'images/EmuOtori.webp',
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Accede a tu cuenta para conectar y aprender',
                style: TextStyle(fontSize: 15, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Center(
                child: SizedBox(
                  width: 860, // Ajusta el ancho del formulario
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Correo electrónico',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: correoController,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Ingresa tu correo',
                          hintStyle: const TextStyle(fontSize: 13),
                          filled: true,
                          fillColor: colorFondoInput,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Contraseña',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Ingresa tu contraseña',
                          hintStyle: const TextStyle(fontSize: 13),
                          filled: true,
                          fillColor: colorFondoInput,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Mostrar error si existe
                      if (error != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Column(
                            children: [
                              Text(
                                error!,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (error!.contains('no es válida') ||
                                  error!.contains('no está registrada'))
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Column(
                                    children: [
                                      Text(
                                        '¿No tienes cuenta?',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/register',
                                          );
                                        },
                                        child: Text(
                                          'Regístrate aquí',
                                          style: TextStyle(
                                            color: colorPrimario,
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150, // Ajusta el ancho según tu preferencia
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorPrimario,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () async {
                                print('Botón de login presionado');
                                final loginController = LoginController();
                                final error = await loginController.loginUser(
                                  correo: correoController.text.trim(),
                                  password: passwordController.text,
                                );
                                print('Error del login: $error');
                                setState(() {
                                  this.error = error;
                                });
                                if (error == null) {
                                  print('Login exitoso, navegando a /homepage');
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/homepage',
                                  );
                                } else {
                                  print('Login falló con error: $error');
                                }
                              },
                              child: const Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 220, // Mismo ancho que el botón
                            child: TextButton(
                              onPressed: () {
                                // Navegar a recuperación de contraseña
                              },
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: colorPrimario,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Navegar a registro
                          },
                          child: Text(
                            '¿No tienes cuenta? Registrarse',
                            style: TextStyle(
                              color: colorPrimario,
                              fontSize: 13,
                            ),
                          ),
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
    );
  }
}
