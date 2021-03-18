import 'package:equatable/equatable.dart';

class SignupEvent extends Equatable{
  @override
  List<Object> get props => [];

}
class Signup extends SignupEvent{
  final email;
  final password;

  Signup(this.email, this.password);

  @override
  List<Object> get props => [email,password];
}