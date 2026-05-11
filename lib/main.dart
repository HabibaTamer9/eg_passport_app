import 'package:eg_passport_app/customs/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      initialRoute:CustomButton.routeName ,
      routes: {
        CustomButton.routeName:(context)=> CustomButton( textName:"register"),
      },


    );
  }
}
