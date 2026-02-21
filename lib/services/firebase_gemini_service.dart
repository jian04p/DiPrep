import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService()
      : _model = FirebaseAI.googleAI(
          apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
        ).generativeModel(
          model: 'gemini-2.5-flash',
        );

  /// Streams Gemini responses for a given prompt
  Stream<String> streamChat(String prompt) async* {
    final stream = _model.generateContentStream(prompt);
    await for (final chunk in stream) {
      if (chunk.text != null) {
        yield chunk.text!;
      }
    }
  }
}
