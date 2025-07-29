import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/group_model.dart';
import '../models/materia_model.dart';
import '../supabase_client.dart';

class GroupService {
  static final SupabaseClient _supabase = supabase;

  // Obtener todos los grupos
  static Future<List<GroupModel>> getGroups() async {
    try {
      final response = await _supabase
          .from('grupos')
          .select('*')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => GroupModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error obteniendo grupos: $e');
      return _getExampleGroups(); // Fallback a datos de ejemplo
    }
  }

  // Crear un nuevo grupo
  static Future<GroupModel?> createGroup({
    required String nombre,
    required String descripcion,
    required String tipo,
    required String semestre,
    required String carrera,
    required String facultad,
    String? materiaId,
  }) async {
    try {
      // Generar código de invitación único
      final codigoInvitacion = await _generateInvitationCode();

      // Obtener el usuario actual
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      final response =
          await _supabase
              .from('grupos')
              .insert({
                'nombre': nombre,
                'descripcion': descripcion,
                'tipo': tipo,
                'semestre': semestre,
                'carrera': carrera,
                'facultad': facultad,
                'materia_id': materiaId,
                'creador_id': user.id,
                'codigo_invitacion': codigoInvitacion,
                'miembros_count': 1, // El creador es el primer miembro
                'archivos_count': 0,
              })
              .select()
              .single();

      // Agregar al creador como miembro del grupo
      try {
        await _supabase.from('grupo_miembros').insert({
          'grupo_id': response['id'],
          'usuario_id': user.id,
        });
      } catch (e) {
        print('Error agregando creador como miembro: $e');
        // Continuar aunque falle, el grupo ya se creó
      }

      return GroupModel.fromJson(response);
    } catch (e) {
      print('Error creando grupo: $e');
      return null;
    }
  }

  // Unirse a un grupo usando código de invitación
  static Future<bool> joinGroupByCode(String codigoInvitacion) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Buscar el grupo por código de invitación
      final grupoResponse =
          await _supabase
              .from('grupos')
              .select('id')
              .eq('codigo_invitacion', codigoInvitacion)
              .single();

      if (grupoResponse == null) {
        throw Exception('Código de invitación inválido');
      }

      final grupoId = grupoResponse['id'];

      // Verificar si ya es miembro
      final existingMember =
          await _supabase
              .from('grupo_miembros')
              .select('id')
              .eq('grupo_id', grupoId)
              .eq('usuario_id', user.id)
              .maybeSingle();

      if (existingMember != null) {
        throw Exception('Ya eres miembro de este grupo');
      }

      // Agregar como miembro
      await _supabase.from('grupo_miembros').insert({
        'grupo_id': grupoId,
        'usuario_id': user.id,
      });

