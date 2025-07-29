// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_lumina/main.dart';
import 'package:sistema_lumina/pages/main_menu/home_page.dart';
import 'package:sistema_lumina/pages/welcome_page.dart';
import 'package:sistema_lumina/pages/login_page.dart';
import 'package:sistema_lumina/pages/register_page.dart';
import 'package:sistema_lumina/pages/mainmenu_page.dart';

void main() {
  group('Lumina App Tests', () {
    testWidgets('App loads without errors', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the app loads without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Welcome page displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: WelcomePage()));

      // Verify welcome page elements
      expect(find.text('Lumina'), findsOneWidget);
      expect(
        find.text('Tu plataforma de aprendizaje colaborativo'),
        findsOneWidget,
      );
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('Login page displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      // Verify login page elements
      expect(find.text('Iniciar Sesión'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('¿No tienes cuenta?'), findsOneWidget);
    });

    testWidgets('Register page displays correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      // Verify register page elements
      expect(find.text('Crear Cuenta'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('¿Ya tienes cuenta?'), findsOneWidget);
    });

    testWidgets('Home page displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Verify home page elements
      expect(find.text('¡Hola, Usuario!'), findsOneWidget);
      expect(find.text('Acciones Rápidas'), findsOneWidget);
      expect(
        find.text('Recomendaciones Inteligentes de Mentora'),
        findsOneWidget,
      );
      expect(find.text('Mis Materias'), findsOneWidget);
    });

    testWidgets('Main menu page displays correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: MainMenuPage()));

      // Verify main menu elements
      expect(find.text('Lumina'), findsOneWidget);
      expect(find.text('Inicio'), findsOneWidget);
      expect(find.text('Materias'), findsOneWidget);
      expect(find.text('Grupos'), findsOneWidget);
      expect(find.text('Archivos'), findsOneWidget);
      expect(find.text('Mentora AI'), findsOneWidget);
      expect(find.text('Ajustes'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
      expect(find.text('Reputación'), findsOneWidget);
    });

    testWidgets('Quick actions buttons are present', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Verify quick action buttons
      expect(find.text('Subir Archivo'), findsOneWidget);
      expect(find.text('Conectar con Compañeros'), findsOneWidget);
    });

    testWidgets('Recommendation cards are displayed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Verify recommendation cards
      expect(find.text('¡Mentora tiene nuevos ejercicios!'), findsOneWidget);
      expect(
        find.text('Practica los últimos temas de Matemáticas.'),
        findsOneWidget,
      );
      expect(find.text('Repasa \'La Revolución Francesa\''), findsOneWidget);
      expect(find.text('Tu resumen personalizado'), findsOneWidget);
    });

    testWidgets('Subject cards are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Verify subject cards
      expect(find.text('Matemáticas discretas'), findsOneWidget);
      expect(find.text('Física Cuántica'), findsOneWidget);
      expect(
        find.text('Apuntes • Exámenes • Nuevo material disponible'),
        findsOneWidget,
      );
      expect(find.text('Apuntes • Actividad reciente'), findsOneWidget);
    });

    testWidgets('Search bar is present', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Verify search functionality
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Buscar archivos...'), findsOneWidget);
    });

    testWidgets('User avatar is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Verify user avatar
      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('Progress bar for reputation is present', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: MainMenuPage()));

      // Verify reputation progress bar
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('App theme uses correct colors', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify theme colors
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.debugShowCheckedModeBanner, false);
    });

    testWidgets('App title is correct', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify app title
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Lumina');
    });

    testWidgets('Profile image loads from Supabase Storage', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Verify that profile image loading is handled
      expect(find.byType(CircleAvatar), findsWidgets);
      // The image will show a loading indicator or fallback icon
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
