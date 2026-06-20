import 'dart:math';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final Topic topic;
  final Color accent;

  const QuizScreen({super.key, required this.topic, required this.accent});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<MCQ> _questions;
  int _index = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _questions = List<MCQ>.from(widget.topic.mcqs)..shuffle(Random());
  }

  MCQ get _current => _questions[_index];
  bool get _isLast => _index == _questions.length - 1;

  void _selectOption(int optionIndex) {
    if (_answered) return;
    setState(() {
      _selected = optionIndex;
      _answered = true;
      if (optionIndex == _current.answerIndex) {
        _score++;
      }
    });
  }

  void _next() {
    if (_isLast) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            topicName: widget.topic.name,
            score: _score,
            total: _questions.length,
            accent: widget.accent,
          ),
        ),
      );
      return;
    }
    setState(() {
      _index++;
      _selected = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_index + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.name),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.black12,
                        valueColor: AlwaysStoppedAnimation(widget.accent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_index + 1}/${_questions.length}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _current.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (int i = 0; i < _current.options.length; i++)
                      _OptionTile(
                        text: _current.options[i],
                        state: _stateForOption(i),
                        accent: widget.accent,
                        onTap: () => _selectOption(i),
                      ),
                    if (_answered) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _current.explanation,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _answered ? _next : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _isLast ? 'Finish' : 'Next question',
                    style: const TextStyle(
                      fontSize: 16,
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
  }

  _OptionState _stateForOption(int i) {
    if (!_answered) return _OptionState.idle;
    if (i == _current.answerIndex) return _OptionState.correct;
    if (i == _selected) return _OptionState.incorrect;
    return _OptionState.disabled;
  }
}

enum _OptionState { idle, correct, incorrect, disabled }

class _OptionTile extends StatelessWidget {
  final String text;
  final _OptionState state;
  final Color accent;
  final VoidCallback onTap;

  const _OptionTile({
    required this.text,
    required this.state,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.black12;
    Color bgColor = Colors.white;
    Color textColor = Colors.black87;
    IconData? trailingIcon;
    Color iconColor = Colors.transparent;

    switch (state) {
      case _OptionState.idle:
        borderColor = Colors.black12;
        break;
      case _OptionState.correct:
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.08);
        textColor = Colors.green.shade800;
        trailingIcon = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case _OptionState.incorrect:
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.08);
        textColor = Colors.red.shade800;
        trailingIcon = Icons.cancel;
        iconColor = Colors.red;
        break;
      case _OptionState.disabled:
        borderColor = Colors.black12;
        textColor = Colors.black38;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: state == _OptionState.idle ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1.4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(trailingIcon, color: iconColor, size: 22),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
