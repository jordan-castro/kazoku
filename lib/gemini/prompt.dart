// A list of prompts to the Gemini API

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kazoku/gemini/model.dart';
import 'package:kazoku/utils/database.dart';
import 'package:kazoku/utils/json.dart';
import 'package:kazoku/gemini/api_key.dart' as api_keys;

/// Prompt a character generator request via Gemini
Future<String?> promptCharacter(List<JSON> textures) async {
  final model = geminiModel(api_keys.geminiKey);
  final prompt = """
  From the JSON I am going to provide to you, I want you to create a Character.
  This character needs to have a name (first and last), a age, a gender, a body, a hairstyle (optional or null), eyes, and an outfit.
  The response you should provide to me should look like this:
  {
    "${DbHelper.characterNameCol}": "John Smith",
    "${DbHelper.characterAgeCol}": 33,
    "${DbHelper.characterGenderCol}": 1 for male 0 for female,
    "${DbHelper.characterBodyTextureCol}": the ID of the chosen body,
    "${DbHelper.characterEyesTextureCol}": the ID of the chosen eyes,
    "${DbHelper.characterHairstyleTextureCol}": the ID or NULL if is bald of the chosen hairstyle,
    "${DbHelper.characterOutfitTextureCol}": the ID of the chosen outfit
  }

  YOUR response should not have any text other than the JSON you generate.
  Your response should not have comments in the JSON.
  Your response should create a character JSON that matches and looks appleasing.
  Your response should have a random name. include first and last.
  Your response should have a random age. Should be between 1 - 51.
  
  IF the gender of the character is a male, it should have a male name.
  IF the gender is a women, it should have a female name.

  The JSON is: $textures
""";
  try {
    final response = await model.generateContent([Content.text(prompt)]);

    return response.text;
  } catch (e) {
    print("ERROR in promptCharacterGenerator: $e");
    return null;
  }
}

Future<String?> promptCustomerCharacter(
  List<JSON> textures,
  String characterPrompt,
) async {
  final model = geminiModel(api_keys.geminiKey);
  final prompt = """
  From the JSON I am going to provide to you, I want you to create a Character.
  This character needs to have a name (first and last), a age, a gender, a body, a hairstyle (optional or null), eyes, and an outfit.
  The response you should provide to me should look like this:
  {
    "${DbHelper.characterNameCol}": "John Smith",
    "${DbHelper.characterAgeCol}": 33,
    "${DbHelper.characterGenderCol}": 1 for male 0 for female,
    "${DbHelper.characterBodyTextureCol}": the ID of the chosen body,
    "${DbHelper.characterEyesTextureCol}": the ID of the chosen eyes,
    "${DbHelper.characterHairstyleTextureCol}": the ID or NULL if is bald of the chosen hairstyle,
    "${DbHelper.characterOutfitTextureCol}": the ID of the chosen outfit
  }

  YOUR response should not have any text other than the JSON you generate.
  Your response should not have comments in the JSON.
  Your response should create a character JSON that matches and looks appleasing.
  Your response should have a random name. include first and last.
  Your response should have a random age. Should be between 1 - 51.
  Your response should try to be similiar to a character of type: $characterPrompt.

  IF the gender of the character is a male, it should have a male name.
  IF the gender is a woman, it should have a female name.
  IF the gender is a woman it should use the hairstyles that are gendered: 0.
  If the gender is a man it should use the hairstyles that are gendered: 1.

  The JSON is: $textures
""";
  try {
    final response = await model.generateContent([Content.text(prompt)]);

    return response.text;
  } catch (e) {
    print("ERROR in promptCustomerCharacter: $e");
    return null;
  }

}
