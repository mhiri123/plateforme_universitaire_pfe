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
            Text("REO", style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold)),
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text("HOME", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsScreen()),
                );
              },
              child: Text("NEWS", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsScreen()),
                );
              },
              child: Text("ABOUT US", style: TextStyle(color: Colors.black)),
            ),
            TextButton(onPressed: () {}, child: Text("SERVICES", style: TextStyle(color: Colors.black))),
            TextButton(onPressed: () {}, child: Text("CONTACT", style: TextStyle(color: Colors.black))),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("ENQUIRE TODAY"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text("LOGIN"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProceduresScreen()),
                        );
                      },
                      child: Text("VIEW PROCEDURES"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("CONTACT US"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
