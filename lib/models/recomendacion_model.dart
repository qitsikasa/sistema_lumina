class RecomendacionModel {
  final String id;
  final String titulo;
  final String? descripcion;
  final String tipo;
  final String? materiaId;
  final String usuarioId;
  final bool activa;
  final DateTime createdAt;

  RecomendacionModel({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.tipo,
    this.materiaId,
    required this.usuarioId,
    required this.activa,
    required this.createdAt,
  });

  factory RecomendacionModel.fromJson(Map<String, dynamic> json) {
    return RecomendacionModel(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      tipo: json['tipo'],
      materiaId: json['materia_id'],
      usuarioId: json['usuario_id'],
      activa: json['activa'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'tipo': tipo,
      'materia_id': materiaId,
      'usuario_id': usuarioId,
      'activa': activa,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
