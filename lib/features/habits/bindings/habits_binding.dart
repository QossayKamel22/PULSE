import 'package:get/get.dart';
import '../controllers/habits_controller.dart';

class HabitsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HabitsController>(() => HabitsController(), fenix: true);
  }
}
