import 'package:assignment_firebase/activities/Login_Screen.dart';
import 'package:assignment_firebase/activities/Signup_Screen.dart';
import 'package:assignment_firebase/blocs/login/LoginBloc.dart';
import 'package:assignment_firebase/blocs/signup/SignupBloc.dart';
import 'package:assignment_firebase/blocs/signup/SignupEvents.dart';
import 'package:assignment_firebase/blocs/signup/SignupStates.dart';
import 'package:assignment_firebase/reusables/Appbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class Signup_Screen extends StatelessWidget {


  String email='';
  String password='';
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  static bool isEmailValid(email){
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
  static bool isPasswordStrong(password){
    return RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$").hasMatch(password);
  }



  @override
  Widget build(BuildContext context) {
    final SignupBloc signupBloc=BlocProvider.of<SignupBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(context, 'Signup'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SignupForm(),
            BlocBuilder<SignupBloc,SignupState>(
              builder: (context,state){
                if(state is NotAuthenticated){
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250,60),
                      primary: const Color(0xff0D735B),
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )
                      ),
                    ),
                    onPressed: (){
                      if(_formkey.currentState.validate()){
                        print('Success');
                        signupBloc.add(Signup(email,password));
                      }
                      else{
                        print('Fail');
                      }
                    },
                    child: Text('Signup'),
                  );
                }
                else if(state is Loading){
                  return Center(child: CircularProgressIndicator(),);
                }
                else if(state is SignupSuccess){
                  return Text('Success');
                }
                else if(state is ErrorInSignup){
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250,60),
                      primary: const Color(0xff0D735B),
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )
                      ),
                    ),
                    onPressed: (){
                      if(_formkey.currentState.validate()){
                        print('Success');
                        signupBloc.add(Signup(email,password));
                      }
                      else{
                        print('Fail');
                      }
                    },
                    child: Text('Signup'),
                  );
                }
                return Text('');
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Get.off(()=>BlocProvider(
                    create: (context)=>LoginBloc(),
                    child: Login_Screen(),
                  ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already a user? '),
                    Text('Log In',style: TextStyle(fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  SignupForm(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Form(
          key: _formkey,
          child: Column(
            children: [
              Container(
                width: Get.width*1,
                height: Get.height*.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    emailField(),
                    passwordField()
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
  emailField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (val){
          email=val;
          print(email);
        },
        validator: (String value){
          if(value.isEmpty){
            return 'Email is required';
          }
          else if(isEmailValid(value)==false){
            return 'Invalid Email';
          }
          else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              const Radius.circular(14),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xff0D735B)),
            borderRadius: BorderRadius.all(
              const Radius.circular(14),
            ),
          ),
          labelText: 'Email',
          labelStyle: new TextStyle(color: const Color(0xff0D735B)),
        ),
      ),
    );
  }
  passwordField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: (val){
          password=val;
          print(password);
        },
        obscureText: true,
        validator: (String value){
          if(value.isEmpty){
            return 'Password is required';
          }
          else if(isPasswordStrong(value)==false){
            return 'Password not strong enough';
          }
          else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              const Radius.circular(14),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xff0D735B)),
            borderRadius: BorderRadius.all(
              const Radius.circular(14),
            ),
          ),
          labelText: 'Password',
          labelStyle: new TextStyle(color: const Color(0xff0D735B)),
        ),
      ),
    );
  }
}