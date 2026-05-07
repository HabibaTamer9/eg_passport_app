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
    return ScreenUtilInit(
        designSize: const Size(360, 840),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_ , child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'First Method',
            home: Scaffold(),
          );
        }
    );
  }
}
