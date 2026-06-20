import 'package:flutter/material.dart';

/// A single multiple-choice question.
class MCQ {
  final String question;
  final List<String> options;
  final int answerIndex;
  final String explanation;

  MCQ({
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });

  factory MCQ.fromJson(Map<String, dynamic> json) {
    return MCQ(
      question: json['q'] as String? ?? '',
      options: (json['opts'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      answerIndex: json['ans'] is int
          ? json['ans'] as int
          : int.tryParse(json['ans'].toString()) ?? 0,
      explanation: json['exp'] as String? ?? '',
    );
  }
}

/// A single practical / memo-based question.
class PracticeQuestion {
  final String subtopic;
  final String question;
  final int marks;
  final String memo;

  PracticeQuestion({
    required this.subtopic,
    required this.question,
    required this.marks,
    required this.memo,
  });

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuestion(
      subtopic: json['subtopic'] as String? ?? '',
      question: json['q'] as String? ?? '',
      marks: json['marks'] is int
          ? json['marks'] as int
          : int.tryParse(json['marks'].toString()) ?? 0,
      memo: json['memo'] as String? ?? '',
    );
  }
}

/// A topic within a paper, e.g. "Human Reproduction".
class Topic {
  final String id;
  final String name;
  final List<MCQ> mcqs;
  final List<PracticeQuestion> practice;

  Topic({
    required this.id,
    required this.name,
    required this.mcqs,
    required this.practice,
  });

  int get totalQuestions => mcqs.length + practice.length;
}

/// A paper (Paper 1 / Paper 2) containing several topics.
class Paper {
  final String id;
  final String label;
  final List<Topic> topics;

  Paper({required this.id, required this.label, required this.topics});

  int get totalQuestions =>
      topics.fold(0, (sum, t) => sum + t.totalQuestions);
}

/// A subject, e.g. Life Sciences or Agricultural Sciences.
class Subject {
  final String id;
  final String title;
  final String emoji;
  final Color accent;
  final List<Paper> papers;

  Subject({
    required this.id,
    required this.title,
    required this.emoji,
    required this.accent,
    required this.papers,
  });

  int get totalQuestions =>
      papers.fold(0, (sum, p) => sum + p.totalQuestions);
}
