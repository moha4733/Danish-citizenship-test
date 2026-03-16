class Question {
  final String question;
  final String? questionEn; // English translation
  final List<String> answers;
  final List<String>? answersEn; // English answers
  final int correctIndex;
  final String explanation;
  final String? explanationEn; // English explanation
  final String category; // Category: history, culture, society, etc.

  Question({
    required this.question,
    this.questionEn,
    required this.answers,
    this.answersEn,
    required this.correctIndex,
    required this.explanation,
    this.explanationEn,
    required this.category,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      questionEn: json['questionEn'] as String?,
      answers: List<String>.from(json['answers'] as List),
      answersEn: json['answersEn'] != null 
          ? List<String>.from(json['answersEn'] as List) 
          : null,
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
      explanationEn: json['explanationEn'] as String?,
      category: json['category'] as String? ?? 'general',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      if (questionEn != null) 'questionEn': questionEn,
      'answers': answers,
      if (answersEn != null) 'answersEn': answersEn,
      'correctIndex': correctIndex,
      'explanation': explanation,
      if (explanationEn != null) 'explanationEn': explanationEn,
      'category': category,
    };
  }

  // Get localized question text
  String getLocalizedQuestion(bool isEnglish) => isEnglish && questionEn != null ? questionEn! : question;
  
  // Get localized answers
  List<String> getLocalizedAnswers(bool isEnglish) => isEnglish && answersEn != null ? answersEn! : answers;
  
  // Get localized explanation
  String getLocalizedExplanation(bool isEnglish) => isEnglish && explanationEn != null ? explanationEn! : explanation;
}

class TestResult {
  final int score;
  final int totalQuestions;
  final List<int> incorrectAnswers;
  final List<Question> questions;
  final Duration timeSpent;

  TestResult({
    required this.score,
    required this.totalQuestions,
    required this.incorrectAnswers,
    required this.questions,
    required this.timeSpent,
  });

  double get percentage => (score / totalQuestions) * 100;
  bool get passed => score >= 32; // Passing score is 32/40
}
