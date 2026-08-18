import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Drives Light / Dark / System theme selection app-wide.
class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
  }
}
