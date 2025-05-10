import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../models/faculty.dart';

class FacultyController extends GetxController {
  var isLoading = true.obs;
  var facultyList = <Faculty>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaculties();
  }

  Future<void> fetchFaculties() async {
    try {
      isLoading(true);

      final dio = Dio();
      final response = await dio.get("http://192.168.1.17:8000/api/faculties");

      if (response.statusCode == 200 && response.data != null) {
        // 💡 Vérifie que response.data est bien une List
        if (response.data is List) {
          facultyList.value =
              (response.data as List).map((e) => Faculty.fromJson(e)).toList();
        } else {
          print("⚠️ Données reçues inattendues : ${response.data}");
        }
      } else {
        print("❌ Erreur API: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Erreur lors du chargement des facultés : $e");
    } finally {
      isLoading(false);
    }
  }
  List<Faculty> get faculties => facultyList;

  Faculty? getFacultyById(int id) {
    return facultyList.firstWhereOrNull((faculty) => faculty.id == id);
  }
}
