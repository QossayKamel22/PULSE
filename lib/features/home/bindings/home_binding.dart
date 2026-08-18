import 'package:get/get.dart';
import '../../habits/controllers/habits_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HabitsController>(() => HabitsController(), fenix: true);
  }
}
