import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/home/views/home_screen.dart';
import 'app/modules/hometeacher/views/hometeacher_view.dart';
import 'app/modules/login/views/login_view.dart';
import 'app/modules/news/views/news_view.dart';
import 'app/modules/procedures/views/procedures_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'REO Platform',
        theme: ThemeData(
          primarySwatch: Colors.red,
          textTheme: TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        home: HomeScreen(),
    );
  }
}