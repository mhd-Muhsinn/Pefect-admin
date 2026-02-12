

import 'package:flutter/material.dart';

import '../form_models/question_form_data.dart';

class QuestionFormWidget extends StatelessWidget {
  final int index;
  final QuestionFormData data;
  final VoidCallback onRemove;

  const QuestionFormWidget({
    super.key,
    required this.index,
    required this.data,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Question ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onRemove,
                ),
              ],
            ),

            TextField(
              controller: data.questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
              ),
            ),

            const SizedBox(height: 12),

            for (int i = 0; i < 4; i++)
              _OptionTile(
                index: i,
                controller: data.optionControllers[i],
                isCorrect: data.correctIndex == i,
                onSelect: () {
                  data.correctIndex = i;
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final bool isCorrect;
  final VoidCallback onSelect;

  const _OptionTile({
    required this.index,
    required this.controller,
    required this.isCorrect,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<bool>(
          value: true,
          groupValue: isCorrect,
          onChanged: (_) => onSelect(),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Option ${index + 1}',
            ),
          ),
        ),
      ],
    );
  }
}
