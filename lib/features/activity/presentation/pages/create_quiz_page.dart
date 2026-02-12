import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/utils/id_generator.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/question_mode.dart';
import '../../data/models/quiz_model.dart';
import '../blocs/acitivity/activity_bloc.dart';
import '../blocs/acitivity/activity_event.dart';
import '../blocs/acitivity/activity_state.dart';
import '../form_models/question_form_data.dart';
import '../widgets/question_form_widget.dart';

class CreateQuizPage extends StatefulWidget {
  final String createdBy;

  const CreateQuizPage({
    super.key,
    required this.createdBy,
  });

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _titleController = TextEditingController();

  final List<QuestionFormData> _questions = [];

  @override
  void dispose() {
    _titleController.dispose();
    for (final q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  void _addQuestion() {
    setState(() {
      _questions.add(QuestionFormData());
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions[index].dispose();
      _questions.removeAt(index);
    });
  }

  void _submitQuiz() {
    if (_titleController.text.trim().isEmpty) {
      _showError('Quiz title is required');
      return;
    }

    if (_questions.isEmpty) {
      _showError('Add at least one question');
      return;
    }

    final questionModels = <QuestionModel>[];

    for (final q in _questions) {
      if (!q.isValid()) {
        _showError('Please complete all questions and options');
        return;
      }

      questionModels.add(q.toQuestionModel());
    }

    final quiz = QuizModel(
      quizId: IdGenerator.uuid(),
      title: _titleController.text.trim(),
      questions: questionModels,
      createdBy: widget.createdBy,
    );

    context.read<ActivityBloc>().add(
          CreateQuizEvent(quiz),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
      ),
      body: BlocListener<ActivityBloc, ActivityState>(
        listener: (context, state) {
          if (state is ActivityLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ActivitySuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Quiz created successfully')),
            );
            Navigator.pop(context);
          }

          if (state is ActivityError) {
            Navigator.pop(context);
            _showError(state.message);
          }
        },
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuestion,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Quiz Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Questions (${_questions.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              return QuestionFormWidget(
                index: index,
                data: _questions[index],
                onRemove: () => _removeQuestion(index),
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
    void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

}
