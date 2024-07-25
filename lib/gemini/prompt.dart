// A list of prompts to the Gemini API

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kazoku/gemini/model.dart';
import 'package:kazoku/database/database.dart';
import 'package:kazoku/utils/json.dart';
import 'package:kazoku/gemini/api_key.dart' as api_keys;

/// Prompt a character generator request via Gemini
Future<String?> promptCharacter(
  List<JSON> textures,
  String? characterPrompt,
) async {
  final model = geminiModel(api_keys.geminiKey);
  final prompt = """
  From the JSON I am going to provide to you, I want you to create a Character BASED ON A PROMPT.
  This character needs to have a name (first and last), a age, a gender, a body, a hairstyle (optional or null), eyes, and an outfit.
  The response you should provide to me should look like this:
  {
    "${DbHelper.characterNameCol}": "John Smith",
    "${DbHelper.characterAgeCol}": 33,
    "${DbHelper.characterGenderCol}": 1 for male 0 for female,
    "${DbHelper.characterBodyTextureCol}": the ID of the chosen body,
    "${DbHelper.characterEyesTextureCol}": the ID of the chosen eyes,
    "${DbHelper.characterHairstyleTextureCol}": the ID or (NULL for bald) of the chosen hairstyle,
    "${DbHelper.characterOutfitTextureCol}": the ID of the chosen outfit
  }

  YOUR response should not have any text other than the JSON you generate.
  Your response should not have comments in the JSON.
  Your response should create a character JSON that matches and looks appealing.
  Your response should have a random name. include first and last.
  Your response should have a random age. Should be between 1 - 51.
  Your response MUST be tailored to the prompt provided. For example, if the prompt is: "a girl with pink hair" then your response would be: 
  {
    "${DbHelper.characterNameCol}": Girly name,
    "${DbHelper.characterAgeCol}": a girl was mentioned so the age should be fairly young,
    "${DbHelper.characterGenderCol}": 0 for female,
    "${DbHelper.characterBodyTextureCol}": the ID of the chosen body (if a certain body color is in the prompt you should look for it VIA hex within the attributes. If not found, choose at random.),
    "${DbHelper.characterEyesTextureCol}": the ID of the chosen eyes (if certain eye color is in the prompt you should look for it VIA hex within the attributes. If not found, choose at random),
    "${DbHelper.characterHairstyleTextureCol}": the ID of the chosen hairstyle (should have a pinkish color due to the prompt asking for "pink hair". Most of the colors in the JSON within the attributes are hex colors which means you may have to do some conversions on the fly.),
    "${DbHelper.characterOutfitTextureCol}": the ID of the chosen outfit (should be a girl outfit). (if an outfit is specified i.e "wearing 'outfit_name'" you should look for the outfit in attributes.)
  }
  
  IF the gender is a woman, it should have a female name, use female hairstyles (which are gender 0).
  If the gender is a man, it shouold have a male name, use male hairstyles (which are gender 1).
  If the gender is a woman, it can use outfits gendered as (0) or outfits with girly colors i.e. (pink, purple, light-blue, grey-blue, certain shades of red, etc)
  If the gender is a man, it can use outfits gendered as  (1) or outfits with manly colors.

  The JSON is: $textures.
  The prompt is: $characterPrompt
""";
  try {
    final response = await model.generateContent([Content.text(prompt)]);

    return response.text;
  } catch (e) {
    print("ERROR in promptCharacterGenerator: $e");
    return null;
  }
}