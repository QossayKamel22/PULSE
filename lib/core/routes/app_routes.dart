class AppRoutes {
  AppRoutes._();

  static const login = '/login';
  static const signup = '/signup';
  static const root = '/'; // hosts the AppShell (home/insights/profile tabs)
  static const habitDetails = '/habits/:id';

  static String habitDetailsPath(String id) => '/habits/$id';
}
