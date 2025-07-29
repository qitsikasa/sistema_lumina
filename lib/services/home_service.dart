import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/materia_model.dart';
import '../models/actividad_model.dart';
import '../models/recomendacion_model.dart';

class HomeService {
  // Obtener materias del usuario
  static Future<List<MateriaModel>> getMaterias() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) return [];

      final response = await Supabase.instance.client
          .from('materias')
          .select()
          .eq('usuario_id', currentUser.id)
          .order('created_at', ascending: false);

      return response.map((json) => MateriaModel.fromJson(json)).toList();
    } catch (e) {
      print('Error obteniendo materias: $e');
      return [];
    }
  }

  // Obtener actividades recientes
  static Future<List<ActividadModel>> getActividadesRecientes() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) return [];

      final response = await Supabase.instance.client
          .from('actividades')
          .select()
          .eq('usuario_id', currentUser.id)
          .order('created_at', ascending: false)
          .limit(5);

      return response.map((json) => ActividadModel.fromJson(json)).toList();
    } catch (e) {
      print('Error obteniendo actividades: $e');
      return [];
    }
  }

  // Obtener recomendaciones activas
  static Future<List<RecomendacionModel>> getRecomendaciones() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) return [];

      final response = await Supabase.instance.client
          .from('recomendaciones')
          .select()
          .eq('usuario_id', currentUser.id)
          .eq('activa', true)
          .order('created_at', ascending: false)
          .limit(3);

      return response.map((json) => RecomendacionModel.fromJson(json)).toList();
    } catch (e) {
      print('Error obteniendo recomendaciones: $e');
      return [];
    }
  }

  // Obtener estadísticas
  static Future<Map<String, int>> getEstadisticas() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        return {'materias': 0, 'grupos': 0, 'archivos': 0};
      }

      // Contar materias
      final materiasResponse = await Supabase.instance.client
          .from('materias')
          .select('id')
          .eq('usuario_id', currentUser.id);

      // Contar grupos
      final gruposResponse = await Supabase.instance.client
          .from('grupos')
          .select('id')
          .eq('creador_id', currentUser.id);

      // Contar archivos
      final archivosResponse = await Supabase.instance.client
          .from('archivos')
          .select('id')
          .eq('usuario_id', currentUser.id);

      return {
        'materias': materiasResponse.length,
        'grupos': gruposResponse.length,
        'archivos': archivosResponse.length,
      };
    } catch (e) {
      print('Error obteniendo estadísticas: $e');
      return {'materias': 0, 'grupos': 0, 'archivos': 0};
    }
  }

  // Formatear tiempo relativo
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'hace un momento';
    }
  }

  // Obtener icono para tipo de actividad
  static IconData getActivityIcon(String tipo) {
    switch (tipo) {
      case 'archivo':
        return Icons.upload_file;
      case 'grupo':
        return Icons.group;
      case 'puntos':
        return Icons.star;
      case 'recomendacion':
        return Icons.lightbulb;
      default:
        return Icons.info;
    }
  }

  // Obtener color para tipo de actividad
  static Color getActivityColor(String tipo) {
    switch (tipo) {
      case 'archivo':
        return Colors.blue;
      case 'grupo':
        return Colors.green;
      case 'puntos':
        return Colors.orange;
      case 'recomendacion':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
