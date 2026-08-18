import 'package:get/get.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/firestore/firestore_service.dart';
import '../../../core/routes/app_routes.dart';

enum AuthStatus { idle, loading, error }

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  final status = AuthStatus.idle.obs;
  final errorMessage = RxnString();

  bool get isSignedIn => _authService.currentUser != null;
  String? get uid => _authService.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    // Keep session persistent: redirect based on live auth state.
    _authService.authStateChanges.listen((user) {
      if (user == null && Get.currentRoute != AppRoutes.login && Get.currentRoute != AppRoutes.signup) {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    status.value = AuthStatus.loading;
    errorMessage.value = null;
    try {
      await _authService.signIn(email: email.trim(), password: password);
      status.value = AuthStatus.idle;
      Get.offAllNamed(AppRoutes.root);
    } catch (e) {
      status.value = AuthStatus.error;
      errorMessage.value = _authService.describeError(e);
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    status.value = AuthStatus.loading;
    errorMessage.value = null;
    try {
      final cred = await _authService.signUp(email: email.trim(), password: password);
      final uid = cred.user?.uid;
      if (uid != null) {
        await _firestoreService.ensureUserProfile(uid, email: email.trim(), name: name.trim());
      }
      status.value = AuthStatus.idle;
      Get.offAllNamed(AppRoutes.root);
    } catch (e) {
      status.value = AuthStatus.error;
      errorMessage.value = _authService.describeError(e);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
