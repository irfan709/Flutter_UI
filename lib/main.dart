import 'package:flutter/material.dart';
import 'package:flutter_ui/bottom_nav_screen.dart';
import 'package:flutter_ui/botton_nav_hide_show.dart';
import 'package:flutter_ui/chat_screen.dart';
import 'package:flutter_ui/chips_example_screen.dart';
import 'package:flutter_ui/expandable_nav_screen.dart';
import 'package:flutter_ui/login_page.dart';
import 'package:flutter_ui/onboarding_screen.dart';
import 'package:flutter_ui/page_transistion.dart';
import 'package:flutter_ui/scrolling_fab_screen.dart';
import 'package:flutter_ui/swipeable_list_screen.dart';
import 'package:flutter_ui/transistions_example_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MainScreen(),
    );
  }
}
