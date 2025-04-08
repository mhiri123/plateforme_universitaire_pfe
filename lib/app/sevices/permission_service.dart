import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/permission.dart';

class PermissionService {
  static Future<List<Permission>> getUserPermissions(int userId) async {
    final response = await http.get(Uri.parse("https://tonserveur.com/api/get_user_permissions.php?user_id=$userId"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((perm) => Permission.fromJson({'name': perm})).toList();
    } else {
      throw Exception("Échec de chargement des permissions");
    }
  }
}
