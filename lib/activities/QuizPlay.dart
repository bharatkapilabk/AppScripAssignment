import 'package:assignment_firebase/activities/Home_Screen.dart';
import 'package:assignment_firebase/blocs/ProgressController.dart';
import 'package:assignment_firebase/blocs/home/HomeBloc.dart';
import 'package:assignment_firebase/models/Questions_model.dart';
import 'package:assignment_firebase/networking/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class QuizPlay extends StatefulWidget {
  final String uid;
  final int length;
  QuizPlay(this.uid,this.length);

  @override
  _QuizPlayState createState() => _QuizPlayState(length);
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int total = 0;
String uid;

/// Stream
Stream infoStream;

class _QuizPlayState extends State<QuizPlay> {
  QuerySnapshot questionSnaphot;
  DatabaseService databaseService = new DatabaseService();
  int length=0;
  double progressPerQuestion=0.0;
  double progress=0.0;

  _QuizPlayState(int progress){
    this.length=progress;
  }

  bool isLoading = true;

  getUID()async{
    uid=await GetStorage('auth').read('uid');
    print('uid: $uid');
    progressPerQuestion=100/length;
    print('progressPerQuestion ${progressPerQuestion}');
    print('progress $progress');
    progressController.updateProgress(progressPerQuestion, progress);
    await databaseService.getQuestionData(uid).then((value) {
      questionSnaphot = value;
      _notAttempted = questionSnaphot.docs.length;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionSnaphot.docs.length;
      setState(() {});
      print("init don $total ${uid} ");
    });
  }

  @override
  void initState() {
    getUID();
    if(infoStream == null){
      infoStream = Stream<List<int>>.periodic(
          Duration(milliseconds: 100), (x){
        print("this is x $x");
        return [_correct, _incorrect] ;
      });
    }

    super.initState();
  }


  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionDocSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionDocSnapshot["question"];
    questionModel.user_answer=questionDocSnapshot["user_answer"];

