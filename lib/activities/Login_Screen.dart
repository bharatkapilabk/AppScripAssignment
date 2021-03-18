import 'package:assignment_firebase/activities/Home_Screen.dart';
import 'package:assignment_firebase/activities/Signup_Screen.dart';
import 'package:assignment_firebase/blocs/login/LoginBloc.dart';
import 'package:assignment_firebase/blocs/login/LoginEvents.dart';
import 'package:assignment_firebase/blocs/login/LoginStates.dart';
import 'package:assignment_firebase/blocs/signup/SignupBloc.dart';
import 'package:assignment_firebase/reusables/Appbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class Login_Screen extends StatelessWidget {


  String email;
  String password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  //To Check Valid email address
  static bool isEmailValid(email){
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }



  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc=BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(context, 'Login'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            loginForm(),
            BlocBuilder<LoginBloc,LoginState>(
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
                        loginBloc.add(Login(email,password));
                      }
                      else{
                        print('Fail');
                      }
                    },
                    child: Text('Login'),
                  );
                }
                else if(state is Loading){
                  return Center(child: CircularProgressIndicator(),);
                }
                else if(state is LoginSuccess){
                  return Text('Success');
                }
                else if(state is ErrorInLogin){
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
                        loginBloc.add(Login(email,password));
                      }
                      else{
                        print('Fail');
                      }
                    },
                    child: Text('Login'),
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
                    create: (context)=>SignupBloc(),
                    child: Signup_Screen(),
                  ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a user? '),
                    Text('Sign Up',style: TextStyle(fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  //Form Containing email and password fields
  loginForm(){
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


  //Email Field
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


  //Password Field
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