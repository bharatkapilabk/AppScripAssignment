import 'package:equatable/equatable.dart';

class LoginState extends Equatable{
  @override
  List<Object> get props => [];

}
class NotAuthenticated extends LoginState{

}
class Loading extends LoginState{

}
class LoginSuccess extends LoginState{

}
class ErrorInLogin extends LoginState{

}