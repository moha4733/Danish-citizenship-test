import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/test_provider.dart';
import '../models/question.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> 
    with TickerProviderStateMixin {
  Timer? _timer;
  int _remainingSeconds = 30 * 60; // 30 minutes
  bool _timerEnabled = false;
  late AnimationController _progressBarController;
  late Animation<Color?> _progressBarColor;
  late AnimationController _shakeController;
  late AnimationController _checkmarkController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _checkmarkAnimation;

  @override
  void initState() {
    super.initState();
    _progressBarController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _progressBarColor = ColorTween(
      begin: Colors.red,
      end: Colors.green,
    ).animate(_progressBarController);
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
    
    _checkmarkAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _checkmarkController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timerEnabled = ModalRoute.of(context)?.settings.arguments as bool? ?? false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressBarController.dispose();
    _shakeController.dispose();
    _checkmarkController.dispose();
    super.dispose();
  }

  void _updateProgressBarColor() {
    final testProvider = Provider.of<TestProvider>(context, listen: false);
    final score = testProvider.score;
    final totalQuestions = testProvider.totalQuestions;
    final percentage = score / totalQuestions;
    
    Color targetColor;
    if (percentage < 0.6) { // Less than 60%
      targetColor = Colors.red;
    } else if (percentage < 0.8) { // 60-80%
      targetColor = Colors.orange;
    } else { // 80%+
      targetColor = Colors.green;
    }
    
    _progressBarColor.animateTo(targetColor);
  }

  void _triggerShakeAnimation() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  void _triggerCheckmarkAnimation() {
    _checkmarkController.forward();
  }

  void _startTimer() {
    if (_timerEnabled && _timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (_remainingSeconds > 0) {
              _remainingSeconds--;
            } else {
              _handleTimeUp();
            }
          });
        }
      });
    }
  }

  void _handleTimeUp() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/results');
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<TestProvider>(
            builder: (context, testProvider, child) {
              // Start timer when first build is complete
              if (_timerEnabled && _timer == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _startTimer();
                });
              }
              
              // Update progress bar color when score changes
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _updateProgressBarColor();
              });
              
              if (testProvider.currentQuestion == null) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header with Close Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Afslut prøve?'),
                                  content: const Text('Er du sikker på, at du vil afslutte prøven? Dit fremskridt vil blive mistet.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Fortsæt'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close dialog
                                        testProvider.resetTest();
                                        Navigator.pushReplacementNamed(context, '/home');
                                      },
                                      child: const Text('Afslut', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                          if (_timerEnabled)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _remainingSeconds < 300 
                                    ? const Color(0xFFEF4444) 
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _formatTime(_remainingSeconds),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Progress Bar
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Spørgsmål ${testProvider.currentQuestionIndex + 1}/${testProvider.totalQuestions}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _progressBarColor,
                                builder: (context, child) {
                                  return Text(
                                    '${(testProvider.progress * 100).toInt()}%',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          AnimatedBuilder(
                            animation: _progressBarColor,
                            builder: (context, child) {
                              return Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: testProvider.progress,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _progressBarColor.value ?? Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      
                      // Question
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Text(
                          testProvider.currentQuestion!.question,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E3A8A),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Answer Options
                      Column(
                        children: List.generate(
                          testProvider.currentQuestion!.answers.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildAnswerButton(
                              testProvider,
                              index,
                              testProvider.currentQuestion!.answers[index],
                              testProvider.currentQuestion!.correctIndex,
                            ),
                          ),
                        ),
                      ),
                      
                      // Next Button
                      if (testProvider.hasAnsweredCurrent)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                if (testProvider.isTestComplete) {
                                  Navigator.pushReplacementNamed(context, '/results');
                                } else {
                                  testProvider.nextQuestion();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF1E3A8A),
                                elevation: 8,
                                shadowColor: Colors.black.withValues(alpha: 0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: Text(
                                testProvider.isTestComplete ? 'Se Resultater' : 'Næste Spørgsmål',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(
    TestProvider testProvider,
    int index,
    String answer,
    int correctIndex,
  ) {
    bool isSelected = testProvider.selectedAnswerIndex == index;
    bool isCorrect = index == correctIndex;
    
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    
    if (testProvider.hasAnsweredCurrent) {
      if (isCorrect) {
        backgroundColor = const Color(0xFFDCFCE7);
        borderColor = const Color(0xFF22C55E);
        textColor = const Color(0xFF166534);
      } else if (isSelected) {
        backgroundColor = const Color(0xFFFEE2E2);
        borderColor = const Color(0xFFEF4444);
        textColor = const Color(0xFF991B1B);
      } else {
        backgroundColor = Colors.white;
        borderColor = Colors.grey.withValues(alpha: 0.2);
        textColor = Colors.grey;
      }
    } else {
      backgroundColor = isSelected ? const Color(0xFFEFF6FF) : Colors.white;
      borderColor = isSelected ? const Color(0xFF3B82F6) : Colors.grey.withValues(alpha: 0.2);
      textColor = isSelected ? const Color(0xFF1E3A8A) : const Color(0xFF374151);
    }

    return GestureDetector(
      onTap: () {
        if (!testProvider.hasAnsweredCurrent) {
          testProvider.answerQuestion(index);
          
          // Trigger animations based on answer
          if (isCorrect) {
            _triggerCheckmarkAnimation();
          } else {
            _triggerShakeAnimation();
          }
        }
      },
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              testProvider.hasAnsweredCurrent && !isCorrect && isSelected 
                  ? _shakeAnimation.value * 0.1 
                  : 0,
              0,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor,
                  width: 2,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ] : [],
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
                    ),
                    child: AnimatedBuilder(
                      animation: _checkmarkAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: testProvider.hasAnsweredCurrent && isCorrect && isSelected 
                              ? _checkmarkAnimation.value 
                              : 0,
                          child: isSelected && testProvider.hasAnsweredCurrent && isCorrect
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                answer,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
