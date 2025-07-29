class MateriaModel {
  final String id;
  final String nombre;
  final String? codigo;
  final String? descripcion;
  final String icono;
  final String color;
  final String usuarioId;
  final DateTime createdAt;
  final DateTime updatedAt;

  MateriaModel({
    required this.id,
    required this.nombre,
    this.codigo,
    this.descripcion,
    required this.icono,
    required this.color,
    required this.usuarioId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MateriaModel.fromJson(Map<String, dynamic> json) {
    return MateriaModel(
      id: json['id'],
      nombre: json['nombre'],
      codigo: json['codigo'],
      descripcion: json['descripcion'],
      icono: json['icono'] ?? 'book',
      color: json['color'] ?? '#6C4DFF',
      usuarioId: json['usuario_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'descripcion': descripcion,
      'icono': icono,
      'color': color,
      'usuario_id': usuarioId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
