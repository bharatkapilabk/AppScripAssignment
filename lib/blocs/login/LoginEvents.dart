import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable{
  @override
  List<Object> get props => [];

}
class Login extends LoginEvent{
  final email;
  final password;
  Login(this.email, this.password);
  @override
  List<Object> get props => [email,password];
}