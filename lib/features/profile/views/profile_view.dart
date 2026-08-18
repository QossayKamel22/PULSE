import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/pulse_spacing.dart';
import '../../../core/widgets/pulse_logo.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/constants/app_constants.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final theme = Get.find<ThemeController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(PulseSpacing.lg),
      child: MaxWidthBox(
        maxWidth: 640,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Profile', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: PulseSpacing.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(PulseSpacing.lg),
                child: Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            Obx(() => SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode_outlined)),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode_outlined)),
                    ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto)),
                  ],
                  selected: {theme.themeMode.value},
                  onSelectionChanged: (s) => theme.setThemeMode(s.first),
                )),
            const SizedBox(height: PulseSpacing.lg),
            Card(
              child: Column(
                children: [
                  ListTile(leading: const PulseLogo(size: 28), title: const Text(AppConstants.appName), subtitle: const Text('Version ${AppConstants.appVersion}')),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Sign out'),
                    onTap: auth.signOut,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
