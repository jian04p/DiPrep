import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3-flash', // or 'gemini-2.5-flash' if that's your tier
  );

  Future<String> getResponse(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text ?? "I'm stumped...";
  }
}