      return true;
    } catch (e) {
      print('Error uniéndose al grupo: $e');
      return false;
    }
  }

  // Obtener un grupo por ID
  static Future<GroupModel?> getGroupById(String id) async {
    try {
      final response =
          await _supabase.from('grupos').select('*').eq('id', id).single();

      return GroupModel.fromJson(response);
    } catch (e) {
      print('Error obteniendo grupo: $e');
      return null;
    }
  }

  // Actualizar un grupo
  static Future<bool> updateGroup(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _supabase.from('grupos').update(updates).eq('id', id);

      return true;
    } catch (e) {
      print('Error actualizando grupo: $e');
      return false;
    }
  }

  // Eliminar un grupo
  static Future<bool> deleteGroup(String id) async {
    try {
      await _supabase.from('grupos').delete().eq('id', id);

      return true;
    } catch (e) {
      print('Error eliminando grupo: $e');
      return false;
    }
  }

  // Obtener mensajes de un grupo
  static Future<List<Map<String, dynamic>>> getGroupMessages(
    String grupoId,
  ) async {
    try {
      final response = await _supabase
          .from('grupo_mensajes')
          .select('''
            *,
            usuarios:usuario_id (
              id,
              nombre,
              apellido,
              email
            )
          ''')
          .eq('grupo_id', grupoId)
          .order('created_at', ascending: true);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error obteniendo mensajes: $e');
      return [];
    }
  }

  // Enviar mensaje a un grupo
  static Future<bool> sendMessage(String grupoId, String mensaje) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      await _supabase.from('grupo_mensajes').insert({
        'grupo_id': grupoId,
        'usuario_id': user.id,
        'mensaje': mensaje,
      });

      return true;
    } catch (e) {
      print('Error enviando mensaje: $e');
      return false;
    }
  }

  // Verificar si el usuario es miembro de un grupo
  static Future<bool> isUserMemberOfGroup(String grupoId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final response =
          await _supabase
              .from('grupo_miembros')
              .select('id')
              .eq('grupo_id', grupoId)
              .eq('usuario_id', user.id)
              .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error verificando membresía: $e');
      return false;
    }
  }

  // Generar código de invitación único
  static Future<String> _generateInvitationCode() async {
    try {
      // Usar la función de Supabase para generar código
      final response = await _supabase.rpc('generar_codigo_invitacion');
      return response as String;
    } catch (e) {
      print('Error generando código de invitación: $e');
      // Fallback: generar código local
      return _generateLocalInvitationCode();
    }
  }

  // Fallback para generar código local
  static String _generateLocalInvitationCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code;
    do {
      code = '';
      for (int i = 0; i < 8; i++) {
        code += chars[DateTime.now().millisecondsSinceEpoch % chars.length];
      }
    } while (code.length != 8);
    return code;
  }

  // Datos de ejemplo para fallback
  static List<GroupModel> _getExampleGroups() {
    return [
      GroupModel(
        id: '1',
        nombre: 'Grupo de Matemáticas Avanzadas',
        descripcion: 'Estudio colaborativo de cálculo diferencial e integral',
        tipo: 'Estudio',
        semestre: '3er Semestre',
        carrera: 'Ingeniería Informática',
        facultad: 'Facultad de Ciencias y Tecnología',
        codigoInvitacion: 'MATH123',
        miembrosCount: 5,
        archivosCount: 12,
        materia: MateriaModel(
          id: '1',
          nombre: 'Matemáticas',
          descripcion: 'Matemáticas avanzadas',
          icono: 'functions',
          color: '#FF9800',
          usuarioId: '1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
      GroupModel(
        id: '2',
        nombre: 'Investigación en IA',
        descripcion: 'Proyecto de investigación sobre machine learning',
        tipo: 'Investigación',
        semestre: '5to Semestre',
        carrera: 'Ingeniería Informática',
        facultad: 'Facultad de Ciencias y Tecnología',
        codigoInvitacion: 'AI456',
        miembrosCount: 3,
        archivosCount: 8,
        materia: MateriaModel(
          id: '2',
          nombre: 'Programación',
          descripcion: 'Programación avanzada',
          icono: 'code',
          color: '#2196F3',
          usuarioId: '1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
      GroupModel(
        id: '3',
        nombre: 'Debate Filosófico',
        descripcion: 'Discusiones sobre ética y filosofía moderna',
        tipo: 'Debate',
        semestre: '2do Semestre',
        carrera: 'Filosofía',
        facultad: 'Facultad de Humanidades',
        codigoInvitacion: 'PHIL789',
        miembrosCount: 7,
        archivosCount: 3,
        materia: MateriaModel(
          id: '3',
          nombre: 'Historia',
          descripcion: 'Historia y filosofía',
          icono: 'public',
          color: '#9C27B0',
          usuarioId: '1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
      GroupModel(
        id: '4',
        nombre: 'Laboratorio de Química',
        descripcion: 'Prácticas de laboratorio de química orgánica',
        tipo: 'Laboratorio',
        semestre: '4to Semestre',
        carrera: 'Ingeniería Química',
        facultad: 'Facultad de Ciencias y Tecnología',
        codigoInvitacion: 'CHEM321',
        miembrosCount: 4,
        archivosCount: 15,
        materia: MateriaModel(
          id: '4',
          nombre: 'Química',
          descripcion: 'Química orgánica',
          icono: 'science',
          color: '#4CAF50',
          usuarioId: '1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
    ];
  }
}
