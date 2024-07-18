import 'package:google_generative_ai/google_generative_ai.dart';

/// A function for creating the Gemini Model class
GenerativeModel geminiModel(String apiKey) {
  return GenerativeModel(
    model: "gemini-1.5-flash-latest",
    apiKey: apiKey,
  );
}
