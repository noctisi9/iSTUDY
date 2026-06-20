import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/models.dart';

/// Metadata for a topic: its JSON key (id) and its display name.
class TopicMeta {
  final String id;
  final String name;
  const TopicMeta(this.id, this.name);
}

const List<TopicMeta> lifeTopicsP1 = [
  TopicMeta('human-reproduction', 'Human Reproduction'),
  TopicMeta('responding-plants', 'Responding to the Environment (Plants)'),
  TopicMeta('human-endocrine', 'Human Endocrine System'),
  TopicMeta('homeostasis', 'Homeostasis in Humans'),
  TopicMeta('vertebrate-reproduction', 'Reproduction in Vertebrates'),
  TopicMeta('responding-humans', 'Responding to the Environment (Humans)'),
];

const List<TopicMeta> lifeTopicsP2 = [
  TopicMeta('dna', 'DNA'),
  TopicMeta('meiosis', 'Meiosis'),
  TopicMeta('genetics-inheritance', 'Genetics & Inheritance'),
  TopicMeta('evolution', 'Evolution'),
];

const List<TopicMeta> agriTopicsP1 = [
  TopicMeta('animal-nutrition', 'Animal Nutrition'),
  TopicMeta('animal-production', 'Animal Production, Protection & Control'),
  TopicMeta('animal-reproduction', 'Animal Reproduction'),
];

const List<TopicMeta> agriTopicsP2 = [
  TopicMeta('management-marketing', 'Agricultural Management & Marketing'),
  TopicMeta('production-factors', 'Production Factors'),
  TopicMeta('basic-genetics', 'Basic Agricultural Genetics'),
];

/// Loads the bundled JSON data once and exposes the built Subject tree.
/// Use [DataRepository.instance] as a simple singleton.
class DataRepository {
  DataRepository._();
  static final DataRepository instance = DataRepository._();

  List<Subject>? _cachedSubjects;

  Future<List<Subject>> loadSubjects() async {
    final cached = _cachedSubjects;
    if (cached != null) return cached;

    final results = await Future.wait([
      rootBundle.loadString('assets/data/life.json'),
      rootBundle.loadString('assets/data/agri.json'),
    ]);

    final lifeJson = json.decode(results[0]) as Map<String, dynamic>;
    final agriJson = json.decode(results[1]) as Map<String, dynamic>;

    final subjects = [
      Subject(
        id: 'life',
        title: 'Life Sciences',
        emoji: '🧬',
        accent: const Color(0xFF2E7D32),
        papers: [
          Paper(
            id: 'p1',
            label: 'Paper 1',
            topics: _buildTopics(lifeJson, 'p1', lifeTopicsP1),
          ),
          Paper(
            id: 'p2',
            label: 'Paper 2',
            topics: _buildTopics(lifeJson, 'p2', lifeTopicsP2),
          ),
        ],
      ),
      Subject(
        id: 'agri',
        title: 'Agricultural Sciences',
        emoji: '🌾',
        accent: const Color(0xFFEF6C00),
        papers: [
          Paper(
            id: 'p1',
            label: 'Paper 1',
            topics: _buildTopics(agriJson, 'p1', agriTopicsP1),
          ),
          Paper(
            id: 'p2',
            label: 'Paper 2',
            topics: _buildTopics(agriJson, 'p2', agriTopicsP2),
          ),
        ],
      ),
    ];

    _cachedSubjects = subjects;
    return subjects;
  }

  List<Topic> _buildTopics(
    Map<String, dynamic> source,
    String paperKey,
    List<TopicMeta> metas,
  ) {
    final paperData = source[paperKey] as Map<String, dynamic>?;
    return metas.map((meta) {
      final topicData = paperData?[meta.id] as Map<String, dynamic>?;
      final mcqRaw = topicData?['mcq'] as List<dynamic>? ?? const [];
      final practiceRaw =
          topicData?['practice'] as List<dynamic>? ?? const [];
      return Topic(
        id: meta.id,
        name: meta.name,
        mcqs: mcqRaw
            .map((e) => MCQ.fromJson(e as Map<String, dynamic>))
            .toList(),
        practice: practiceRaw
            .map((e) => PracticeQuestion.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }).toList();
  }
}
