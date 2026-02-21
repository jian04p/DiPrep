import 'package:flutter/material.dart';
import '../services/firebase_gemini_service.dart';

class FirebaseGeminiChatScreen extends StatefulWidget {
  const FirebaseGeminiChatScreen({super.key});

  @override
  State<FirebaseGeminiChatScreen> createState() => _FirebaseGeminiChatScreenState();
}

class _FirebaseGeminiChatScreenState extends State<FirebaseGeminiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  Stream<String>? _responseStream;
  GeminiService? _geminiService;

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService();
  }

  void _sendMessage() {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;
    setState(() {
      _messages.add('You: $prompt');
      _responseStream = _geminiService!.streamChat(prompt);
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gemini AI Chat (FirebaseAI)')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + 1,
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  return Align(
                    alignment: _messages[index].startsWith('You:')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _messages[index].startsWith('You:')
                            ? Colors.blue[100]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_messages[index]),
                    ),
                  );
                } else if (_responseStream != null) {
                  return StreamBuilder<String>(
                    stream: _responseStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Gemini is typing...'),
                        );
                      } else if (snapshot.hasData) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Gemini: ${snapshot.data}'),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return const SizedBox.shrink();
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
