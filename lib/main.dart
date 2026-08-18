import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/bindings/auth_binding.dart';
import 'services/firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE: DefaultFirebaseOptions is a placeholder until `flutterfire
  // configure` is run against a real Firebase project — see README.
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {
    // Allows the UI to be explored before Firebase is wired up; every
    // Firebase-backed screen will surface its own error state.
  }

  Get.put(ThemeController());
  runApp(const PulseApp());
}

class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode.value,
      initialBinding: AuthBinding(),
      initialRoute: AppRoutes.login,
      getPages: AppPages.routes,
    );
  }
}
