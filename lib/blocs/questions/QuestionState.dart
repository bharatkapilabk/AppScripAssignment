import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class QuestionState extends Equatable{
  @override
  List<Object> get props => [];

}
class DataNotLoaded extends QuestionState{

}
class Loading extends QuestionState{

}
class QuestionSuccess extends QuestionState{
  final Stream<DocumentSnapshot> _stream;

  QuestionSuccess(this._stream);
  // final dbResult;
  // QuestionSuccess(this.dbResult);
  // QuestionsResp get getQuestions=>questionsResp;
}
class ErrorInQuestion extends QuestionState{

}