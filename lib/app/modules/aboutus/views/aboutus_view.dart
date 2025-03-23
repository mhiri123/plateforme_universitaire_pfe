import 'package:flutter/material.dart';
import '../../home/views/home_screen.dart';
import '../../login/views/login_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              "REO",
              style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            _buildNavButton(context, "HOME", HomeScreen()),
            _buildNavButton(context, "NEWS", null), // Ajoute l'écran News plus tard
            _buildNavButton(context, "ABOUT US", null),
            _buildNavButton(context, "SERVICES", null),
            _buildNavButton(context, "CONTACT", null),
            SizedBox(width: 20),
            _buildActionButton("ENQUIRE TODAY", Colors.red, () {}),
            SizedBox(width: 10),
            _buildActionButton("LOGIN", Colors.red, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            }),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Fond d'écran flouté
          Positioned.fill(
            child: Image.asset(
              "assets/images/procedures.jpeg",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  SizedBox(height: 30),
                  _buildInfoCard(
                    title: "Our Mission",
                    content: "Our mission is to simplify the process of academic transfers, reorientations, and communication. We aim to provide an easy-to-use platform that enhances the experience for students, teachers, and administrators.",
                    icon: FontAwesomeIcons.bullseye,
                  ),
                  _buildInfoCard(
                    title: "Our Vision",
                    content: "We envision a world where education is more accessible and collaborative. Our platform strives to create an environment where educational institutions can thrive and students can succeed effortlessly.",
                    icon: FontAwesomeIcons.eye,
                  ),
                  _buildInfoCard(
                    title: "Contact Us",
                    content: "For inquiries or support, reach out to us:\n📧 support@yourcompany.com\n📞 +123 456 7890",
                    icon: FontAwesomeIcons.phone,
                  ),
                  SizedBox(height: 20),
                  _buildSocialIcons(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🏠 Bouton de navigation
  Widget _buildNavButton(BuildContext context, String label, Widget? screen) {
    return TextButton(
      onPressed: screen != null
          ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen))
          : null,
      child: Text(label, style: TextStyle(color: Colors.black, fontSize: 16)),
    );
  }

  // 🔴 Bouton d'action principal
  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  // 🌟 En-tête principal
  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "About Us",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 10),
        Container(
          width: 60,
          height: 4,
          color: Colors.red,
        ),
        SizedBox(height: 15),
        Text(
          "We are dedicated to providing innovative solutions for students, teachers, and administrators.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ],
    );
  }

  // 🏆 Carte d'information stylisée
  Widget _buildInfoCard({required String title, required String content, required IconData icon}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.red, size: 36),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                  SizedBox(height: 10),
                  Text(content, style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔗 Icônes sociales
  Widget _buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(FontAwesomeIcons.facebook, Colors.blue, () {}),
        _buildSocialIcon(FontAwesomeIcons.twitter, Colors.lightBlue, () {}),
        _buildSocialIcon(FontAwesomeIcons.linkedin, Colors.blueAccent, () {}),
        _buildSocialIcon(FontAwesomeIcons.instagram, Colors.pink, () {}),
      ],
    );
  }

  // 🔘 Bouton d'icône sociale
  Widget _buildSocialIcon(IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: IconButton(
        icon: Icon(icon, color: color, size: 30),
        onPressed: onTap,
      ),
    );
  }
}
