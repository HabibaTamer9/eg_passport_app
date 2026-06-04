// import 'dart:ui' as ui;
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:eg_passport_app/profile/profile_screen.dart';
// import 'register/register_screen.dart';
// import 'theme/my_theme_app.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await EasyLocalization.ensureInitialized();

//   runApp(
//     EasyLocalization(
//       supportedLocales: const [
//         Locale('en'),
//         Locale('ar'),
//       ],
//       path: 'assets/translations',
//       fallbackLocale: const Locale('ar'),
//       startLocale: const Locale('ar'),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 840),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (_, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           theme: MyThemeApp.lightTheme,

//           locale: context.locale,
//           supportedLocales: context.supportedLocales,
//           localizationsDelegates: context.localizationDelegates,

//           home: const ProfileScreen(),

//           routes: {
//             RegisterScreen.routeName: (context) => const RegisterScreen(),
//            // LoginScreen.routeName: (context) => const LoginScreen(),
//           },

//           builder: (context, widget) {
//             return Directionality(
//               textDirection: context.locale.languageCode == 'ar'
//                   ? ui.TextDirection.rtl
//                   : ui.TextDirection.ltr,
//               child: widget ?? const SizedBox(),
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eg_passport_app/features/otp/cubit/otp_cubit.dart';
import 'package:eg_passport_app/features/otp/view/otp_screen.dart';

import 'package:eg_passport_app/features/home/cubit/home_cubit.dart';
import 'package:eg_passport_app/features/home/cubit/home_state.dart';
import 'package:eg_passport_app/features/home/view/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        // '/qr-view':          (_) => const QrViewScreen(),
        // '/passport-details': (_) => const PassportDetailsScreen(),
        // '/download-pdf':     (_) => const DownloadPdfScreen(),
        // '/support':          (_) => const SupportScreen(),
      },

      // ── TESTING: HomeScreen with fake data ──
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: SafeArea(
          child: BlocProvider(
            create: (_) => HomeCubit()
              ..loadHomeData(
                user: const UserModel(
                  fullName: 'أحمد محمد علي',
                  nationality: 'Egyptian Citizen',
                  avatarUrl: null,
                ),
                passport: const PassportModel(
                  id: '1',
                  applicationNumber: 'EP-2025-00055047',
                  qrCodeUrl: '',
                  expirySeconds: 169,
                ),
                applicationStatus: const ApplicationStatusModel(
                  steps: [
                    ApplicationStep(
                        label: 'استلام الطلب', status: StepStatus.done),
                    ApplicationStep(
                        label: 'قيد الدراسة', status: StepStatus.done),
                    ApplicationStep(
                        label: 'تحت المعالجة', status: StepStatus.active),
                    ApplicationStep(
                        label: 'قيد المراجعة', status: StepStatus.pending),
                    ApplicationStep(
                        label: 'تم الإصدار', status: StepStatus.pending),
                  ],
                ),
                uploadedDocuments: const [
                  DocumentModel(
                      id: 'doc1', label: 'صورة شخصية', isUploaded: true),
                  DocumentModel(
                      id: 'doc2', label: 'بطاقة الهوية', isUploaded: true),
                ],
                requiredDocuments: const [
                  DocumentModel(
                      id: 'doc1', label: 'صورة شخصية', isUploaded: false),
                  DocumentModel(
                      id: 'doc2', label: 'بطاقة الهوية', isUploaded: false),
                  DocumentModel(
                      id: 'doc3', label: 'عقد الميلاد', isUploaded: false),
                  DocumentModel(
                      id: 'doc4', label: 'جواز السفر', isUploaded: false),
                  DocumentModel(
                      id: 'doc5', label: 'إثبات الإقامة', isUploaded: false),
                ],
              ),
            child: const HomeScreen(),
          ),
        ),
      ),

      // ── PRODUCTION: uncomment this and remove the Scaffold above ──
      // home: BlocProvider(
      //   create: (_) => OtpCubit()..startTimer(),
      //   child: const OtpScreen(),
      // ),
    );
  }
}
