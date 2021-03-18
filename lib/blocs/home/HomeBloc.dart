import 'package:assignment_firebase/blocs/home/HomeEvent.dart';
import 'package:assignment_firebase/blocs/home/HomeState.dart';
import 'package:assignment_firebase/models/Questions_model.dart';
import 'package:assignment_firebase/networking/Database.dart';
import 'package:assignment_firebase/networking/api_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  HomeBloc() : super(DataNotLoaded());
  ApiClient apiClient=new ApiClient();
  DatabaseService databaseService=new DatabaseService();
  String user_id,user_email,user_name;
  QuestionsResp questionsResp=new QuestionsResp();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event)async* {
    user_id=await GetStorage('auth').read('uid');
    user_email=await GetStorage('auth').read('uemail');
    if(event is GetHomeData){
      yield Loading();
      try{
        questionsResp=await apiClient.getData(10);
        if(questionsResp.responseCode==0){
          Map<String,String> userMap={
            "user_email":user_email,
            "user_id":user_id,
          };
          print('questionsResp ${questionsResp.results.length}');
          await databaseService.addUsers(userMap, user_id);
          for(int i=0;i<questionsResp.results.length;i++){
            Map<String,String> questionsMap={
              "answer_status":'N/A',
              "correct_answer":questionsResp.results[i].correctAnswer,
              "level":'1',
              "option1":questionsResp.results[i].incorrectAnswers[0],
              "option2":questionsResp.results[i].incorrectAnswers[1],
              "option3":questionsResp.results[i].incorrectAnswers[2],
              "option4":questionsResp.results[i].correctAnswer,
              "question":questionsResp.results[i].question,
              "user_answer":"N/A",
            };
           await databaseService.addQuestions(questionsMap, user_id);
          }
          yield HomeSuccess(questionsResp);
        }
      }catch(e){
        yield ErrorInHome();
      }
    }else if(event is HomeSuccess){
      yield HomeSuccess(questionsResp);
    }
  }
}