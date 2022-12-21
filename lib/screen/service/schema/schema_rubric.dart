import 'dart:convert';

class RubricSchema {
  RubricSchema({
    this.answer,
    this.question,
  });

  static const String answerKey = 'answer';
  static const String questionKey = 'question';


  String? answer;
  String? question;

  RubricSchema copyWith({
    String? answer,
    String? question,
  }) {
    return RubricSchema(
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  RubricSchema clone() {
    return copyWith(
      question: question,
      answer: answer,
    );
  }

  static RubricSchema fromMap(Map<String, dynamic> data) {
    return RubricSchema(
      answer: data[answerKey],
      question: data[questionKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      questionKey: question,
      answerKey: answer,
    };
  }

  static List<RubricSchema> fromListJson(String source) {
    return List.of(
      (jsonDecode(source)['data'] as List).map((map) => fromMap(map)),
    );
  }

  static RubricSchema fromJson(String source) {
    return fromMap(jsonDecode(source));
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
