class ActividadModel {
  final String id;
  final String tipo;
  final String titulo;
  final String? descripcion;
  final String usuarioId;
  final String? materiaId;
  final DateTime createdAt;

  ActividadModel({
    required this.id,
    required this.tipo,
    required this.titulo,
    this.descripcion,
    required this.usuarioId,
    this.materiaId,
    required this.createdAt,
  });

  factory ActividadModel.fromJson(Map<String, dynamic> json) {
    return ActividadModel(
      id: json['id'],
      tipo: json['tipo'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      usuarioId: json['usuario_id'],
      materiaId: json['materia_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'titulo': titulo,
      'descripcion': descripcion,
      'usuario_id': usuarioId,
      'materia_id': materiaId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
