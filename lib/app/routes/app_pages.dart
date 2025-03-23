import 'package:get/get.dart';

import '../modules/aboutus/bindings/aboutus_binding.dart';
import '../modules/aboutus/views/aboutus_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/demande/bindings/demande_binding.dart';
import '../modules/demande/views/demande_view.dart';
import '../modules/demandereo/bindings/demandereo_binding.dart';
import '../modules/demandereo/views/demandereo_view.dart';
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

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.FORGOTPASSWORD,
      page: () => const ForgotpasswordView(),
      binding: ForgotpasswordBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.HOMETEACHER,
      page: () => const HometeacherView(),
      binding: HometeacherBinding(),
    ),
    GetPage(
      name: _Paths.HOMEADMIN,
      page: () => const HomeadminView(),
      binding: HomeadminBinding(),
    ),
    GetPage(
      name: _Paths.HOMESTUDENT,
      page: () => const HomestudentView(),
      binding: HomestudentBinding(),
    ),
    GetPage(
      name: _Paths.DEMANDEREO,
      page: () => const DemandereoView(),
      binding: DemandereoBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.DEMANDE,
      page: () => const DemandeView(),
      binding: DemandeBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.ABOUTUS,
      page: () => const AboutusView(),
      binding: AboutusBinding(),
    ),
    GetPage(
      name: _Paths.NEWS,
      page: () => const NewsView(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: _Paths.PROCEDURES,
      page: () => const ProceduresView(),
      binding: ProceduresBinding(),
    ),
  ];
}
