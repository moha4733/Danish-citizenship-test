import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionService {
  static List<Question>? _cachedQuestions;

  static Future<List<Question>> getQuestions() async {
    if (_cachedQuestions != null) {
      return _cachedQuestions!;
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/questions.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      _cachedQuestions = jsonList
          .map((json) => Question.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return _cachedQuestions!;
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  static List<Question> getShuffledQuestions(List<Question> questions) {
    final shuffled = List<Question>.from(questions);
    shuffled.shuffle();
    return shuffled;
  }
}