    /// shuffling the options
    List<String> options = [
      questionDocSnapshot["option1"],
      questionDocSnapshot["option2"],
      questionDocSnapshot["option3"],
      questionDocSnapshot["option4"]
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionDocSnapshot["option4"];
    questionModel.answered = false;

    print(questionModel.correctOption.toLowerCase());

    return questionModel;
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  ProgressController progressController=Get.put(ProgressController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : SingleChildScrollView(
        child: Container(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                GetBuilder<ProgressController>(
                    init: Get.find(),
                    builder: (progressController){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(
                      value: progressController.progress.value/100,
                      backgroundColor: Colors.green,
                      valueColor:new AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                }),
                questionSnaphot.docs == null
                    ? Container(
                  child: Center(child: Text("No Data"),),
                )
                    : ListView.builder(
                    itemCount: questionSnaphot.docs.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      print('questionSnaphot.docs[index].id ${questionSnaphot.docs[index].id}');
                      return QuizPlayTile(
                        questionModel: getQuestionModelFromDatasnapshot(
                            questionSnaphot.docs[index]),
                        index: index,
                        snapshotIndex: questionSnaphot.docs[index].id,
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      Get.offAll(()=>BlocProvider(
                        create: (context)=>HomeBloc(),
                        child: Home_Screen(uid),
                      ));
                    },
                    child: Container(
                      width: Get.width*.8,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xff0D735B),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Continue to Home Screen',style: TextStyle(color: Colors.white,fontSize: 18),),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  final String snapshotIndex;

  QuizPlayTile({@required this.questionModel, @required this.index,@required this.snapshotIndex});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState(questionModel,index,snapshotIndex);
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";
  int index;
  String snapshotIndex;
  QuestionModel questionModel=new QuestionModel();
  double progress;
  double progressPerQuestion;
  _QuizPlayTileState(QuestionModel questionModel,int index,String snapshotIndex){
    this.questionModel=questionModel;
    this.index=index;
    this.snapshotIndex=snapshotIndex;
  }
  ProgressController progressController=Get.put(ProgressController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: 20
            ),
            child: Text(
              "Q${widget.index + 1} ${widget.questionModel.question}",
              style:
              TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.8)),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                //correct
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  progressController.increaseProgress();
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'answer_status':'True'
                    });
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'user_answer':widget.questionModel.correctOption
                    });
                  });
                  print('progress ${progress}');
                } else {
                  progressController.increaseProgress();
                  setState(() {
                    //progress+=progressPerQuestion;
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'answer_status':'False'
                    });
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'user_answer':widget.questionModel.option1
                    });
                  });
                  print('progress ${progress}');
                }
              }
            },
            child: OptionTile(
              option: "A",
              description: "${widget.questionModel.option1}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: widget.questionModel.user_answer!='N/A'?widget.questionModel.user_answer:optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                //correct
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  progressController.increaseProgress();
                  setState(() {
                    //progress+=progressPerQuestion;
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'answer_status':'True'
                    });
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'user_answer':widget.questionModel.correctOption
                    });
                    print('progress ${progress}');
                  });
                } else {
                  progressController.increaseProgress();
                  setState(() {
                    //progress+=progressPerQuestion;
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'answer_status':'False'
                    });
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'user_answer':widget.questionModel.option2
                    });
                  });
                  print('progress ${progress}+${progressPerQuestion}');
                }
              }
            },
            child: OptionTile(
              option: "B",
              description: "${widget.questionModel.option2}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: widget.questionModel.user_answer!='N/A'?widget.questionModel.user_answer:optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                //correct
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  progressController.increaseProgress();
                  setState(() {
                    //progress+=progressPerQuestion;
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'answer_status':'True'
                    });
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'user_answer':widget.questionModel.correctOption
                    });
                  });
                  print('progress ${progress}');
                } else {
                  progressController.increaseProgress();
                  setState(() {
                    //progress+=progressPerQuestion;
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'answer_status':'False'
                    });
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'user_answer':widget.questionModel.option3
                    });
                  });
                  print('progress ${progress}');
                }
              }
            },
            child: OptionTile(
              option: "C",
              description: "${widget.questionModel.option3}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: widget.questionModel.user_answer!='N/A'?widget.questionModel.user_answer:optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                //correct
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  progressController.increaseProgress();
                  setState(() {
                    //progress+=progressPerQuestion;
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'answer_status':'True'
                    });
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'user_answer':widget.questionModel.correctOption
                    });
                  });
                  print('progress ${progress}');
                } else {
                  progressController.increaseProgress();
                  setState(() {
                    //progress+=progressPerQuestion;
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'answer_status':'False'
                    });
                    FirebaseFirestore.instance.collection('Users').doc(uid).collection('QNA').doc(snapshotIndex).update({
                      'user_answer':widget.questionModel.option4
                    });
                  });
                  print('progress ${progress}');
                }
              }
            },
            child: OptionTile(
              option: "D",
              description: "${widget.questionModel.option4}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: widget.questionModel.user_answer!='N/A'?widget.questionModel.user_answer:optionSelected,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;

  OptionTile(
      {this.description, this.correctAnswer, this.option, this.optionSelected});

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
                    color: widget.optionSelected == widget.description
                        ? widget.description == widget.correctAnswer
                        ? Colors.green.withOpacity(0.7)
                        : Colors.red.withOpacity(0.7)
                        : Colors.grey,
                    width: 1.5),
                color: widget.optionSelected == widget.description
                    ? widget.description == widget.correctAnswer
                    ? Colors.green.withOpacity(0.7)
                    : Colors.red.withOpacity(0.7)
                    : Colors.white,
                borderRadius: BorderRadius.circular(24)
            ),
            child: Text(
              widget.option,
              style: TextStyle(
                color: widget.optionSelected == widget.description
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(widget.description, style: TextStyle(
              fontSize: 17, color: Colors.black54
          ),)
        ],
      ),
    );
  }
}