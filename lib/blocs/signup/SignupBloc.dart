import 'package:assignment_firebase/activities/Home_Screen.dart';
import 'package:assignment_firebase/blocs/home/HomeBloc.dart';
import 'package:assignment_firebase/blocs/signup/SignupEvents.dart';
import 'package:assignment_firebase/blocs/signup/SignupStates.dart';
import 'package:assignment_firebase/models/User_model.dart';
import 'package:assignment_firebase/networking/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SignupBloc extends Bloc<SignupEvent,SignupState>{
  UserModel SignupResp=new UserModel();
  SignupBloc() : super(NotAuthenticated());

  String phone;
  String pin;
  @override
  Stream<SignupState> mapEventToState(SignupEvent event)async* {
    if(event is NotAuthenticated){
      yield NotAuthenticated();
    }else if(event is Signup){
      yield Loading();
      try{
        FirebaseAuth auth=FirebaseAuth.instance;
        final logMessage = await AuthenticationService(auth).signUp(email: event.email, password: event.password);
        if(logMessage=="Signed Up"){
          GetStorage('auth').write('uid', auth.currentUser.uid);
          GetStorage('auth').write('uemail', auth.currentUser.email);
          yield SignupSuccess();
          Get.offAll(()=>BlocProvider(
            create: (context)=>HomeBloc(),
            child: Home_Screen(auth.currentUser.uid),
          ));
        }
        else{
          Get.snackbar('Error','User already exist in the database');
          yield NotAuthenticated();
        }
      }catch(_){
        yield ErrorInSignup();
      }
    }
    else if(event is ErrorInSignup){
      yield NotAuthenticated();
    }
  }
}
