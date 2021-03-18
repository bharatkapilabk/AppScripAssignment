import 'dart:async';

import 'package:assignment_firebase/activities/Home_Screen.dart';
import 'package:assignment_firebase/activities/Login_Screen.dart';
import 'package:assignment_firebase/blocs/home/HomeBloc.dart';
import 'package:assignment_firebase/blocs/login/LoginBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Splash_Screen extends StatefulWidget {
  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  String uid='';
  String uemail='';

  checkNewOrNot()async{
    uid=await GetStorage('auth').read('uid');
    uemail=await GetStorage('auth').read('uemail');
    if(uid=='' || uid==null){
      Get.offAll(()=>BlocProvider(
        create: (context)=>LoginBloc(),
        child: Login_Screen(),
      ));
    }
    else{
      Get.offAll(()=>BlocProvider(
        create: (context)=>HomeBloc(),
        child: Home_Screen(uid),
      ));
      // Get.offAll(()=>BlocProvider(
      //   create: (context)=>QuestionBloc(),
      //   child: Questions_Screen(),
      // ));
    }
  }
  void goToHomePage(){
    Timer(
        Duration(seconds: 3),
            (){
          checkNewOrNot();
        }
    );
  }


  @override
  void initState() {
    goToHomePage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
