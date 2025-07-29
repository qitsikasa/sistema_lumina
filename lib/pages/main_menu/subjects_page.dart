import 'package:flutter/material.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mis Materias',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4DFF),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Agregar nueva materia
                },
                icon: const Icon(Icons.add),
                label: const Text('Agregar Materia'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4DFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Lista de materias
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                return _SubjectCard(subject: subject);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Subject {
  final String name;
  final String code;
  final String teacher;
  final Color color;
  final int filesCount;
  final int membersCount;

  Subject({
    required this.name,
    required this.code,
    required this.teacher,
    required this.color,
    required this.filesCount,
    required this.membersCount,
  });
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;

  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: subject.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.book, color: subject.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subject.code,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Prof. ${subject.teacher}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoItem(
                  icon: Icons.folder,
                  value: '${subject.filesCount}',
                  label: 'Archivos',
                ),
                _InfoItem(
                  icon: Icons.people,
                  value: '${subject.membersCount}',
                  label: 'Miembros',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _InfoItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }
}

final List<Subject> _subjects = [
  Subject(
    name: 'Cálculo I',
    code: 'MAT-101',
    teacher: 'Dr. García',
    color: Colors.blue,
    filesCount: 15,
    membersCount: 45,
  ),
  Subject(
    name: 'Programación I',
    code: 'INF-101',
    teacher: 'Ing. López',
    color: Colors.green,
    filesCount: 23,
    membersCount: 38,
  ),
  Subject(
    name: 'Física I',
    code: 'FIS-101',
    teacher: 'Dr. Martínez',
    color: Colors.orange,
    filesCount: 8,
    membersCount: 52,
  ),
  Subject(
    name: 'Taller de Sistemas Operativos',
    code: 'INF-205',
    teacher: 'Ing. Rodríguez',
    color: Colors.purple,
    filesCount: 12,
    membersCount: 28,
  ),
  Subject(
    name: 'Inglés Técnico',
    code: 'ING-101',
    teacher: 'Lic. Smith',
    color: Colors.red,
    filesCount: 5,
    membersCount: 35,
  ),
  Subject(
    name: 'Estadística',
    code: 'EST-101',
    teacher: 'Dr. Pérez',
    color: Colors.teal,
    filesCount: 18,
    membersCount: 42,
  ),
];
