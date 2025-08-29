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
      id: json['id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      choices: (json['choices'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      answerIndex: json['answerIndex'] is int
          ? json['answerIndex']
          : int.tryParse(json['answerIndex'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'choices': choices,
    'answerIndex': answerIndex,
  };
}
class PlayAnswer {
  final String questionId;
  final int answer;

  PlayAnswer({required this.questionId, required this.answer});

  factory PlayAnswer.fromJson(Map<String, dynamic> json) => PlayAnswer(
    questionId: json['questionId'] ?? '',
    answer: json['answer'] is int
        ? json['answer']
        : int.tryParse(json['answer'].toString()) ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'answer': answer,
  };
}

class PlayRecord {
  final String player;
  final List<PlayAnswer> answers; // ✅ changer List<int> en List<PlayAnswer>
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
    answers: (json['answers'] as List? ?? [])
        .map((e) => PlayAnswer.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    score: json['score'] is int
        ? json['score']
        : int.tryParse(json['score'].toString()) ?? 0,
    playedAt: DateTime.tryParse(json['playedAt']?.toString() ?? '') ??
        DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'player': player,
    'answers': answers.map((e) => e.toJson()).toList(),
    'score': score,
    'playedAt': playedAt.toIso8601String(),
  };

  @override
  String toString() {
    return 'PlayRecord(player: $player, score: $score, answers: $answers, playedAt: $playedAt)';
  }
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

  factory Game.fromMistralJson(
      String id, Map<String, dynamic> json, Map<String, dynamic> source) {
    final questionsList = (json['questions'] as List? ?? [])
        .map((e) => Question.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return Game(
      id: id,
      name: json['name']?.toString() ?? 'Quiz',
      createdAt: DateTime.now(),
      source: source,
      numQuestions: json['numQuestions'] is int
          ? json['numQuestions']
          : int.tryParse(json['numQuestions'].toString()) ?? 0,
      questions: questionsList,
      plays: <PlayRecord>[],
    );
  }

  factory Game.fromJson(Map<String, dynamic> json) => Game(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    createdAt:
    DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
        DateTime.now(),
    source: Map<String, dynamic>.from(json['source'] ?? {}),
    numQuestions: json['numQuestions'] is int
        ? json['numQuestions']
        : int.tryParse(json['numQuestions'].toString()) ?? 0,
    questions: (json['questions'] as List? ?? [])
        .map((e) => Question.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    plays: (json['plays'] as List? ?? [])
        .map((e) => PlayRecord.fromJson(Map<String, dynamic>.from(e)))
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
