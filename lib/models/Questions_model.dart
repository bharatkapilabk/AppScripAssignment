import 'dart:convert';

QuestionsResp questionsRespFromJson(String str) => QuestionsResp.fromJson(json.decode(str));

String questionsRespToJson(QuestionsResp data) => json.encode(data.toJson());

class QuestionsResp {
  QuestionsResp({
    this.responseCode,
    this.results,
  });

  int responseCode;
  List<Result> results;

  factory QuestionsResp.fromJson(Map<String, dynamic> json) => QuestionsResp(
    responseCode: json["response_code"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "response_code": responseCode,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.category,
    this.type,
    this.difficulty,
    this.question,
    this.correctAnswer,
    this.incorrectAnswers,
  });

  String category;
  Type type;
  Difficulty difficulty;
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    category: json["category"],
    type: typeValues.map[json["type"]],
    difficulty: difficultyValues.map[json["difficulty"]],
    question: json["question"],
    correctAnswer: json["correct_answer"],
    incorrectAnswers: List<String>.from(json["incorrect_answers"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "type": typeValues.reverse[type],
    "difficulty": difficultyValues.reverse[difficulty],
    "question": question,
    "correct_answer": correctAnswer,
    "incorrect_answers": List<dynamic>.from(incorrectAnswers.map((x) => x)),
  };
}

enum Difficulty { EASY, MEDIUM, HARD }

final difficultyValues = EnumValues({
  "easy": Difficulty.EASY,
  "hard": Difficulty.HARD,
  "medium": Difficulty.MEDIUM
});

enum Type { MULTIPLE }

final typeValues = EnumValues({
  "multiple": Type.MULTIPLE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}


class QuestionsRespFromDB{
  String answer_status;
  String correct_answer;
  String level;
  String option1;
  String option2;
  String option3;
  String option4;
  String question;
  String user_answer;

  QuestionsRespFromDB({
    this.answer_status,
    this.correct_answer,
    this.level,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.question,
    this.user_answer,
});

  factory QuestionsRespFromDB.fromJson(Map<String, dynamic> json) => QuestionsRespFromDB(
    answer_status: json["answer_status"],
    correct_answer: json["correct_answer"],
    level: json["level"],
    option1: json["option1"],
    option2: json["option2"],
    option3: json["option3"],
    option4: json["option4"],
    question: json["question"],
    user_answer: json["user_answer"],
  );

  Map<String, dynamic> toJson() => {
    "answer_status": answer_status,
    "correct_answer": correct_answer,
    "level": level,
    "option1": option1,
    "option2": option2,
    "option3": option3,
    "option4": option4,
    "question": question,
    "user_answer": user_answer,
  };
}


class QuestionModel{

  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String correctOption;
  String answer_status;
  String user_answer;
  bool answered;
}