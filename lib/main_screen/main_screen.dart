import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    Center(child: Text("passport".tr())),
    Center(child: Text("document".tr())),
    Center(child: Text("notification".tr())),
    Center(child: Text("profile".tr())),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
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
          Container(
            height: 60,
              width: 40,
              child: Image.asset("assets/egy.png", fit: BoxFit.fill)),
          SizedBox(width: 10.w),
        ],

      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index){
          selectedIndex = index;
          setState(() {

          });
        },
        selectedItemColor: Color(0xffB21A1A),
        unselectedItemColor: Color(0xff44474E),
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.sp),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.sp),
        iconSize: 25.sp,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail_outlined), label: 'passport'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'document'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'notification'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'profile'.tr()),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
