import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.6, // 3/5 = 0.6
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'images/EmuOtori.webp', // Asegúrate de tener esta imagen en tu carpeta assets
                  height: 200,
                ), // Asegúrate de tener un logo en assets
                const SizedBox(height: 20),
                Text(
                  '¡Bienvenido a Lumina!',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'roboto',
                    color: const Color.fromARGB(255, 255, 242, 123),
                  ),
                ),
                Text(
                  'Conectate con compañeros, forma grupos y colabora.',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'roboto',
                    color: const Color.fromARGB(255, 154, 154, 154),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(119, 223, 230, 255),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.login,
                                    size: 48,
                                    color: Colors.deepPurple,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Iniciar sesión',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Accede para conectar y aprender.',
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 154, 154, 154),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        127,
                                        78,
                                        240,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: const Text(
                                      'Entrar',
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 300, // Igual que el anterior
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(110, 223, 230, 255),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.emoji_emotions,
                                    size: 48,
                                    color: Colors.yellow.shade700,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Registro',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Comienza tu viaje de estudio.',
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        127,
                                        78,
                                        240,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/register');
                                    },
                                    child: const Text(
                                      'Registrarse',
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
