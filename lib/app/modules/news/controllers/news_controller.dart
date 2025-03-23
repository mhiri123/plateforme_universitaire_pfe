import 'package:get/get.dart';
import '../../../models/news.dart';

import '../../../sevices/news_service.dart';


class NewsController extends GetxController {
  var newsList = <News>[].obs; // Liste des actualités (observable)
  var isLoading = false.obs;   // Indicateur de chargement

  @override
  void onInit() {
    super.onInit();
    fetchNews(); // Charger les news au démarrage
  }

  // Fonction pour récupérer les actualités depuis l'API
  void fetchNews() async {
    try {
      isLoading(true);
      var fetchedNews = await NewsService.getNews();
      if (fetchedNews != null) {
        newsList.assignAll(fetchedNews);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load news: $e");
    } finally {
      isLoading(false);
    }
  }
}
