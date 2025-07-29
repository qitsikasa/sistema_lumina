// Datos de materias típicas de la Universidad Mayor de San Simón (UMSS)
class UMSSMaterias {
  static const List<Map<String, dynamic>> materias = [
    // Ingeniería de Sistemas
    {
      'nombre': 'Programación I',
      'codigo': 'SIS101',
      'descripcion': 'Fundamentos de programación y algoritmos',
      'icono': 'code',
      'color': '#2196F3',
      'facultad': 'Facultad de Ciencias y Tecnología',
    },
    {
      'nombre': 'Estructuras de Datos',
      'codigo': 'SIS201',
      'descripcion': 'Implementación y uso de estructuras de datos',
      'icono': 'data_array',
      'color': '#4CAF50',
      'facultad': 'Facultad de Ciencias y Tecnología',
    },
    {
      'nombre': 'Bases de Datos',
      'codigo': 'SIS301',
      'descripcion': 'Diseño y gestión de bases de datos',
      'icono': 'storage',
      'color': '#FF9800',
      'facultad': 'Facultad de Ciencias y Tecnología',
    },
    {
      'nombre': 'Sistemas Operativos',
      'codigo': 'SIS401',
      'descripcion': 'Gestión y administración de sistemas operativos',
      'icono': 'computer',
      'color': '#9C27B0',
      'facultad': 'Facultad de Ciencias y Tecnología',
    },
    {
      'nombre': 'Redes de Computadoras',
      'codigo': 'SIS501',
      'descripcion': 'Protocolos y arquitectura de redes',
      'icono': 'router',
      'color': '#607D8B',
      'facultad': 'Facultad de Ciencias y Tecnología',
    },

    // Ingeniería Civil
    {
      'nombre': 'Resistencia de Materiales',
      'codigo': 'CIV201',
      'descripcion': 'Análisis de esfuerzos y deformaciones',
      'icono': 'construction',
      'color': '#795548',
      'facultad': 'Facultad de Ciencias y Tecnología',
    },
    {
      'nombre': 'Hidráulica',
      'codigo': 'CIV301',
      'descripcion': 'Mecánica de fluidos aplicada',
      'icono': 'water_drop',
      'color': '#00BCD4',
      'facultad': 'Facultad de Ciencias y Tecnología',
    },

    // Ingeniería Industrial
    {
      'nombre': 'Investigación de Operaciones',
      'codigo': 'IND201',
      'descripcion': 'Métodos de optimización y programación lineal',
      'icono': 'analytics',
      'color': '#E91E63',
      'facultad': 'Facultad de Ciencias y Tecnología',
    },
    {
      'nombre': 'Gestión de Calidad',
      'codigo': 'IND301',
      'descripcion': 'Control estadístico de procesos',
      'icono': 'verified',
      'color': '#4CAF50',
      'facultad': 'Facultad de Ciencias y Tecnología',
    },

    // Medicina
    {
      'nombre': 'Anatomía Humana',
      'codigo': 'MED101',
      'descripcion': 'Estructura y organización del cuerpo humano',
      'icono': 'person',
      'color': '#F44336',
      'facultad': 'Facultad de Medicina',
    },
    {
      'nombre': 'Fisiología',
      'codigo': 'MED201',
      'descripcion': 'Funcionamiento de los sistemas corporales',
      'icono': 'favorite',
      'color': '#E91E63',
      'facultad': 'Facultad de Medicina',
    },

    // Derecho
    {
      'nombre': 'Derecho Civil',
      'codigo': 'DER101',
      'descripcion': 'Derecho privado y relaciones civiles',
      'icono': 'gavel',
      'color': '#3F51B5',
      'facultad': 'Facultad de Derecho',
    },
    {
      'nombre': 'Derecho Penal',
      'codigo': 'DER201',
      'descripcion': 'Normas penales y procedimientos',
      'icono': 'security',
      'color': '#FF5722',
      'facultad': 'Facultad de Derecho',
    },

    // Economía
    {
      'nombre': 'Microeconomía',
      'codigo': 'ECO101',
      'descripcion': 'Teoría del consumidor y productor',
      'icono': 'trending_up',
      'color': '#4CAF50',
      'facultad': 'Facultad de Ciencias Económicas',
    },
    {
      'nombre': 'Macroeconomía',
      'codigo': 'ECO201',
      'descripcion': 'Análisis de variables económicas agregadas',
      'icono': 'account_balance',
      'color': '#FF9800',
      'facultad': 'Facultad de Ciencias Económicas',
    },

    // Psicología
    {
      'nombre': 'Psicología General',
      'codigo': 'PSI101',
      'descripcion': 'Fundamentos de la psicología científica',
      'icono': 'psychology',
      'color': '#9C27B0',
      'facultad': 'Facultad de Humanidades',
    },
    {
      'nombre': 'Psicología del Desarrollo',
      'codigo': 'PSI201',
      'descripcion': 'Procesos de desarrollo humano',
      'icono': 'child_care',
      'color': '#FFC107',
      'facultad': 'Facultad de Humanidades',
    },

    // Arquitectura
    {
      'nombre': 'Dibujo Arquitectónico',
      'codigo': 'ARQ101',
      'descripcion': 'Técnicas de representación gráfica',
      'icono': 'architecture',
      'color': '#795548',
      'facultad': 'Facultad de Arquitectura',
    },
    {
      'nombre': 'Historia de la Arquitectura',
      'codigo': 'ARQ201',
      'descripcion': 'Evolución de estilos arquitectónicos',
      'icono': 'museum',
      'color': '#607D8B',
      'facultad': 'Facultad de Arquitectura',
    },
  ];

  static const List<Map<String, dynamic>> actividades = [
    {
      'tipo': 'archivo',
      'titulo': 'Nuevo archivo subido',
      'descripcion': 'Ejercicios_Programacion_I.pdf en Programación I',
    },
    {
      'tipo': 'grupo',
      'titulo': 'Nuevo grupo creado',
      'descripcion': 'Taller de Sistemas Operativos',
    },
    {
      'tipo': 'puntos',
      'titulo': 'Puntos ganados',
      'descripcion': '+50 puntos por ayudar a un compañero',
    },
    {
      'tipo': 'archivo',
      'titulo': 'Material actualizado',
      'descripcion': 'Apuntes_Bases_Datos.pdf en Bases de Datos',
    },
    {
      'tipo': 'grupo',
      'titulo': 'Nuevo miembro',
      'descripcion': 'Juan se unió al grupo de Redes',
    },
  ];

  static const List<Map<String, dynamic>> recomendaciones = [
    {
      'titulo': '¡Mentora tiene nuevos ejercicios!',
      'descripcion': 'Practica los últimos temas de Programación I',
      'tipo': 'ejercicio',
    },
    {
      'titulo': 'Repasa Estructuras de Datos',
      'descripcion': 'Según tu progreso, es hora de un repaso',
      'tipo': 'repaso',
    },
    {
      'titulo': 'Tu resumen personalizado',
      'descripcion': 'El resumen de Bases de Datos está listo',
      'tipo': 'resumen',
    },
    {
      'titulo': 'Nuevo material disponible',
      'descripcion': 'Videos explicativos de Sistemas Operativos',
      'tipo': 'material',
    },
  ];
}
