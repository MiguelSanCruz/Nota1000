class AlternativeModel {
  final String letter;
  final String text;
  final bool isCorrect;

  AlternativeModel({
    required this.letter,
    required this.text,
    required this.isCorrect,
  });

  factory AlternativeModel.fromJson(Map<String, dynamic> json) {
    return AlternativeModel(
      letter: json['letter'] ?? '',
      text: json['text'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'letter': letter,
        'text': text,
        'isCorrect': isCorrect,
      };
}

class QuestionModel {
  final int index;
  final int year;
  final String discipline;
  final String materia;
  final String context;
  final String alternativesIntroduction;
  final List<String> files;
  final String correctAlternative;
  final List<AlternativeModel> alternatives;

  QuestionModel({
    required this.index,
    required this.year,
    required this.discipline,
    required this.materia,
    required this.context,
    required this.alternativesIntroduction,
    required this.files,
    required this.correctAlternative,
    required this.alternatives,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    var rawFiles = json['files'] as List? ?? [];
    List<String> listFiles = rawFiles.map((e) => e.toString()).toList();

    var rawAlternatives = json['alternatives'] as List? ?? [];
    List<AlternativeModel> listAlternatives =
        rawAlternatives.map((e) => AlternativeModel.fromJson(e)).toList();

    return QuestionModel(
      index: json['index'] ?? 0,
      year: json['year'] ?? 0,
      discipline: json['discipline'] ?? '',
      materia: json['materia'] ?? '',
      context: json['context'] ?? '',
      alternativesIntroduction: json['alternativesIntroduction'] ?? '',
      files: listFiles,
      correctAlternative: json['correctAlternative'] ?? '',
      alternatives: listAlternatives,
    );
  }
}
