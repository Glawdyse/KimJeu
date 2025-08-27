class Question {
  final String id;
  final String question;
  final List<String> choices;
  final int answerIndex;

  Question({
    required this.id,
    required this.question,
    required this.choices,
    required this.answerIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      question: json['question'] as String,
      choices: (json['choices'] as List).map((e) => e.toString()).toList(),
      answerIndex: json['answerIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'choices': choices,
    'answerIndex': answerIndex,
  };
}

class PlayRecord {
  final String player;
  final List<int> answers;
  final int score;
  final DateTime playedAt;

  PlayRecord({
    required this.player,
    required this.answers,
    required this.score,
    required this.playedAt,
  });

  factory PlayRecord.fromJson(Map<String, dynamic> json) => PlayRecord(
    player: json['player']?.toString() ?? 'Anonymous',
    answers: (json['answers'] as List).map((e) => e as int).toList(),
    score: json['score'] as int,
    playedAt: DateTime.parse(json['playedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'player': player,
    'answers': answers,
    'score': score,
    'playedAt': playedAt.toIso8601String(),
  };
}

class Game {
  final String id;
  final String name;
  final DateTime createdAt;
  final Map<String, dynamic> source;
  final int numQuestions;
  final List<Question> questions;
  final List<PlayRecord> plays;

  Game({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.source,
    required this.numQuestions,
    required this.questions,
    required this.plays,
  });

  Game copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    Map<String, dynamic>? source,
    int? numQuestions,
    List<Question>? questions,
    List<PlayRecord>? plays,
  }) {
    return Game(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      source: source ?? this.source,
      numQuestions: numQuestions ?? this.numQuestions,
      questions: questions ?? this.questions,
      plays: plays ?? this.plays,
    );
  }

  factory Game.fromMistralJson(String id, Map<String, dynamic> json, Map<String, dynamic> source) {
    final questionsList = (json['questions'] as List)
        .map((e) => Question.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return Game(
      id: id,
      name: json['name']?.toString() ?? 'Quiz',
      createdAt: DateTime.now(),
      source: source,
      numQuestions: json['numQuestions'] as int,
      questions: questionsList,
      plays: <PlayRecord>[],
    );
  }

  factory Game.fromJson(Map<String, dynamic> json) => Game(
    id: json['id'] as String,
    name: json['name'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    source: Map<String, dynamic>.from(json['source'] as Map),
    numQuestions: json['numQuestions'] as int,
    questions: (json['questions'] as List)
        .map((e) => Question.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
    plays: (json['plays'] as List? ?? [])
        .map((e) => PlayRecord.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'source': source,
    'numQuestions': numQuestions,
    'questions': questions.map((e) => e.toJson()).toList(),
    'plays': plays.map((e) => e.toJson()).toList(),
  };
}