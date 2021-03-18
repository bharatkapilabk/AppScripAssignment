import 'package:assignment_firebase/blocs/questions/QuestionEvent.dart';
import 'package:assignment_firebase/blocs/questions/QuestionState.dart';
import 'package:assignment_firebase/networking/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

class QuestionBloc extends Bloc<QuestionEvent,QuestionState>{
  QuestionBloc() : super(DataNotLoaded());
  DatabaseService databaseService=new DatabaseService();

  @override
  Stream<QuestionState> mapEventToState(QuestionEvent event)async* {
    String uid=await GetStorage('auth').read('uid');
    Stream<DocumentSnapshot> a =await FirebaseFirestore.instance.collection('Users').doc(uid).snapshots();
    if(event is GetQuestionData){
      yield Loading();
      try{
        if(a!=null){
          yield QuestionSuccess(a);
        }
        else {
          yield ErrorInQuestion();
        }
      }catch(e){
        yield ErrorInQuestion();
      }
    }
    else if(event is QuestionSuccess){
      yield QuestionSuccess(a);
    }
  }

}