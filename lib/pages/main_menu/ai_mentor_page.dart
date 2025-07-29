import 'package:flutter/material.dart';

class AIMentorPage extends StatefulWidget {
  const AIMentorPage({super.key});

  @override
  State<AIMentorPage> createState() => _AIMentorPageState();
}

class _AIMentorPageState extends State<AIMentorPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: '¡Hola! Soy tu mentora AI. ¿En qué puedo ayudarte hoy?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mentora AI',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C4DFF),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tu asistente personal de aprendizaje',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 32),

          // Chat container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  // Chat header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C4DFF).withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C4DFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.smart_toy,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mentora AI',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'En línea',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Messages
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _MessageBubble(message: message);
                      },
                    ),
                  ),

                  // Input area
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Escribe tu pregunta...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            maxLines: null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF6C4DFF),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: _sendMessage,
                            icon: const Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick actions
          const Text(
            'Acciones rápidas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _QuickActionButton(
                text: 'Explicar concepto',
                icon: Icons.lightbulb,
                onPressed: () {
                  _messageController.text =
                      '¿Puedes explicarme el concepto de derivadas en cálculo?';
                },
              ),
              _QuickActionButton(
                text: 'Resolver ejercicio',
                icon: Icons.school,
                onPressed: () {
                  _messageController.text =
                      '¿Puedes ayudarme a resolver este ejercicio de programación?';
                },
              ),
              _QuickActionButton(
                text: 'Generar resumen',
                icon: Icons.summarize,
                onPressed: () {
                  _messageController.text =
                      '¿Puedes hacer un resumen de los temas principales de física?';
                },
              ),
              _QuickActionButton(
                text: 'Practicar',
                icon: Icons.quiz,
                onPressed: () {
                  _messageController.text =
                      '¿Puedes generar ejercicios de práctica para Java?';
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    final userMessage = _messageController.text;
    _messageController.clear();

    // Simular respuesta de la AI
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _generateAIResponse(userMessage),
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    });
  }

  String _generateAIResponse(String userMessage) {
    if (userMessage.toLowerCase().contains('derivada')) {
      return 'Las derivadas son una herramienta fundamental del cálculo que nos permite encontrar la tasa de cambio instantánea de una función. La derivada de una función f(x) en un punto x=a se define como el límite de la razón de cambio cuando el incremento tiende a cero. ¿Te gustaría que profundice en algún aspecto específico?';
    } else if (userMessage.toLowerCase().contains('java')) {
      return 'Java es un lenguaje de programación orientado a objetos muy popular. Algunos conceptos fundamentales incluyen: clases, objetos, herencia, polimorfismo y encapsulamiento. ¿En qué área específica de Java te gustaría que te ayude?';
    } else if (userMessage.toLowerCase().contains('física')) {
      return 'La física es la ciencia que estudia la materia, la energía y sus interacciones. Los temas principales incluyen: mecánica, termodinámica, electromagnetismo y física moderna. ¿Qué tema específico te interesa?';
    } else {
      return 'Entiendo tu pregunta. Como tu mentora AI, estoy aquí para ayudarte con cualquier duda académica. ¿Puedes ser más específico sobre el tema que te interesa?';
    }
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF6C4DFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    message.isUser
                        ? const Color(0xFF6C4DFF)
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF6C4DFF)),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6C4DFF)),
            ),
          ],
        ),
      ),
    );
  }
}
