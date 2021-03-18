import 'package:assignment_firebase/activities/QuizPlay.dart';
import 'package:assignment_firebase/blocs/home/HomeBloc.dart';
import 'package:assignment_firebase/blocs/home/HomeEvent.dart';
import 'package:assignment_firebase/blocs/home/HomeState.dart';
import 'package:assignment_firebase/reusables/Appbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class Home_Screen extends StatefulWidget {
  String uid = '';

  Home_Screen(this.uid);

  @override
  _Home_ScreenState createState() => _Home_ScreenState(uid);
}

class _Home_ScreenState extends State<Home_Screen> {
  String uid;
  int length;

  _Home_ScreenState(String uid) {
    this.uid = uid;
  }

  //Lists to check the results from DB
  List totalList = [];
  List answeredList = [];
  List correctList = [];
  List notattemptedList = [];
  List wrongList = [];
  bool isLoading = false;


  @override
  void initState() {
    if(this.mounted){
      getData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(context, 'Let\'s Play'),
      body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Total Questions: ',style: TextStyle(fontSize: 20),),
                          Text('${totalList.length}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Attempted: ',style: TextStyle(fontSize: 20),),
                          Text('${answeredList.length}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Not Attempted Questions: ',style: TextStyle(fontSize: 20),),
                          Text('${notattemptedList.length}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Correct: ',style: TextStyle(fontSize: 20),),
                          Text('${correctList.length}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Wrong: ',style: TextStyle(fontSize: 20),),
                          Text('${wrongList.length}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  ),
                ),
                isLoading?Center(child: CircularProgressIndicator(),):BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is DataNotLoaded) {
                      if (totalList.length == 0) {
                        homeBloc.add(GetHomeData(10));
                      } else if (totalList.length > 0 &&
                          notattemptedList.length == 0) {
                        homeBloc.add(GetHomeData(10));
                      }
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: Get.width * .7,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 50),
                                  child: Text(
                                    'Press the play button to start the game...',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Get.offAll(() => QuizPlay(uid,notattemptedList.length));
                            },
                            child: CircleAvatar(
                              backgroundColor: const Color(0xff0D735B),
                              radius: 60,
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 80,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is HomeSuccess) {
                      return InkWell(
                        onTap: () {
                          Get.offAll(() => QuizPlay(uid,notattemptedList.length));
                        },
                        child: CircleAvatar(
                          backgroundColor: const Color(0xff0D735B),
                          radius: 60,
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      );
                    } else if (state is ErrorInHome) {
                      return InkWell(
                        onTap: () {
                          Get.offAll(() => QuizPlay(uid,notattemptedList.length));
                        },
                        child: CircleAvatar(
                          backgroundColor: const Color(0xff0D735B),
                          radius: 60,
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      );
                    }
                    return Text('');
                  },
                ),
              ],
            ),
    );
  }


  //Getting data from Firestore
  getData() async {
    setState(() {
      isLoading = true;
    });
    Stream<QuerySnapshot> data = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('QNA')
        .snapshots();
    try{
      await data.forEach((element) {
        totalList.clear();
        notattemptedList.clear();
        correctList.clear();
        answeredList.clear();
        wrongList.clear();
        for (int i = 0; i < element.size; i++) {
          totalList.add(element);
          if (element.docs[i]['answer_status'] == 'N/A') {
            notattemptedList.add(element);
          } else if (element.docs[i]['answer_status'] == 'True') {
            correctList.add(element);
          } else if (element.docs[i]['answer_status'] == 'False') {
            wrongList.add(element);
          }
          answeredList.length=correctList.length+wrongList.length;
        }
        print('totalList.length ${totalList.length}');
        print('correct.length ${correctList.length}');
        print('nalist.length ${notattemptedList.length}');
        print('wrong.length ${wrongList.length}');
        print('answered.length ${answeredList.length}');
        setState(() {
          isLoading = false;
        });
      });
    }catch(e){
      print (e.toString());
    }
  }

}
