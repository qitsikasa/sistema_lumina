import 'materia_model.dart';

class GroupModel {
  final String id;
  final String nombre;
  final String? descripcion;
  final String? materiaId;
  final MateriaModel? materia;
  final String? creadorId;
  final DateTime? createdAt;
  final String? tipo;
  final String? semestre;
  final String? carrera;
  final String? facultad;
  final int miembrosCount;
  final int archivosCount;
  final String? codigoInvitacion;

  GroupModel({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.materiaId,
    this.materia,
    this.creadorId,
    this.createdAt,
    this.tipo,
    this.semestre,
    this.carrera,
    this.facultad,
    this.miembrosCount = 0,
    this.archivosCount = 0,
    this.codigoInvitacion,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      materiaId: json['materia_id'],
      materia:
          json['materia'] != null
              ? MateriaModel.fromJson(json['materia'])
              : null,
      creadorId: json['creador_id'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      tipo: json['tipo'],
      semestre: json['semestre'],
      carrera: json['carrera'],
      facultad: json['facultad'],
      miembrosCount: json['miembros_count'] ?? 0,
      archivosCount: json['archivos_count'] ?? 0,
      codigoInvitacion: json['codigo_invitacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'materia_id': materiaId,
      'materia': materia?.toJson(),
      'creador_id': creadorId,
      'created_at': createdAt?.toIso8601String(),
      'tipo': tipo,
      'semestre': semestre,
      'carrera': carrera,
      'facultad': facultad,
      'miembros_count': miembrosCount,
      'archivos_count': archivosCount,
      'codigo_invitacion': codigoInvitacion,
    };
  }

  GroupModel copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? materiaId,
    MateriaModel? materia,
    String? creadorId,
    DateTime? createdAt,
    String? tipo,
    String? semestre,
    String? carrera,
    String? facultad,
    int? miembrosCount,
    int? archivosCount,
    String? codigoInvitacion,
  }) {
    return GroupModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      materiaId: materiaId ?? this.materiaId,
      materia: materia ?? this.materia,
      creadorId: creadorId ?? this.creadorId,
      createdAt: createdAt ?? this.createdAt,
      tipo: tipo ?? this.tipo,
      semestre: semestre ?? this.semestre,
      carrera: carrera ?? this.carrera,
      facultad: facultad ?? this.facultad,
      miembrosCount: miembrosCount ?? this.miembrosCount,
      archivosCount: archivosCount ?? this.archivosCount,
      codigoInvitacion: codigoInvitacion ?? this.codigoInvitacion,
    );
  }
}
