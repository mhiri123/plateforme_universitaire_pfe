import 'package:get/get.dart';

import '../modules/aboutus/bindings/aboutus_binding.dart';
import '../modules/aboutus/views/aboutus_view.dart';
import '../modules/admin_management/bindings/admin_management_binding.dart';
import '../modules/admin_management/views/admin_management_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/demandereo/bindings/demandereo_binding.dart';
import '../modules/demandereo/views/demandereo_view.dart';
import '../modules/demandetransfert/bindings/demandetransfert_binding.dart';
import '../modules/demandetransfert/views/demandetransfert_view.dart';
import '../modules/envoyer_notification/bindings/envoyer_notification_binding.dart';
import '../modules/envoyer_notification/views/envoyer_notification_view.dart';
import '../modules/faculty_details/bindings/faculty_details_binding.dart';
import '../modules/faculty_details/views/faculty_details_view.dart';
import '../modules/faculty_management/bindings/faculty_management_binding.dart';
import '../modules/faculty_management/views/faculty_management_view.dart';
import '../modules/forgotpassword/bindings/forgotpassword_binding.dart';
import '../modules/forgotpassword/views/forgotpassword_view.dart';
import '../modules/homeadmin/bindings/homeadmin_binding.dart';
import '../modules/homeadmin/views/homeadmin_view.dart';
import '../modules/homestudent/bindings/homestudent_binding.dart';
import '../modules/homestudent/views/homestudent_view.dart';
import '../modules/homesuperadmin/bindings/homesuperadmin_binding.dart';
import '../modules/homesuperadmin/views/homesuperadmin_view.dart';
import '../modules/hometeacher/bindings/hometeacher_binding.dart';
import '../modules/hometeacher/views/hometeacher_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/news/bindings/news_binding.dart';
import '../modules/news/views/news_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/permission_management/bindings/permission_management_binding.dart';
import '../modules/permission_management/views/permission_management_view.dart';
import '../modules/procedures/bindings/procedures_binding.dart';
import '../modules/procedures/views/procedures_view.dart';
import '../modules/request_management/bindings/request_management_binding.dart';
import '../modules/request_management/views/request_management_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/traiterdemande/bindings/traiterdemande_binding.dart';
import '../modules/traiterdemande/views/traiterdemande_view.dart';
import '../modules/user_activation/bindings/user_activation_binding.dart';
import '../modules/user_activation/views/user_activation_view.dart';
import '../modules/user_management/bindings/user_management_binding.dart';
import '../modules/user_management/views/user_management_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.FORGOTPASSWORD,
      page: () => ForgotPasswordScreen(),
      binding: ForgotpasswordBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignUpScreen(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.HOMETEACHER,
      page: () => TeacherHomeScreen(),
      binding: HometeacherBinding(),
    ),
    GetPage(
      name: _Paths.HOMEADMIN,
      page: () => AdminHomeScreen(),
      binding: AdminHomeBinding(),
    ),
    GetPage(
      name: _Paths.HOMESTUDENT,
      page: () => StudentHomeScreen(),
      binding: HomestudentBinding(),
    ),
    GetPage(
      name: _Paths.DEMANDEREO,
      page: () => DemandeReorientationScreen(),
      binding: DemandereoBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.ABOUTUS,
      page: () => AboutUsScreen(),
      binding: AboutusBinding(),
    ),
    GetPage(
      name: _Paths.NEWS,
      page: () => NewsScreen(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: _Paths.PROCEDURES,
      page: () => ProceduresScreen(),
      binding: ProceduresBinding(),
    ),
    GetPage(
      name: _Paths.DEMANDETRANSFERT,
      page: () => DemandeTransfertScreen(),
      binding: DemandetransfertBinding(),
    ),
    GetPage(
      name: _Paths.TRAITERDEMANDE,
      page: () => TraiterDemandeScreen(
        demandeType: '',
      ),
      binding: TraiterdemandeBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardScreen (),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.FACULTY_MANAGEMENT,
      page: () => FacultyManagementScreen(),
      binding: FacultyManagementBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_MANAGEMENT,
      page: () => AdminManagementScreen(),
      binding: AdminManagementBinding(),
    ),
    GetPage(
      name: _Paths.USER_MANAGEMENT,
      page: () => UserManagementScreen(),
      binding: UserManagementBinding(),
    ),
    GetPage(
      name: _Paths.REQUEST_MANAGEMENT,
      page: () => RequestManagementScreen(),
      binding: RequestManagementBinding(),
    ),
    GetPage(
      name: _Paths.PERMISSION_MANAGEMENT,
      page: () => PermissionManagementScreen (),
      binding: PermissionManagementBinding(),
    ),
    GetPage(
      name: _Paths.FACULTY_DETAILS,
      page: () => FacultyDetailsScreen(facultyId: 1),
      binding: FacultyDetailsBinding(),
    ),
    GetPage(
      name: _Paths.USER_ACTIVATION,
      page: () => UserActivationScreen(),
      binding: UserActivationBinding(),
    ),
    GetPage(
      name: _Paths.ENVOYER_NOTIFICATION,
      page: () => EnvoyerNotificationScreen(),
      binding: EnvoyerNotificationBinding(),
    ),
    GetPage(
      name: _Paths.HOMESUPERADMIN,
      page: () => SuperAdminHomeScreen(),
      binding: HomesuperadminBinding(),
    ),
  ];
}
