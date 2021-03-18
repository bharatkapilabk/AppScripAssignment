import 'package:assignment_firebase/models/Questions_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable{
  @override
  List<Object> get props => [];

}
class DataNotLoaded extends HomeState{

}
class Loading extends HomeState{

}
class HomeSuccess extends HomeState{
  final questionsResp;
  HomeSuccess(this.questionsResp);
  QuestionsResp get getQuestions=>questionsResp;
}
class ErrorInHome extends HomeState{

}