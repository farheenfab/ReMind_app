import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = 'AIzaSyDV5UlaWD_X76KsOJaGxadLwjMPYP-o-is'; // Replace with your Gemini API key

  Future<Map<String, dynamic>> getMCQOptions(File imageFile, String prompt) async {
    print("Hi");
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final imageBytes = await imageFile.readAsBytes();
    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart('image/png', imageBytes), // Specify the correct mime type
      ])
    ];

    final response = await model.generateContent(content);
    print(response);
    print(response.text);

    // Extract the text from the response
    final responseText = response.text;
    if (responseText == null) {
      throw Exception('Failed to get a valid response from the Gemini API');
    }
    print(responseText);

    // Parse the response text to JSON
    return jsonDecode(responseText);
  }
}