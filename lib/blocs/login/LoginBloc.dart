import 'package:assignment_firebase/activities/Home_Screen.dart';
import 'package:assignment_firebase/blocs/home/HomeBloc.dart';
import 'package:assignment_firebase/blocs/login/LoginEvents.dart';
import 'package:assignment_firebase/blocs/login/LoginStates.dart';
import 'package:assignment_firebase/networking/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState>{
  LoginBloc() : super(NotAuthenticated());

  String phone;
  String pin;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event)async* {
    if(event is NotAuthenticated){
      yield NotAuthenticated();
    }else if(event is Login){
      yield Loading();
      try{
          FirebaseAuth auth=FirebaseAuth.instance;
          final logMessage = await AuthenticationService(auth).signIn(email: event.email, password: event.password);
          if(logMessage=="Signed In"){
            GetStorage('auth').write('uid', auth.currentUser.uid);
            GetStorage('auth').write('uemail', auth.currentUser.email);
            yield LoginSuccess();
            Get.offAll(()=>BlocProvider(
              create: (context)=>HomeBloc(),
              child: Home_Screen(auth.currentUser.uid),
            ));
          }
          else{
            Get.snackbar('Error','Wrong email or password... Please try again!');
            yield ErrorInLogin();
          }
      }catch(_){
        yield ErrorInLogin();
      }
    }
    else if(event is ErrorInLogin){
      yield NotAuthenticated();
    }
  }
}
