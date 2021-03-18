import 'package:equatable/equatable.dart';

class SignupState extends Equatable{
  @override
  List<Object> get props => [];

}
class NotAuthenticated extends SignupState{

}
class Loading extends SignupState{

}
class SignupSuccess extends SignupState{

}
class ErrorInSignup extends SignupState{

}