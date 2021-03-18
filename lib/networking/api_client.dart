import 'dart:convert';
import 'dart:io';

import 'package:assignment_firebase/models/Questions_model.dart';
import 'package:dio/dio.dart';

class ApiClient{
  static final String baseUrl = "https://opentdb.com/api.php?";

  var dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 100000,
      sendTimeout: 10000,
      receiveTimeout: 100000,
      headers: {
        HttpHeaders.userAgentHeader: "dio",
        "api": "1.0.0",
      },
      contentType: Headers.jsonContentType,
      responseType: ResponseType.plain,
    ),
  );


  Future<QuestionsResp> getData(count)async{
    final String url='amount=$count';
    Response response;
    try{
      response=await dio.get(url);
      QuestionsResp questionsResp=questionsRespFromJson(response.toString());
      return questionsResp;
    }catch(error){
      return questionsRespFromJson(jsonDecode(response.toString()));
    }
  }
}