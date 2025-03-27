import 'package:get/get.dart';

import '../modules/aboutus/bindings/aboutus_binding.dart';
import '../modules/aboutus/views/aboutus_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/demandereo/bindings/demandereo_binding.dart';
import '../modules/demandereo/views/demandereo_view.dart';
import '../modules/demandetransfert/bindings/demandetransfert_binding.dart';
import '../modules/demandetransfert/views/demandetransfert_view.dart';
import '../modules/forgotpassword/bindings/forgotpassword_binding.dart';
import '../modules/forgotpassword/views/forgotpassword_view.dart';
import '../modules/homeadmin/bindings/homeadmin_binding.dart';
import '../modules/homeadmin/views/homeadmin_view.dart';
import '../modules/homestudent/bindings/homestudent_binding.dart';
import '../modules/homestudent/views/homestudent_view.dart';
import '../modules/hometeacher/bindings/hometeacher_binding.dart';
import '../modules/hometeacher/views/hometeacher_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/news/bindings/news_binding.dart';
import '../modules/news/views/news_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/procedures/bindings/procedures_binding.dart';
import '../modules/procedures/views/procedures_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/traiterdemande/bindings/traiterdemande_binding.dart';
import '../modules/traiterdemande/views/traiterdemande_view.dart';

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
      page: () => DemandeReorientationScreen (),
      binding: DemandereoBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatScreen (),
      binding: ChatBinding(),
    ),

    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.ABOUTUS,
      page: () => AboutUsScreen (),
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
      page: () => TraiterDemandeScreen (demandeType: '',),
      binding: TraiterdemandeBinding(),
    ),
  ];
}
