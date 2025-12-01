/// تعريف جميع مسارات التطبيق
class AppRoutes {
  // Auth Routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String signIn = '/signin';
  static const String signUp = '/signup';

  // Enrollment Routes
  static const String enrollment = '/enrollment';
  static const String registration = '/registration';
  static const String studentAccepted = '/student-accepted';
  static const String studentRejected = '/student-rejected';

  // Student Routes
  static const String studentHome = '/student-home';
  static const String students = '/students';
  static const String complaints = '/complaints';
  static const String commitments = '/commitments';
  static const String violations = '/violations';
  static const String payments = '/payments';
  static const String about = '/about';

  // Admin Routes
  static const String adminHome = '/admin-home';
  static const String adminViolations = '/admin-violations';
  static const String adminPayments = '/admin-payments';
  static const String adminNews = '/admin-news';
  static const String editCommitment = '/edit-commitment';

  // Home (Default)
  static const String home = '/home';
}
