class Question {
  final String question;
  final List<String> answers;
  final int correctIndex;
  final String explanation;

  Question({
    required this.question,
    required this.answers,
    required this.correctIndex,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      answers: List<String>.from(json['answers'] as List),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answers': answers,
      'correctIndex': correctIndex,
      'explanation': explanation,
    };
  }
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
