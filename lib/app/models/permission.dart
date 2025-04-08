import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Permission {
  late final int id;
  final String role;
  final String access;
  RxBool isActive;

  Permission({
    required this.id,
    required this.role,
    required this.access,
    required bool isActive,
  }) : isActive = isActive.obs;

  get name => null;
}
