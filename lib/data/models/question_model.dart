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

  // Novo: Construtor para ler as alternativas direto do SQLite
  factory AlternativeModel.fromMap(Map<String, dynamic> map) {
    return AlternativeModel(
      letter: map['letter'] ?? '',
      text: map['text'] ?? '',
      isCorrect: (map['isCorrect'] == 1), // SQLite guarda booleano como 1 ou 0
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

  // Novo: Construtor para montar a Questão combinando os dados do SQLite e a lista de alternativas
  factory QuestionModel.fromMap(Map<String, dynamic> map, List<Map<String, dynamic>> alternativeMaps) {
    List<AlternativeModel> listAlternatives = alternativeMaps
        .map((altMap) => AlternativeModel.fromMap(altMap))
        .toList();

    return QuestionModel(
      index: map['question_index'] ?? 0,
      year: map['year'] ?? 0,
      discipline: map['discipline'] ?? '',
      materia: map['materia'] ?? '',
      context: map['context'] ?? '',
      alternativesIntroduction: map['alternativesIntroduction'] ?? '',
      files: [], // Caso guarde arquivos depois, pode ajustar aqui
      correctAlternative: map['correctAlternative'] ?? '',
      alternatives: listAlternatives,
    );
  }
}