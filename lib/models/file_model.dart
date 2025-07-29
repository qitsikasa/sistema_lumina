class FileModel {
  final String id;
  final String nombre;
  final String nombreOriginal;
  final String tipo;
  final int tamano;
  final String urlStorage;
  final String usuarioId;
  final String usuario;
  final String? materiaId;
  final String? materia;
  final String? grupoId;
  final String? grupo;
  final String? descripcion;
  final DateTime createdAt;
  final DateTime updatedAt;

  FileModel({
    required this.id,
    required this.nombre,
    required this.nombreOriginal,
    required this.tipo,
    required this.tamano,
    required this.urlStorage,
    required this.usuarioId,
    required this.usuario,
    this.materiaId,
    this.materia,
    this.grupoId,
    this.grupo,
    this.descripcion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      nombreOriginal: json['nombre_original'] ?? '',
      tipo: json['tipo'] ?? '',
      tamano: json['tamano'] ?? 0,
      urlStorage: json['url_storage'] ?? '',
      usuarioId: json['usuario_id'] ?? '',
      usuario: 'Usuario', // Por ahora usar valor por defecto
      materiaId: json['materia_id'],
      materia: null, // Por ahora no usar relaciones
      grupoId: json['grupo_id'],
      grupo: null, // Por ahora no usar relaciones
      descripcion: json['descripcion'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'nombre_original': nombreOriginal,
      'tipo': tipo,
      'tamano': tamano,
      'url_storage': urlStorage,
      'usuario_id': usuarioId,
      'materia_id': materiaId,
      'grupo_id': grupoId,
      'descripcion': descripcion,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  FileModel copyWith({
    String? id,
    String? nombre,
    String? nombreOriginal,
    String? tipo,
    int? tamano,
    String? urlStorage,
    String? usuarioId,
    String? usuario,
    String? materiaId,
    String? materia,
    String? grupoId,
    String? grupo,
    String? descripcion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FileModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      nombreOriginal: nombreOriginal ?? this.nombreOriginal,
      tipo: tipo ?? this.tipo,
      tamano: tamano ?? this.tamano,
      urlStorage: urlStorage ?? this.urlStorage,
      usuarioId: usuarioId ?? this.usuarioId,
      usuario: usuario ?? this.usuario,
      materiaId: materiaId ?? this.materiaId,
      materia: materia ?? this.materia,
      grupoId: grupoId ?? this.grupoId,
      grupo: grupo ?? this.grupo,
      descripcion: descripcion ?? this.descripcion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
