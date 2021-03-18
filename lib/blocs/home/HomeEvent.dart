import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];

}
class GetHomeData extends HomeEvent{
  final count;
  GetHomeData(this.count);
  @override
  List<Object> get props => [count];
}