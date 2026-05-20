import 'package:easy_localization/easy_localization.dart' show EasyLocalization, BuildContextEasyLocalizationExtension;
import 'package:eg_passport_app/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'register/register_screen.dart';
import 'theme/my_theme_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'), // 🔥 مهم جدًا
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 840),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: MyThemeApp.lightTheme,

          // 🔥 localization
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,

          // 🔥 الاتجاه الصح (RTL/LTR)
          builder: (context, widget) {
            return Directionality(
              textDirection: context.locale.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: widget ?? const SizedBox(),
            );
          },

          home: const RegisterScreen(),
            routes: {
              RegisterScreen.routeName: (context) => const RegisterScreen(),
             Loginscreen.routeName: (context) => const Loginscreen(),
            }
        );
      },
    );
  }
}
