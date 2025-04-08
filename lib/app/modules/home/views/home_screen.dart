import 'package:flutter/material.dart';
import '../../aboutus/views/aboutus_view.dart';
import '../../login/views/login_view.dart';
import '../../news/views/news_view.dart';
import '../../procedures/views/procedures_view.dart';

class HomeScreen extends StatelessWidget {
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
            _buildAppBarButton(context, "HOME", () {}),
            _buildAppBarButton(context, "NEWS", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsScreen()));
            }),
            _buildAppBarButton(context, "ABOUT US", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen()));
            }),
            _buildAppBarButton(context, "SERVICES", () {}),
            _buildAppBarButton(context, "CONTACT", () {}),
            SizedBox(width: 20),
            _buildElevatedButton("ENQUIRE TODAY", Colors.red, () {}),
            SizedBox(width: 10),
            _buildElevatedButton("LOGIN", Colors.red, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            }),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.jpeg",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("WE ARE YOUR INDUSTRY PROBLEM SOLVER", style: TextStyle(fontSize: 18, color: Colors.white70)),
                SizedBox(height: 10),
                Text("WE ARE THE TEAM OF PROFESSIONALS", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildElevatedButton("VIEW PROCEDURES", Colors.blue, () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProceduresScreen()));
                    }),
                    SizedBox(width: 10),
                    _buildElevatedButton("CONTACT US", Colors.red, () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to create AppBar buttons
  Widget _buildAppBarButton(BuildContext context, String label, Function onPressed) {
    return TextButton(
      onPressed: () => onPressed(),
      child: Text(label, style: TextStyle(color: Colors.black)),
    );
  }

  // Function to create Elevated buttons
  Widget _buildElevatedButton(String label, Color color, Function onPressed) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(label),
      style: ElevatedButton.styleFrom(backgroundColor: color),
    );
  }
}
