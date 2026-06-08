import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/features/digital_passport/digital_passport_screen.dart';
import 'package:eg_passport_app/features/documents/presentation/documents_management_screen.dart';
import 'package:eg_passport_app/features/home/view/digital_passport.dart';
import 'package:eg_passport_app/features/notification_screen/notification_ui.dart';
import 'package:eg_passport_app/features/requests/presentation/my_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../home_screen/home_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    DigitalPassportScreen(),
    DocumentsManagementScreen(),
    MyRequestsScreen(),
    NotificationUi(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfFFAFAFA),
      appBar: AppBar(
        toolbarHeight: 70,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Egy',
                  style: TextStyle(
                    color: Color(0xffB21A1A),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' E-Passport',
                  style: TextStyle(
                    color: Color(0xff44474E),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
            )]
            )),
            Text("الهوية الرقمية للسفر", style: TextStyle(
              color: Color(0xff44474E),
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ))
          ],
        ),
        centerTitle: true,
        leading: Icon(Icons.menu, color: Color(0xff44474E), size: 30.sp),
        actions: [
          SizedBox(
            height: 60,
              width: 45,
              child: Image.asset("assets/images/egy.png", fit: BoxFit.fill)),
          SizedBox(width: 10.w),
        ],

      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index){
          selectedIndex = index;
          setState(() {

          });
        },
        selectedItemColor: Color(0xffB21A1A),
        unselectedItemColor: Color(0xff44474E),
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp),
        iconSize: 20.sp,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail_outlined), label: 'passport'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.folder_copy_outlined), label: 'document'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'requests'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'notification'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'profile'.tr()),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
