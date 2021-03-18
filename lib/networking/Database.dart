import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<void> addUsers(Map usersData, String userID) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .set(usersData)
        .catchError((e) {
      print(e.toString());
    });
  }
  Future<void> addQuestions(Map questionsData,String userID)async{
    await FirebaseFirestore.instance.collection('Users')
        .doc(userID).collection("QNA")
        .add(questionsData)
        .catchError((e){
          print(e.toString());
    });
  }
  getQuestionData(String userID) async{
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(userID)
        .collection("QNA")
        .get();
  }
}
