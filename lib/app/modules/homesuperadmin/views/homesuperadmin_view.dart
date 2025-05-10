import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plateforme_universitaire/app/routes/app_pages.dart';
import '../controllers/homesuperadmin_controller.dart';

class SuperAdminHomeScreen extends StatelessWidget {
  final SuperAdminHomeController controller = Get.put(SuperAdminHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.refresh, color: Colors.white),
        onPressed: controller.refreshAllData,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Tableau de Bord Super Admin",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      actions: [
        Obx(() => IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications, color: Colors.white),
              if (controller.notificationCount.value > 0)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      controller.notificationCount.value.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () => _navigateToRoute(Routes.NOTIFICATION),
        )),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          ...menuItems.map((item) => _buildDrawerItem(item)).toList(),
          const Divider(height: 1, thickness: 1),
          _buildLogoutTile(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      accountName: const Text("Super Administrateur",
          style: TextStyle(fontWeight: FontWeight.bold)),
      accountEmail: const Text("superadmin@univ.edu"),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.admin_panel_settings, size: 40, color: Colors.blue),
      ),
    );
  }

  Widget _buildDrawerItem(Map<String, dynamic> item) {
    return ListTile(
      leading: Icon(item["icon"], color: Colors.blue.shade800),
      title: Text(item["title"]),
      selected: Get.currentRoute == item["route"],
      selectedTileColor: Colors.blue.shade50,
      onTap: () {
        Get.back();
        _navigateToRoute(item["route"]);
      },
    );
  }

  void _navigateToRoute(String route) {
    if (Get.isDialogOpen ?? false) Get.back();
    if (Get.currentRoute == route) return;

    Get.toNamed(route)?.catchError((error) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'accéder à cette fonctionnalité',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    });
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text("Déconnexion", style: TextStyle(color: Colors.red)),
      onTap: () {
        Get.defaultDialog(
          title: "Confirmation",
          middleText: "Êtes-vous sûr de vouloir vous déconnecter?",
          textConfirm: "Oui",
          textCancel: "Non",
          confirmTextColor: Colors.white,
          onConfirm: () => Get.offAllNamed(Routes.LOGIN),
        );
      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 20),
              _buildSectionTitle("Gestion Principale"),
              const SizedBox(height: 10),
              _buildMainFeaturesGrid(),
              const SizedBox(height: 20),
              _buildSectionTitle("Outils Secondaires"),
              const SizedBox(height: 10),
              _buildSecondaryFeaturesGrid(),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.waving_hand, size: 30, color: Colors.amber),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bienvenue, Super Admin!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Obx(() => Text(
                    "Vous avez ${controller.notificationCount.value} notifications et ${controller.requests.length} demandes en attente",
                    style: TextStyle(color: Colors.grey.shade600),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
      ),
    );
  }

  Widget _buildMainFeaturesGrid() {
    return _buildFeatureGrid(dashboardItems.sublist(0, 4));
  }

  Widget _buildSecondaryFeaturesGrid() {
    return _buildFeatureGrid(dashboardItems.sublist(4));
  }

  Widget _buildFeatureGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildFeatureCard(items[index]);
      },
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> item) {
    return SizedBox(
      height: 160,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToRoute(item["route"]),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  item["color"].withOpacity(0.8),
                  item["color"].withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item["icon"], size: 28, color: Colors.white),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    item["title"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> menuItems = [
  {"icon": Icons.dashboard, "title": "Tableau de Bord", "route": Routes.HOMESUPERADMIN},
  {"icon": Icons.school, "title": "Facultés", "route": Routes.FACULTY_MANAGEMENT},
  {"icon": Icons.admin_panel_settings, "title": "Administrateurs", "route": Routes.ADMIN_MANAGEMENT},
  {"icon": Icons.people, "title": "Utilisateurs", "route": Routes.USER_MANAGEMENT},
  {"icon": Icons.assignment, "title": "Demandes", "route": Routes.REQUEST_MANAGEMENT},
  {"icon": Icons.security, "title": "Permissions", "route": Routes.PERMISSION_MANAGEMENT},
  {"icon": Icons.message, "title": "Messagerie", "route": Routes.CHAT},
  {"icon": Icons.notifications, "title": "Notifications", "route": Routes.NOTIFICATION},
];

final List<Map<String, dynamic>> dashboardItems = [
  {"title": "Facultés", "icon": Icons.school, "color": Colors.green, "route": Routes.FACULTY_MANAGEMENT},
  {"title": "Administrateurs", "icon": Icons.admin_panel_settings, "color": Colors.orange, "route": Routes.ADMIN_MANAGEMENT},
  {"title": "Utilisateurs", "icon": Icons.people, "color": Colors.purple, "route": Routes.USER_MANAGEMENT},
  {"title": "Demandes", "icon": Icons.assignment, "color": Colors.red, "route": Routes.REQUEST_MANAGEMENT},
  {"title": "Permissions", "icon": Icons.security, "color": Colors.cyan, "route": Routes.PERMISSION_MANAGEMENT},
  {"title": "Messagerie", "icon": Icons.message, "color": Colors.blueGrey, "route": Routes.CHAT},
  {"title": "Notifications", "icon": Icons.notifications, "color": Colors.indigo, "route": Routes.NOTIFICATION},
];