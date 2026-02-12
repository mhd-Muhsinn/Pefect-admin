import 'package:flutter/material.dart';

import '../../data/models/question_mode.dart';


class QuestionFormData {
  final questionController = TextEditingController();
  final optionControllers =
      List.generate(4, (_) => TextEditingController());

  int correctIndex = -1;

  bool isValid() {
    if (questionController.text.trim().isEmpty) return false;
    if (correctIndex == -1) return false;

    for (final c in optionControllers) {
      if (c.text.trim().isEmpty) return false;
    }
    return true;
  }

  QuestionModel toQuestionModel() {
    return QuestionModel(
      question: questionController.text.trim(),
      options: optionControllers.map((e) => e.text.trim()).toList(),
      correctIndex: correctIndex,
    );
  }

  void dispose() {
    questionController.dispose();
    for (final c in optionControllers) {
      c.dispose();
    }
  }
}
