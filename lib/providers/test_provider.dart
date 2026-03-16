import 'package:flutter/foundation.dart';
import '../models/question.dart';
import '../services/question_service.dart';
import '../services/storage_service.dart';

class TestProvider extends ChangeNotifier {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<int> _incorrectAnswers = [];
  List<int> _userAnswers = [];
  bool _isTestActive = false;
  bool _hasAnsweredCurrent = false;
  int? _selectedAnswerIndex;

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  List<int> get incorrectAnswers => _incorrectAnswers;
  List<int> get userAnswers => _userAnswers;
  bool get isTestActive => _isTestActive;
  bool get hasAnsweredCurrent => _hasAnsweredCurrent;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  Question? get currentQuestion => _questions.isNotEmpty && _currentQuestionIndex < _questions.length
      ? _questions[_currentQuestionIndex]
      : null;
  int get totalQuestions => _questions.length;
  double get progress => _questions.isNotEmpty 
      ? (_currentQuestionIndex + 1) / _questions.length 
      : 0.0;

  Future<void> startTest() async {
    try {
      _questions = await QuestionService.getQuestions();
      _questions = QuestionService.getShuffledQuestions(_questions);
      _currentQuestionIndex = 0;
      _score = 0;
      _incorrectAnswers = [];
      _userAnswers = [];
      _isTestActive = true;
      _hasAnsweredCurrent = false;
      _selectedAnswerIndex = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error starting test: $e');
    }
  }

  void answerQuestion(int answerIndex) {
    if (_hasAnsweredCurrent || currentQuestion == null) return;

    _selectedAnswerIndex = answerIndex;
    _userAnswers.add(answerIndex);
    _hasAnsweredCurrent = true;

    if (answerIndex == currentQuestion!.correctIndex) {
      _score++;
    } else {
      _incorrectAnswers.add(_currentQuestionIndex);
    }

    if (isTestComplete) {
      StorageService.saveTestResult(_score, _questions.length);
    }

    notifyListeners();
  }

  void nextQuestion() {
    if (!_hasAnsweredCurrent) return;

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _hasAnsweredCurrent = false;
      _selectedAnswerIndex = null;
      notifyListeners();
    }
  }

  bool get isTestComplete => _isTestActive && _currentQuestionIndex >= _questions.length - 1 && _hasAnsweredCurrent;

  void resetTest() {
    _currentQuestionIndex = 0;
    _score = 0;
    _incorrectAnswers = [];
    _userAnswers = [];
    _isTestActive = false;
    _hasAnsweredCurrent = false;
    _selectedAnswerIndex = null;
    notifyListeners();
  }
}
