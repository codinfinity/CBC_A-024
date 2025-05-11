import 'package:flutter/material.dart';

class SkinTypeSurveyProvider extends ChangeNotifier {
  final List<int?> _answers = List.filled(10, null);

  void updateAnswer(int index, int value) {
    _answers[index] = value;
    notifyListeners();
  }

  List<int?> get answers => _answers;

  int get totalScore => _answers.whereType<int>().fold(0, (sum, value) => sum + value);

  String get skinType {
    final score = totalScore;
    if (score <= 7) return 'Type I';
    if (score <= 16) return 'Type II';
    if (score <= 25) return 'Type III';
    if (score <= 30) return 'Type IV';
    return 'Type V–VI';
  }

  bool get isComplete => !_answers.contains(null);
}