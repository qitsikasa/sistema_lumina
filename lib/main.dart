import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/mainmenu_page.dart';
import 'pages/welcome_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'services/user_service.dart';
import 'secrets.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    print('🚀 Inicializando Supabase...');
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    print('✅ Supabase inicializado correctamente');
    runApp(const MyApp());
  } catch (e) {
    print('❌ Error inicializando Supabase: $e');
    print('⚠️ Continuando sin Supabase...');
    // Aún ejecutar la app para mostrar error
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/homepage': (context) => const MainMenuPage(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      print('🔍 Verificando estado de autenticación...');

      // Agregar timeout de 10 segundos
      final isLoggedIn = await UserService.isLoggedIn().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('⏰ Timeout en verificación de autenticación');
          return false;
        },
      );

      print(
        '✅ Estado de autenticación: ${isLoggedIn ? 'Logueado' : 'No logueado'}',
      );
      setState(() {
        _isLoggedIn = isLoggedIn;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error verificando autenticación: $e');
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Cargando...'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoading = false;
                    _isLoggedIn = false;
                  });
                },
                child: const Text('Saltar carga'),
              ),
            ],
          ),
        ),
      );
    }

    return _isLoggedIn ? const MainMenuPage() : const WelcomePage();
  }
}
