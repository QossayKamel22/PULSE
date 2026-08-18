import 'package:get/get.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/signup_view.dart';
import '../../features/auth/bindings/auth_binding.dart';
import '../../features/home/views/root_shell_view.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/habits/views/habit_details_view.dart';
import '../../features/habits/bindings/habits_binding.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.root,
      page: () => const RootShellView(),
      bindings: [HomeBinding(), AuthBinding()],
    ),
    GetPage(
      name: AppRoutes.habitDetails,
      page: () => const HabitDetailsView(),
      binding: HabitsBinding(),
    ),
  ];
}
