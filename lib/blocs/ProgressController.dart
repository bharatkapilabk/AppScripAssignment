import 'package:get/get.dart';

class ProgressController extends GetxController{
  final progress = 0.0.obs;
  final done=0.0.obs;
  final total=100.0.obs;



  updateProgress(double done,double total){
    this.done.value=done;
    update();
    // this.total.value=total;
    print('');
  }

  increaseProgress(){
    progress.value=progress.value+done.value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }
}